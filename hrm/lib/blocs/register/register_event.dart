part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterInitialFetch extends RegisterEvent {}

class RegisterTabChanged extends RegisterEvent {
  final int tabIndex;

  const RegisterTabChanged(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class RegisterRefreshed extends RegisterEvent {}

class RegisterApproved extends RegisterEvent {
  final String registrationCode;

  const RegisterApproved(this.registrationCode);

  @override
  List<Object> get props => [registrationCode];
}

class RegisterRejected extends RegisterEvent {
  final String registrationCode;

  const RegisterRejected(this.registrationCode);

  @override
  List<Object> get props => [registrationCode];
}
