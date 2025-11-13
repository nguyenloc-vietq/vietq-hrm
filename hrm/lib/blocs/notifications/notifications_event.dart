part of 'notifications_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class FetchNotificationEvent extends NotificationEvent {
  final bool isRefresh;
  const FetchNotificationEvent({this.isRefresh = false});
}

