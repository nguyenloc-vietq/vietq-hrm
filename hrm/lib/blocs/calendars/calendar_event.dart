part of 'calendar_bloc.dart';

/// Base event
abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

/// Sự kiện chính: Load toàn bộ dữ liệu calendar (schedule + timesheet)
class LoadCalendarEvent extends CalendarEvent {
  /// true = pull-to-refresh hoặc lần đầu load
  /// false = load more (phân trang)
  final bool isRefresh;

  const LoadCalendarEvent({required this.isRefresh});

  @override
  List<Object?> get props => [isRefresh];
}

/// Sự kiện load thêm dữ liệu khi scroll xuống cuối (nếu cần phân trang sau này)
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