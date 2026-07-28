import { Schema, model } from "mongoose";

interface ITodo {
  title: string;
  completed: boolean;
  createdAt: Date;
}

const todoSchema = new Schema<ITodo>({
  title: { type: String, required: true, trim: true },
  completed: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now },
});

export const Todo = model<ITodo>("Todo", todoSchema);
