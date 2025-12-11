part of 'payslip_bloc.dart';

abstract class PayslipState extends Equatable {
  const PayslipState();

  @override
  List<Object> get props => [];
}

class PayslipInital extends PayslipState {}

class PayslipLoading extends PayslipState {}

class PayslipLoaded extends PayslipState {
  final List<dynamic>? listPayslip;

  const PayslipLoaded({required this.listPayslip});

  PayslipLoaded copyWith({List<dynamic>? listPayslip}) {
    return PayslipLoaded(listPayslip: listPayslip ?? this.listPayslip);
  }
}

class PayslipError extends PayslipState {
  final String message;

  const PayslipError({required this.message});

  PayslipError copyWith({String? message}) {
    return PayslipError(message: message ?? this.message);
  }
}
