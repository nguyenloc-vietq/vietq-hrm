part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final String? today;
  final TimeSheetModels? timeSheets;

  const AttendanceLoaded({required this.timeSheets, this.today});

  AttendanceLoaded copyWith({TimeSheetModels? attendances}) {
    return AttendanceLoaded(
      timeSheets: timeSheets ?? this.timeSheets,
      today: today ?? this.today
    );
  }
}

class  AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError({required this.message});
  @override
  List<Object?> get props => [message];
}

class AttendanceLoadingCheckIn extends AttendanceState {}

class AttendanceLoadingCheckOut extends AttendanceState {}

class AttendanceCheckIn extends AttendanceState {
  final AttendanceRecordModels attendanceRecord;
  const AttendanceCheckIn({required this.attendanceRecord});

  AttendanceCheckIn copyWith({AttendanceRecordModels? attendanceRecord}) {
    return AttendanceCheckIn(
      attendanceRecord: attendanceRecord ?? this.attendanceRecord,
    );
  }

  @override
  List<Object?> get props => [attendanceRecord];
}

class AttendanceCheckOut extends AttendanceState {
  final AttendanceRecordModels attendanceRecord;
  const AttendanceCheckOut({required this.attendanceRecord});

  AttendanceCheckOut copyWith({AttendanceRecordModels? attendanceRecord}) {
    return AttendanceCheckOut(
      attendanceRecord: attendanceRecord ?? this.attendanceRecord,
    );
  }

  @override
  List<Object?> get props => [attendanceRecord];
}

class AttendanceCheckInError extends AttendanceState {
  final String message;
  const AttendanceCheckInError({required this.message});
  @override
  List<Object?> get props => [message];
}

class AttendanceCheckOutError extends AttendanceState {
  final String message;
  const AttendanceCheckOutError({required this.message});
  @override
  List<Object?> get props => [message];
}
