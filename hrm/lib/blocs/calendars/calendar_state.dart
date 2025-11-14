part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();
  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<ScheduleModels> schedules;
  final List<ScheduleModels> scheduleToday;
  final TimeSheetModels? timeSheets;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const CalendarLoaded({
    required this.scheduleToday,
    required this.schedules,
    this.timeSheets,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  CalendarLoaded copyWith({
    List<ScheduleModels>? schedules,
    List<ScheduleModels>? scheduleToday,
    TimeSheetModels? timeSheets,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return CalendarLoaded(
      schedules: schedules ?? this.schedules,
      scheduleToday: scheduleToday ?? this.scheduleToday,
      timeSheets: timeSheets ?? this.timeSheets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [schedules, timeSheets, hasReachedMax, isLoadingMore, scheduleToday];
}

class ScheduleLoaded extends CalendarState {
  final List<ScheduleModels> schedulesToday;
  const ScheduleLoaded({required this.schedulesToday});

  ScheduleLoaded copyWith({
    List<ScheduleModels>? schedulesToday,
  }) {
    return ScheduleLoaded(
      schedulesToday: schedulesToday ?? this.schedulesToday,
    );
  }
}

class ScheduleError extends CalendarState {
  final String message;
  const ScheduleError({required this.message});
  @override
  List<Object?> get props => [message];
}

class CalendarError extends CalendarState {
  final String message;
  const CalendarError({required this.message});
  @override
  List<Object?> get props => [message];
}