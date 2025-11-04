import { NextFunction , Request, Response } from "express";
import { StatusCodes } from "http-status-codes";
import authModel from "../models/auth.model";
import ApiError from "../utils/apiErrors";
import authService from "../services/auth";
import apiResponse from "../core/respone";

const authControllelr = {
   async login(req: Request, res: Response, next: NextFunction) {
      try {
         // handle login models 
         const { login, password } = req.body;
         // check email or phone exits 
         const user = await authModel.getUserAuth(login);
         if(!user) {
            return next(new ApiError(StatusCodes.UNAUTHORIZED, "Email or phone not exits"));
         }
         const { PasswordHash, ...dataUser } = user as {PasswordHash: string};
         // check password
         const isMatch = await authService.verifyPassword(password, PasswordHash);
         if(!isMatch) {
            return next(new ApiError(StatusCodes.UNAUTHORIZED, "Invalid username or password"));
         }
         // return token
         const token = await authService.generateAccessToken(dataUser);
         const refreshToken = await authService.generateRefreshToken(dataUser);
         return apiResponse.success(res, {
            ...dataUser,
            token,
            refreshToken
         }, "Login Success", StatusCodes.OK);

      } catch (error: Error | any) {
         next(new ApiError(StatusCodes.UNAUTHORIZED, error.message || "Login Error"));
      }
   }
}

export default authControllelr;