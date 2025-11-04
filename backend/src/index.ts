import compression from "compression";
import helmet from "helmet";
import express, { NextFunction, Request, Response } from "express";
import ApiError from "./utils/apiErrors";
import { errorHandlingMiddleware } from "./middlewares/errorMiddlewares";
import morgan from "morgan";
const app = express();
//use pakage
app.use(express.json());
app.use(morgan("dev"));
app.use(helmet());
app.use(compression());

//routes

const PORT = process.env.PORT || 3000;

import authRouter from './routes/auth.routes'
app.use('/api/auth', authRouter)
//error handler 404
app.use((req: Request, res: Response, next: NextFunction) => {
  const error = new ApiError(404, `Not Found - ${req.originalUrl}`);
  next(error); // đẩy vào errorHandlingMiddleware
});
app.use(errorHandlingMiddleware);
//error handler
app.listen(PORT, () => {
  console.log("Server is running on ", process.env.HOST + ":" + PORT);
});
