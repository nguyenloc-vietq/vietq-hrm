part of 'forgot_bloc.dart';

abstract class ForgotEvent {}

class EmailChanged extends ForgotEvent {
  final String email;
  EmailChanged(this.email);
}

class OtpChanged extends ForgotEvent {
  final String otp;
  OtpChanged(this.otp);
}

class PasswordChanged extends ForgotEvent {
  final String password;
  PasswordChanged(this.password);
}

class PasswordComfrimChange extends ForgotEvent {
  final String passwordComfrim;
  PasswordComfrimChange(this.passwordComfrim);
}

class ForgotNextStep extends ForgotEvent {}
class ForgotSubmitted extends ForgotEvent {}
class ForgotResent extends ForgotEvent {}
class VerifyOtpSubmitted extends ForgotEvent {}

class ChangePasswordSubmitted extends ForgotEvent {}