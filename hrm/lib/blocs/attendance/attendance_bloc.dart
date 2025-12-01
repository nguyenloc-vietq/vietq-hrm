import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vietq_hrm/configs/apiConfig/schedule.api.dart';
import 'package:vietq_hrm/models/attendanceRecord.models.dart';
import 'package:vietq_hrm/models/timeSheet.models.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final ScheduleApi _scheduleApi;

  TimeSheetModels? timeSheets;
  AttendanceRecordModels? checkin;
  AttendanceRecordModels? checkout;
  AttendanceBloc(this._scheduleApi) : super(AttendanceLoading()) {
    on<LoadAttendanceEvent>(_onFetchTimeSheetByDay);
    on<CheckInEvent>(_onCheckIn);
    on<CheckOutEvent>(_onCheckOut);
    add(LoadAttendanceEvent(today: DateTime.now().toString()));
  }
  Future<void> _onFetchTimeSheetByDay(LoadAttendanceEvent event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      print("#==========> EVENT TIME ${event.today}");
      final timeSheet = await _scheduleApi.fetchTimeSheet(
        today: event.today,
      );
      print("#==========> TIME SHEET ${timeSheet}");
      emit(AttendanceLoaded(timeSheets: timeSheet, today: event.today));
    } catch (e) {
      emit(AttendanceError(message: e.toString()));
    }
  }

  Future<void> _onCheckIn(CheckInEvent event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoadingCheckIn());
    try {
      final checkin = await _scheduleApi.checkIn();
      emit(AttendanceCheckIn(attendanceRecord: checkin));
      add(LoadAttendanceEvent(today: DateTime.now().toString()));
    } catch (e) {
      add(LoadAttendanceEvent(today: DateTime.now().toString()));
      emit(AttendanceCheckInError(message: e.toString()));
    }
  }

  Future<void> _onCheckOut(CheckOutEvent event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoadingCheckOut());
    try {
      final checkout = await _scheduleApi.checkOut();
      emit(AttendanceCheckOut(attendanceRecord: checkout));
      add(LoadAttendanceEvent(today: DateTime.now().toString()));
    } catch (e) {
      add(LoadAttendanceEvent(today: DateTime.now().toString()));
      emit(AttendanceCheckOutError(message: e.toString()));
    }
  }
}