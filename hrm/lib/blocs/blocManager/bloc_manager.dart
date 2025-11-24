import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietq_hrm/blocs/user/user_bloc.dart';
import 'package:vietq_hrm/blocs/notifications/notifications_bloc.dart';
import 'package:vietq_hrm/blocs/calendars/calendar_bloc.dart';
import 'package:vietq_hrm/blocs/attendance/attendance_bloc.dart';
import 'package:vietq_hrm/configs/apiConfig/user.api.dart';
import 'package:vietq_hrm/configs/apiConfig/notification.api.dart';
import 'package:vietq_hrm/configs/apiConfig/schedule.api.dart';

class BlocManager {
  static List<BlocProvider> buildProviders() {
    return [
      BlocProvider<UserBloc>(
        create: (_) => UserBloc(UserApi()),
      ),
      BlocProvider<NotificationBloc>(
        create: (_) => NotificationBloc(NotificationApi()),
      ),
      BlocProvider<CalendarBloc>(
        create: (_) => CalendarBloc(ScheduleApi()),
      ),
      BlocProvider<AttendanceBloc>(
        create: (_) => AttendanceBloc(ScheduleApi()),
      ),
    ];
  }

  // Hàm close khi logout
  static Future<void> closeAllBlocs(BuildContext context) async {
    context.read<UserBloc>().close();
    context.read<NotificationBloc>().close();
    context.read<CalendarBloc>().close();
    context.read<AttendanceBloc>().close();
  }
}