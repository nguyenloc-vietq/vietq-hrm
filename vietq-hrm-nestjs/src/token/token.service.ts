/* eslint-disable @typescript-eslint/no-explicit-any */
import { Injectable } from "@nestjs/common";
import * as CryptoJS from "crypto-js";
@Injectable()
export class TokenService {
  private readonly secretKey: string =
    process.env.CUSTOM_TOKEN_SECRET || "my-secret-key";

  sign(data: any) {
    const plainText = JSON.stringify(data);
    const cipherText = CryptoJS.AES.encrypt(
      plainText,
      this.secretKey,
    ).toString();
    return cipherText;
  }

  verify(token: string) {
    try {
      const bytes = CryptoJS.AES.decrypt(token, this.secretKey);
      const plainText = bytes.toString(CryptoJS.enc.Utf8);
      return JSON.parse(plainText);
    } catch (e) {
      return null;
    }
  }
}
