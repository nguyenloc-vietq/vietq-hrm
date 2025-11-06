import { Inject, Injectable } from "@nestjs/common";
import { CreateAuthDto } from "./dto/create-auth.dto";
import { UpdateAuthDto } from "./dto/update-auth.dto";
import { JwtService } from "@nestjs/jwt";

@Injectable()
export class AuthService {
  @Inject("JwtService")
  private jwtService: JwtService;
}
