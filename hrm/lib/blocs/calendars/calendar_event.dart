part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}
class LoadScheduleEvent extends CalendarEvent {
  final String scheduleCode;

  const LoadScheduleEvent({required this.scheduleCode});

  @override
  List<Object?> get props => [scheduleCode];
}
class LoadCalendarEvent extends CalendarEvent {
  final String? today;
  final String? startMonth;
  final String? endMonth;
  final bool isRefresh;

  const LoadCalendarEvent({required this.isRefresh, this.today, this.endMonth, this.startMonth});

  @override
  List<Object?> get props => [isRefresh, today, startMonth, endMonth];
}

class LoadMoreCalendarEvent extends CalendarEvent {
  const LoadMoreCalendarEvent();

  @override
  List<Object?> get props => [];
}

/// (Tùy chọn) Sự kiện riêng để retry khi lỗi – rất hữu ích cho UI
class RetryCalendarEvent extends CalendarEvent {
  const RetryCalendarEvent();

  @override
  List<Object?> get props => [];
}