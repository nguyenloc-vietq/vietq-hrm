import {
  CanActivate,
  ExecutionContext,
  HttpException,
  Inject,
  Injectable,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { JwtService } from "@nestjs/jwt";
import { Observable } from "rxjs";
import { AuthService } from "src/auth/auth.service";

@Injectable()
export class PermissionRbacGuard implements CanActivate {
  @Inject(AuthService)
  private readonly authService: AuthService;

  @Inject()
  private reflector: Reflector;
  async canActivate(context: ExecutionContext): Promise<boolean> {
    console.log(`[===============> PERMISSION RBAC |`);
    const isPermitAll = this.reflector.getAllAndOverride<boolean>(
      "isPermitAll",
      [context.getHandler(), context.getClass()],
    );
    console.log(`[===============> PERMITALL | ${isPermitAll}`);
    if (isPermitAll) {
      return true;
    }

    //get user
    const userContext = context.switchToHttp().getRequest().user;
    if (!userContext) return false;

    // get all permission
    const userPermissions = await this.authService.getUserPermission(
      userContext.id,
    );
    if (!userPermissions || userPermissions.length == 0) {
      throw new HttpException("user has no permission", 401);
    }
    const request: Request = context.switchToHttp().getRequest();
    request["permission"] = userPermissions;

    //check permission
    const IsPermission = this.reflector.getAllAndOverride<Array<string>>(
      "isPermissionRequired",
      [context.getHandler(), context.getClass()],
    );

    if (!IsPermission) return true;

    const hasPermission = userPermissions.some(
      (up) =>
        up.rolePermissions &&
        up.rolePermissions.some((rp) => IsPermission.includes(rp.name)),
    );

    if (!hasPermission) {
      throw new HttpException("user has no permission", 401);
    }
    console.log(hasPermission);
    return true;
  }
}
