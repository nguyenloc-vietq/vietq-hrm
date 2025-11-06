export class ResponseDataSuccess<d extends object | object[]> {
  data: d | d[];
  error: boolean;
  statusCode: number;
  message: string;

  constructor(data: d | d[], statusCode: number, message: string) {
    this.error = false;
    this.data = data;
    this.statusCode = statusCode;
    this.message = message;
    return this;
  }
}
