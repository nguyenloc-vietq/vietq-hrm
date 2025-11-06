import { ApiProperty } from "@nestjs/swagger";

export class LoginAuthDto {
  @ApiProperty({
    description: "Email address",
    example: "j7xYV@example.com",
  })
  email: string;
  @ApiProperty({
    description: "Your password",
    example: "123456",
  })
  password: string;
}

export class LoginAuthRespone {
  @ApiProperty()
  access_token: string;
}
