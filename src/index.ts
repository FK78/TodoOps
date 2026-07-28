import express from "express";
import { connectDB } from "./db/db.js";
import todoRouter from "./routes/todo.router.ts";

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use("/todos", todoRouter);

try {
  await connectDB();
  app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
} catch (err) {
  console.error("Failed to start", err);
  process.exit(1);
}
