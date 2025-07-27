import express from "express";
import bcrypt from "bcrypt";
import conn from "../db/db.js"; // sekarang ini pool dari mysql2/promise

const router = express.Router();

// Register
router.post("/register", async (req, res) => {
  const { name, email, password } = req.body;
  try {
    const hashed = await bcrypt.hash(password, 10);
    await conn.query("INSERT INTO users (name, email, password) VALUES (?, ?, ?)", [
      name,
      email,
      hashed,
    ]);
    res.redirect("/");
  } catch (err) {
    console.error("Error saat register:", err);
    res.send("Error register");
  }
});

// Login
router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  try {
    const [results] = await conn.query("SELECT * FROM users WHERE email = ?", [email]);
    if (results.length === 0) return res.send("Login gagal");

    const match = await bcrypt.compare(password, results[0].password);
    if (!match) return res.send("Password salah");

    req.session.user = {
      id: results[0].id,
      name: results[0].name,
      role: results[0].role,
    };
    res.redirect("/dashboard");
  } catch (err) {
    console.error("Login error:", err);
    res.send("Terjadi kesalahan saat login");
  }
});

// Dashboard
router.get("/dashboard", async (req, res) => {
  if (!req.session.user) return res.redirect("/login");
  try {
    const [results] = await conn.query('SELECT * FROM materi WHERE status = "approved"');
    res.render("dashboard", { user: req.session.user, courses: results });
  } catch (err) {
    res.send("Error ambil data");
  }
});

// Logout
router.get("/logout", (req, res) => {
  req.session.destroy();
  res.redirect("/");
});

// My Courses
router.get("/my-courses", async (req, res) => {
  if (!req.session.user) return res.redirect("/login");
  try {
    const [results] = await conn.query('SELECT * FROM materi WHERE status = "approved"');
    res.render("my-courses", { materi: results });
  } catch (err) {
    res.send("Gagal mengambil data materi");
  }
});

// Detail Materi + Komentar
router.get("/materi/:id", async (req, res) => {
  if (!req.session.user) return res.redirect("/");

  const materiId = req.params.id;

  try {
    const [materiResults] = await conn.query(
      "SELECT * FROM materi WHERE id = ? AND status = 'approved'",
      [materiId]
    );

    if (materiResults.length === 0) return res.send("Materi tidak ditemukan");
    const materi = materiResults[0];

    const [komentarResults] = await conn.query(
      "SELECT * FROM komentar WHERE materi_id = ? ORDER BY created_at ASC",
      [materiId]
    );

    res.render("materi-detail", {
      user: req.session.user,
      materi,
      komentar: komentarResults,
    });
  } catch (err) {
    console.error("SQL Error:", err);
    res.send("Gagal mengambil materi atau komentar");
  }
});

// Kirim komentar
router.post("/komentar", async (req, res) => {
  const { materi_id, content } = req.body;
  try {
    await conn.query("INSERT INTO komentar (materi_id, content) VALUES (?, ?)", [
      materi_id,
      content,
    ]);
    res.redirect("/materi/" + materi_id);
  } catch (err) {
    res.send("Gagal kirim komentar");
  }
});

// Komentar dengan parent (threaded)
router.post("/komentar/:materiId", async (req, res) => {
  if (!req.session.user) return res.redirect("/login");

  const { materi_id, content, parent_id } = req.body;
  const userId = req.session.user.id;

  try {
    await conn.query(
      "INSERT INTO komentar (materi_id, user_id, content, parent_id) VALUES (?, ?, ?, ?)",
      [materi_id, userId, content, parent_id || null]
    );
    res.redirect("/materi/" + materi_id);
  } catch (err) {
    res.send("Gagal menyimpan komentar");
  }
});

// Balas komentar
router.post("/komentar/reply", async (req, res) => {
  const { materi_id, parent_id, content } = req.body;
  try {
    await conn.query(
      "INSERT INTO komentar (materi_id, content, parent_id) VALUES (?, ?, ?)",
      [materi_id, content, parent_id]
    );
    res.redirect("/materi/" + materi_id);
  } catch (err) {
    res.send("Gagal kirim balasan");
  }
});

// Upload materi
router.post("/upload-materi", async (req, res) => {
  const { title, description, file_path } = req.body;
  try {
    await conn.query(
      "INSERT INTO materi (title, description, file_path, status) VALUES (?, ?, ?, 'pending')",
      [title, description, file_path]
    );
    res.redirect("/dashboard");
  } catch (err) {
    res.send("Gagal upload materi");
  }
});

router.get("/upload-materi", (req, res) => {
  if (!req.session.user) return res.redirect("/login");
  res.render("upload-materi", { user: req.session.user });
});

// Admin approval page
router.get("/admin/approval", async (req, res) => {
  try {
    const [results] = await conn.query("SELECT * FROM materi WHERE status = 'pending'");
    res.render("approval-page", {
      materiList: results,
      user: req.session.user,
    });
  } catch (err) {
    res.send("Gagal mengambil data materi");
  }
});

// Admin approve materi
router.post("/admin/approve/:id", async (req, res) => {
  try {
    await conn.query("UPDATE materi SET status = 'approved' WHERE id = ?", [req.params.id]);
    res.redirect("/admin/approval");
  } catch (err) {
    res.send("Gagal menyetujui");
  }
});

// Admin reject materi
router.post("/admin/reject/:id", async (req, res) => {
  try {
    await conn.query("UPDATE materi SET status = 'rejected' WHERE id = ?", [req.params.id]);
    res.redirect("/admin/approval");
  } catch (err) {
    res.send("Gagal menolak");
  }
});

export default router;
