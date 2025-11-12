part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class FetchWorkScheduleEvent extends CalendarEvent {
  final bool isRefresh;
  const FetchWorkScheduleEvent({required this.isRefresh});
}

class FetchTimeSheetEvent extends CalendarEvent {
  final bool isRefresh;
  const FetchTimeSheetEvent({required this.isRefresh});
}