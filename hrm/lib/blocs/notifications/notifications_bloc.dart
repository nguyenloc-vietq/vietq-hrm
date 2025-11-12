import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vietq_hrm/configs/apiConfig/notification.api.dart';
import 'package:vietq_hrm/models/notification.models.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationApi _notificationApi;
  int _currentPage = 1;
  final int _pageSize = 20;

  List<NotificationModel> _notifications = [];

  NotificationBloc(this._notificationApi) : super(NotificationInitial()) {
    on<FetchNotificationEvent>(_onFetchNotifications);
    add(FetchNotificationEvent(isRefresh: false));
  }

  Future<void> _onFetchNotifications(
    FetchNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (event.isRefresh) {
      _currentPage = 1;
      _notifications.clear();
    }

    if (_currentPage == 1 && !event.isRefresh) emit(NotificationLoading());

    try {
      final newNoti = await _notificationApi.fetchNotification(
        page: _currentPage,
        pageSize: _pageSize,
      );
      print("New Noti" + newNoti.toString());
      final bool hasReachedMax = newNoti.length < _pageSize;

      if(event.isRefresh || _currentPage == 1) {
        _notifications = newNoti;
      }else{
        _notifications.addAll(newNoti);
      }

      emit(NotificationLoaded(
        notifications: _notifications,
        hasReachedMax: hasReachedMax,
      ));

    } catch (error) {
      print(error);
      emit(NotificationError(message: error.toString()));
    }

  }
}
