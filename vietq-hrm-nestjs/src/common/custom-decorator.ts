import { SetMetadata } from "@nestjs/common";

export const IS_PERMITALL = "isPermitAll";
export const PermitAll = () => SetMetadata(IS_PERMITALL, true);

export const IS_PERMISION_REQUIRED = "isPermissionRequired";
export const PermissionRequired = (...permissions: string[]) =>
  SetMetadata(IS_PERMISION_REQUIRED, permissions);
