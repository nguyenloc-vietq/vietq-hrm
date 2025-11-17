import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vietq_hrm/blocs/login/login_event.dart';
import 'package:vietq_hrm/configs/apiConfig/auth.api.dart';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';
import 'package:vietq_hrm/models/forgot.models.dart';

part 'forgot_event.dart';
part 'forgot_state.dart';

class ForgotBloc extends Bloc<ForgotEvent, ForgotState> {
  late String token;
  ForgotBloc() : super(const ForgotState()) {
    on<EmailChanged>(_onEmailChanged);
    on<OtpChanged>(_onOtpChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordComfrimChange>(_onPasswordComfrimChange);
    on<ForgotSubmitted>(_onForgotSubmitted);
    on<VerifyOtpSubmitted>(_onVerifyOtpSubmitted);
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
    on<ForgotResent>((event, emit) async {
      final email = Email.dirty(state.email.value);
      emit(state.copyWith(
        email: email,
      ));

      // Kiểm tra hợp lệ
      if (!Formz.validate([email])) {
        // emit(state.copyWith(status: FormzSubmissionStatus.initial));
        return;
      }
      try {
        await AuthApi().sentOtp(email.value);
      } catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    });
    on<ForgotNextStep>((event, emit) {
      // Chỉ đi tiếp khi step hiện tại hợp lệ
      if (state.isValid) {
        ForgotStep nextStep;
        switch (state.currentStep) {
          case ForgotStep.email:
            nextStep = ForgotStep.otp;
            break;
          case ForgotStep.otp:
            nextStep = ForgotStep.password;
            break;
          case ForgotStep.password:
            nextStep = ForgotStep.password;
            break;
        }
        print(state.email.value);
        emit(state.copyWith(currentStep: nextStep));
      }
    });

  }
  void _onPasswordChanged(PasswordChanged event, Emitter<ForgotState> emit) {
    final password = Password.dirty(event.password);

    // Re-validate confirm password
    final confirm = ConfirmPassword.dirty(
      original: password.value, // update original mới
      value: state.passwordComfrim.value, // giữ giá trị đã nhập
    );

    emit(state.copyWith(
      password: password,
      passwordComfrim: confirm,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onPasswordComfrimChange(PasswordComfrimChange event, Emitter<ForgotState> emit) {
    final confirm = ConfirmPassword.dirty(
      original: state.password.value,
      value: event.passwordComfrim,
    );

    emit(state.copyWith(
      passwordComfrim: confirm,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onEmailChanged(EmailChanged event, Emitter<ForgotState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      // status: Formz.validate([email, state.password]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onOtpChanged(OtpChanged event, Emitter<ForgotState> emit) {
    final otp = Otp.dirty(event.otp);
    emit(state.copyWith(
      otp: otp,
      // status: Formz.validate([state.email, password]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onForgotSubmitted(ForgotSubmitted event, Emitter<ForgotState> emit) async {
    final email = Email.dirty(state.email.value);
    emit(state.copyWith(
      email: email,
    ));

    // Kiểm tra hợp lệ
    if (!Formz.validate([email])) {
      // emit(state.copyWith(status: FormzSubmissionStatus.initial));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await AuthApi().sentOtp(email.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      add(ForgotNextStep());
      // Navigator.of(context).pushNamed('/home');
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
  Future<void> _onVerifyOtpSubmitted(VerifyOtpSubmitted event, Emitter<ForgotState> emit) async {
    final otp = Otp.dirty(state.otp.value);
    final email = Email.dirty(state.email.value);
    emit(state.copyWith(
      otp: otp,
      email: email,
    ));

    // Kiểm tra hợp lệ
    if (!Formz.validate([otp])) {
      // emit(state.copyWith(status: FormzSubmissionStatus.initial));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      //verify otp
      final dataValidate = await AuthApi().verifyOtp(email: state.email.value, otp: state.otp.value);
      token = dataValidate['token'];
      print("#==========> TOKEN VALIDATE OTP ${token}");
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      add(ForgotNextStep());
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onChangePasswordSubmitted(ChangePasswordSubmitted event, Emitter<ForgotState> emit) async {
    final password = Password.dirty(state.password.value);
    final passwordComfrim = ConfirmPassword.dirty(original: state.password.value, value: state.passwordComfrim.value);
    final email = Email.dirty(state.email.value);
    emit(state.copyWith(
      password: password,
      passwordComfrim: passwordComfrim,
    ));

    // Kiểm tra hợp lệ
    if (!Formz.validate([password, passwordComfrim])) {
      // emit(state.copyWith(status: FormzSubmissionStatus.initial));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      //verify otp
      await AuthApi().changePassword(email: email.value, password: password.value, passwordConfirm: passwordComfrim.value, token: token);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      add(ForgotNextStep());
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString()
      ));
    }
  }
}