import 'package:formz/formz.dart';

// EMAIL
enum EmailError { empty, invalid }

class Email extends FormzInput<String, EmailError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailError? validator(String value) {
    if (value.isEmpty) return EmailError.empty;
    if (!_emailRegex.hasMatch(value)) return EmailError.invalid;
    return null;
  }
}

// Otp
enum OtpError { empty, invalid }

class Otp extends FormzInput<String, OtpError> {
  const Otp.pure() : super.pure('');
  const Otp.dirty([super.value = '']) : super.dirty();

  @override
  OtpError? validator(String value) {
    if (value.isEmpty) return OtpError.empty;
    if (value.length < 6) return OtpError.invalid;
    return null;
  }
}

enum PasswordError { empty, tooShort, notMatch }

class Password extends FormzInput<String, PasswordError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordError? validator(String value) {
    if (value.isEmpty) return PasswordError.empty;
    if (value.length < 6) return PasswordError.tooShort;
    return null;
  }
}
enum ConfirmPasswordError { empty, tooShort, notMatch }

class ConfirmPassword extends FormzInput<String, ConfirmPasswordError> {
  final String original; // giá trị password gốc

  const ConfirmPassword.pure({this.original = ''}) : super.pure('');
  const ConfirmPassword.dirty({required this.original, String value = ''}) : super.dirty(value);

  @override
  ConfirmPasswordError? validator(String value) {
    if (value.isEmpty) return ConfirmPasswordError.empty;
    if (value.length < 6) return ConfirmPasswordError.tooShort;
    if (value != original) return ConfirmPasswordError.notMatch; // so sánh đúng
    return null;
  }
}

enum ForgotStep { email, otp, password }
