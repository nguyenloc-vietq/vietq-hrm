// calendar_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vietq_hrm/configs/apiConfig/schedule.api.dart';
import 'package:vietq_hrm/models/schedule.module.dart';
import 'package:vietq_hrm/models/timeSheet.models.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final ScheduleApi _scheduleApi;

  int _currentPage = 1;
  final int _pageSize = 20;

  final List<ScheduleModels> _schedules = [];
  TimeSheetModels? _timeSheets;

  CalendarBloc(this._scheduleApi) : super(CalendarInitial()) {
    on<LoadCalendarEvent>(_onLoadCalendar);
    on<LoadMoreCalendarEvent>(_onLoadMore);
    on<RetryCalendarEvent>(_onRetry);

    // Load lần đầu khi khởi tạo
    add(const LoadCalendarEvent(isRefresh: true));
  }

  Future<void> _onLoadCalendar(
      LoadCalendarEvent event,
      Emitter<CalendarState> emit,
      ) async {
    // Chỉ emit loading khi là lần đầu hoặc refresh
    if (event.isRefresh || _currentPage == 1) {
      emit(CalendarLoading());
    }

    // Reset data khi refresh
    if (event.isRefresh) {
      _currentPage = 1;
      _schedules.clear();
      _timeSheets = null;
    }

    try {
      // Gọi 2 API song song → nhanh hơn, không bị chặn
      await Future.wait([
        _fetchSchedules(),
        _fetchTimeSheets(),
      ]);

      // Emit đúng 1 lần duy nhất với dữ liệu đầy đủ
      emit(CalendarLoaded(
        schedules: List.from(_schedules), // clone để immutable
        timeSheets: _timeSheets,
        hasReachedMax: _hasReachedMax(),
      ));
    } catch (e) {
      emit(CalendarError(message: e.toString()));
    }
  }

  Future<void> _onLoadMore(
      LoadMoreCalendarEvent event,
      Emitter<CalendarState> emit,
      ) async {
    if (state is CalendarLoaded && (state as CalendarLoaded).hasReachedMax) {
      return; // Đã hết dữ liệu
    }

    // Giữ state cũ + bật loading more
    final currentState = state as CalendarLoaded;
    emit(currentState.copyWith(isLoadingMore: true));

    _currentPage++;

    try {
      await Future.wait([
        _fetchSchedules(),
        _fetchTimeSheets(),
      ]);

      emit(CalendarLoaded(
        schedules: List.from(_schedules),
        timeSheets: _timeSheets,
        hasReachedMax: _hasReachedMax(),
        isLoadingMore: false,
      ));
    } catch (e) {
      _currentPage--; // rollback page
      emit(currentState.copyWith(isLoadingMore: false));
      emit(CalendarError(message: e.toString()));
    }
  }

  // ====================== RETRY ======================
  Future<void> _onRetry(
      RetryCalendarEvent event,
      Emitter<CalendarState> emit,
      ) async {
    add(const LoadCalendarEvent(isRefresh: true));
  }

  // ====================== PRIVATE FETCHERS ======================
  Future<void> _fetchSchedules() async {
    try {
      final newSchedules = await _scheduleApi.fetchSchedule(
        // page: _currentPage,
        // pageSize: _pageSize,
      );

      if (_currentPage == 1) {
        _schedules
          ..clear()
          ..addAll(newSchedules);
      } else {
        _schedules.addAll(newSchedules);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchTimeSheets() async {
    try {
      final newTimeSheets = await _scheduleApi.fetchTimeSheet(
        // page: _currentPage,
        // pageSize: _pageSize,
      );

      if (_currentPage == 1) {
        _timeSheets = newTimeSheets;
      } else {
        _timeSheets ??= TimeSheetModels(attendanceRecs: []);
        _timeSheets!.attendanceRecs!.addAll(newTimeSheets.attendanceRecs ?? []);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Kiểm tra có còn dữ liệu để load more không
  bool _hasReachedMax() {
    final scheduleEmpty = _schedules.length < _currentPage * _pageSize;
    final timesheetEmpty = _timeSheets?.attendanceRecs?.length == 0 ||
        (_timeSheets?.attendanceRecs?.length ?? 0) < _currentPage * _pageSize;
    return scheduleEmpty && timesheetEmpty;
  }
}
