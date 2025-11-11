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

// PASSWORD
enum PasswordError { empty, tooShort }

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