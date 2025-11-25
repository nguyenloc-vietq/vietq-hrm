import { HandlebarsAdapter } from "@nestjs-modules/mailer/dist/adapters/handlebars.adapter";
import { MailerModule } from "@nestjs-modules/mailer";
// src/email/email.module.ts
import { Module } from "@nestjs/common";
import { SmtpService } from "./smtp.service";
import { join } from "path";

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
        dir: join(__dirname, "templates"),
        adapter: new HandlebarsAdapter(), // bạn có thể dùng handlebars adapter
        options: { strict: true },
      },
    }),
  ],
  providers: [SmtpService],
  exports: [SmtpService], // nếu muốn dùng service ở module khác
})
export class SmtpModule {}
