import mysql from "mysql2";
import dotenv from "dotenv";

// Load .env file (untuk pemakaian lokal)
dotenv.config();

const connection = mysql.createConnection({
  host: process.env.MYSQLHOST,
  user: process.env.MYSQLUSER,
  password: process.env.MYSQLPASSWORD,
  database: process.env.MYSQLDATABASE,
  port: process.env.MYSQLPORT, // tambahkan port
});

connection.connect((err) => {
  if (err) {
    console.error("Database connection failed:", err.stack);
    return;
  }
  console.log("Database Connected.");
});

export default connection;
