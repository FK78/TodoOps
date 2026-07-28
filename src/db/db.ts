import mongoose from "mongoose";

export const connectDB = async () => {
  if (!process.env.MONGODB_URI) {
    throw new Error("MongoDB URI must be set");
  }
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log("MongoDB connected");
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err);
    console.error("MongoDB connection error:", message);
    throw new Error(`MongoDB connection error: ${message}`);
  }
};
