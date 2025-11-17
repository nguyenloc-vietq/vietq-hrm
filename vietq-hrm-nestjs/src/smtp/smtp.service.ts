import { MailerService } from "@nestjs-modules/mailer";
import { Injectable } from "@nestjs/common";

@Injectable()
export class SmtpService {
  constructor(private readonly mailerService: MailerService) {}

  async sendOtpEmail(to: string, code: string) {
    await this.mailerService.sendMail({
      to,
      subject: "Mã OTP của bạn",
      template: "otp", // tên file otp.hbs
      context: { code }, // truyền dữ liệu cho template
    });
  }
}
