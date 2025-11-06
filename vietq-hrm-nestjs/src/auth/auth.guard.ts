import {
  CanActivate,
  ExecutionContext,
  HttpException,
  Inject,
  Injectable,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { JwtService } from "@nestjs/jwt";
import { Request } from "express";
import { Observable } from "rxjs";
import { IS_PERMITALL } from "src/common/custom-decorator";

@Injectable()
export class AuthGuard implements CanActivate {
  @Inject(JwtService)
  private readonly jwtService: JwtService;

  @Inject()
  private reflector: Reflector;
  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const request: Request = context.switchToHttp().getRequest();
    const isPermitAll = this.reflector.getAllAndOverride<boolean>(
      IS_PERMITALL,
      [context.getHandler(), context.getClass()],
    );
    console.log(`[===============> PERMITALL | ${isPermitAll}`);
    if (isPermitAll) {
      return true;
    }
    if (!request.headers.authorization) {
      throw new HttpException("Unauthorized", 401);
    }
    const token = request.headers.authorization.split(" ")[1];
    if (!token) {
      throw new HttpException("No token provided", 401);
    }
    //verify token
    try {
      const decodedToken = this.jwtService.verify(token);
      console.log(`[===============> | ${decodedToken}`);
      request["user"] = decodedToken;
    } catch (error) {
      throw new HttpException("Unauthorized", 401);
    }
    return true;
  }
}
