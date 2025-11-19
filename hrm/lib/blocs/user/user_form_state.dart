part of 'user_bloc.dart';

class UserFormState extends Equatable with FormzMixin {
  const UserFormState({
    this.email = const EmailInput.pure(),
    this.fullName = const FullNameInput.pure(),
    this.phone = const PhoneInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final EmailInput email;
  final FullNameInput fullName;
  final PhoneInput phone;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  bool get isValid => Formz.validate(inputs);

  @override
  List<FormzInput> get inputs => [email, fullName, phone];

  UserFormState copyWith({
    EmailInput? email,
    FullNameInput? fullName,
    PhoneInput? phone,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return UserFormState(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, fullName, phone, status, errorMessage];
}

// Email
class EmailInput extends FormzInput<String, String> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) {
    return value.contains('@') ? null : 'Invalid email';
  }
}

// Full Name
class FullNameInput extends FormzInput<String, String> {
  const FullNameInput.pure() : super.pure('');
  const FullNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) {
    return value.isNotEmpty ? null : 'Full name is required';
  }
}

// Phone
class PhoneInput extends FormzInput<String, String> {
  const PhoneInput.pure() : super.pure('');
  const PhoneInput.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) {
    return RegExp(r'^\d{10,}$').hasMatch(value) ? null : 'Invalid phone number';
  }
}

class AddressInput extends FormzInput<String, String> {
  const AddressInput.pure() : super.pure('');
  const AddressInput.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) {
    return value.isNotEmpty ? null : 'Address is required';
  }
}