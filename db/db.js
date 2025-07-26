import mysql from "mysql2";

const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "railway",
});

connection.connect((err) => {
  if (err) {
    throw err;
  } else {
    console.log("Database Connected.");
  }
});

export default connection;
