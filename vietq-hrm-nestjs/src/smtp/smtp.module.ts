// src/email/email.module.ts
import { Module } from "@nestjs/common";
import { MailerModule } from "@nestjs-modules/mailer";
import { join } from "path";
import { SmtpService } from "./smtp.service";
import { HandlebarsAdapter } from "@nestjs-modules/mailer/dist/adapters/handlebars.adapter";

@Module({
  imports: [
    MailerModule.forRoot({
      transport: {
        host: process.env.HOST_SMTP,
        port: 587,
        secure: false, // true với port 465
        auth: {
          user: process.env.USER_SMTP,
          pass: process.env.PASS_SMTP, // App password nếu dùng Gmail 2FA
        },
      },
      defaults: {
        from: '"No Reply" <no-reply@example.com>',
      },
      template: {
        dir: join(process.cwd(), "src/smtp/templates"),
        adapter: new HandlebarsAdapter(), // bạn có thể dùng handlebars adapter
        options: { strict: true },
      },
    }),
  ],
  providers: [SmtpService],
  exports: [SmtpService], // nếu muốn dùng service ở module khác
})
export class SmtpModule {}
