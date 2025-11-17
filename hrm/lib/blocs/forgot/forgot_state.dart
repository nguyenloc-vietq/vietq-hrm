part of 'forgot_bloc.dart';

class ForgotState extends Equatable with FormzMixin {
  const ForgotState({
    this.email = const Email.pure(),
    this.otp = const Otp.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.currentStep = ForgotStep.email,
    this.passwordComfrim = const ConfirmPassword.pure( ),
  });

  final Email email;
  final Otp otp;
  final Password password;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final ForgotStep currentStep;
  final ConfirmPassword passwordComfrim;

  // Validate only inputs of the current step
  @override
  List<FormzInput> get inputs {
    switch (currentStep) {
      case ForgotStep.email:
        return [email];
      case ForgotStep.otp:
        return [otp];
      case ForgotStep.password:
        return [password, passwordComfrim];
    }
  }

  ForgotState copyWith({
    Email? email,
    Otp? otp,
    Password? password,
    FormzSubmissionStatus? status,
    String? errorMessage,
    ForgotStep? currentStep,
    ConfirmPassword? passwordComfrim,
  }) {
    return ForgotState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentStep: currentStep ?? this.currentStep,
      passwordComfrim: passwordComfrim ?? this.passwordComfrim,
    );
  }

  @override
  List<Object?> get props => [email, otp, password, passwordComfrim, status, errorMessage, currentStep];
}


