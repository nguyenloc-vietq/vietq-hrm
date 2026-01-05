import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vietq_hrm/configs/apiConfig/permission.api.dart';
import 'package:vietq_hrm/configs/apiConfig/registration.api.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegistrationApi _registrationApi;
  final PremissionApi _permissionApi;

  RegisterBloc(this._registrationApi, this._permissionApi) : super(const RegisterState()) {
    on<RegisterInitialFetch>(_onInitialFetch);
    on<RegisterTabChanged>(_onTabChanged);
    on<RegisterRefreshed>(_onRefreshed);
    on<RegisterApproved>(_onApproved);
    on<RegisterRejected>(_onRejected);
  }

  Future<void> _onInitialFetch(
    RegisterInitialFetch event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      final res = await _permissionApi.getPermissions();
      final roles = res['data']?['roles'] as List<dynamic>? ?? [];
      final isAdmin = roles.contains('ADMIN');
      emit(state.copyWith(isAdmin: isAdmin));
      await _fetchDataForTab(state.tabIndex, isAdmin, emit);
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onTabChanged(
    RegisterTabChanged event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.tabIndex == event.tabIndex) return;
    emit(state.copyWith(status: RegisterStatus.loading, tabIndex: event.tabIndex, clearErrorMessage: true));
    await _fetchDataForTab(event.tabIndex, state.isAdmin, emit);
  }

  Future<void> _onRefreshed(
    RegisterRefreshed event,
    Emitter<RegisterState> emit,
  ) async {
    // The refresh indicator is already showing, so we just fetch data
    await _fetchDataForTab(state.tabIndex, state.isAdmin, emit);
  }

  Future<void> _onApproved(
    RegisterApproved event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.actionInProgress));
    try {
      await _registrationApi.approveRegistration({
        "registrationCode": event.registrationCode,
        "status": "APPROVED"
      });
      emit(state.copyWith(status: RegisterStatus.actionSuccess));
      // Refresh data for the current tab
      add(RegisterRefreshed());
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.actionFailure, errorMessage: e.toString()));
    }
  }

  Future<void> _onRejected(
    RegisterRejected event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.actionInProgress));
    try {
      await _registrationApi.rejectRegistration({
        "registrationCode": event.registrationCode,
        "status": "REJECTED"
      });
      emit(state.copyWith(status: RegisterStatus.actionSuccess));
      // Refresh data for the current tab
      add(RegisterRefreshed());
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.actionFailure, errorMessage: e.toString()));
    }
  }

  Future<void> _fetchDataForTab(int tabIndex, bool isAdmin, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading, clearErrorMessage: true));
    try {
      if (tabIndex == 3 && isAdmin) {
        final res = await _registrationApi.listApprovals();
        emit(state.copyWith(
          status: RegisterStatus.success,
          items: res['data']['items'] is List ? res['data']['items'] : [],
          summary: res['data']['summary'] ?? {},
        ));
      } else {
        String? status;
        if (tabIndex == 1) status = "APPROVED";
        if (tabIndex == 2) status = "REJECTED";

        final res = await _registrationApi.listRegistrations(status: status);
        final responseData = res['data'];

        emit(state.copyWith(
          status: RegisterStatus.success,
          items: responseData['items'] ?? [],
          summary: responseData['summary'] ?? {},
        ));
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: e.toString()));
    }
  }
}
