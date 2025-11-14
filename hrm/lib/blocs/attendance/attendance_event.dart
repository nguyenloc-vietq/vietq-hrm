part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadAttendanceEvent extends AttendanceEvent {
  final String? today;
  const LoadAttendanceEvent({this.today});

  @override
  List<Object?> get props => [today];
}

class CheckInEvent extends AttendanceEvent {
  final String? ssid;
  const CheckInEvent({this.ssid});

  @override
  List<Object?> get props => [ssid];
}

class CheckOutEvent extends AttendanceEvent {
  final String? ssid;
  const CheckOutEvent({this.ssid});

  @override
  List<Object?> get props => [ssid];
}