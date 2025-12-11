import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vietq_hrm/configs/apiConfig/payroll.api.dart';

part 'payslip_event.dart';
part 'payslip_state.dart';

class PayslipBloc extends Bloc<PayslipEvent, PayslipState> {
  final PayrollApi _payrollApi;
  List<dynamic> listPaySlip = [];

  PayslipBloc(this._payrollApi) : super(PayslipInital()) {
    on<FetchPayslipEvent>(_onFetchPayslip);
    add(FetchPayslipEvent());
  }

  Future<void> _onFetchPayslip(
    FetchPayslipEvent event,
    Emitter<PayslipState> emit,
  ) async {
    try {
      emit(PayslipLoading());
      final response = await _payrollApi.getListPayslip();
      listPaySlip = response;
      emit(PayslipLoaded(listPayslip: listPaySlip));
    } catch (e) {
      emit(PayslipError(
        message: e.toString(),
      ));
    }
  }
}
