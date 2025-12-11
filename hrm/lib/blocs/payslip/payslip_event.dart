part of 'payslip_bloc.dart';

abstract class PayslipEvent extends Equatable {
  const PayslipEvent();

  @override
  List<Object> get props => [];
}


class FetchPayslipEvent extends PayslipEvent {
  const FetchPayslipEvent();

  @override
  List<Object> get props => [];
}
