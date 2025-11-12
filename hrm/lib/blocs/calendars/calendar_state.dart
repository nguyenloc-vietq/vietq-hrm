part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends CalendarState {}

class ScheduleLoading extends CalendarState {}

class ScheduleLoaded extends CalendarState {
  final List<ScheduleModels>? schedules;
  final bool hasReachedMax;

  const ScheduleLoaded({required this.schedules, this.hasReachedMax = false});

  ScheduleLoaded copyWith({
    List<ScheduleModels>? schedules,
    bool? hasReachedMax,
  }) {
    return ScheduleLoaded(
      schedules: schedules ?? this.schedules,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [schedules, hasReachedMax];
}

class ScheduleError extends CalendarState {
  final String message;

  const ScheduleError({required this.message});

  @override
  List<Object?> get props => [message];
}

// class TimeSheetInit extends CalendarState {}

class TimeSheetLoading extends CalendarState {}

class TimeSheetLoaded extends CalendarState {
  final List<TimeSheets>? timeSheets;
  final bool hasReachedMax;

  const TimeSheetLoaded({required this.timeSheets, this.hasReachedMax = false});

  TimeSheetLoaded copyWith({
    List<ScheduleModels>? schedules,
    bool? hasReachedMax,
  }) {
    return TimeSheetLoaded(
      timeSheets: timeSheets ?? this.timeSheets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [timeSheets, hasReachedMax];
}

class TimeSheetError extends CalendarState {
  final String message;

  const TimeSheetError({required this.message});

  @override
  List<Object?> get props => [message];
}