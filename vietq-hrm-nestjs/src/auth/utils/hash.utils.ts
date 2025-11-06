import * as bcrypt from "bcryptjs";

// Mã hóa mật khẩu
export async function hashPassword(password: string): Promise<string> {
  const salt = await bcrypt.genSalt(10);
  return bcrypt.hash(password, salt);
}

// So sánh mật khẩu khi login
export async function comparePassword(
  password: string,
  hashed: string,
): Promise<boolean> {
  return bcrypt.compare(password, hashed);
}
