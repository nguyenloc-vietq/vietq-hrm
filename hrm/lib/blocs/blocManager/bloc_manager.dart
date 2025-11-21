// bloc_manager.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietq_hrm/blocs/attendance/attendance_bloc.dart';
import 'package:vietq_hrm/blocs/calendars/calendar_bloc.dart';
import 'package:vietq_hrm/blocs/notifications/notifications_bloc.dart';
import 'package:vietq_hrm/blocs/user/user_bloc.dart';
import 'package:vietq_hrm/configs/apiConfig/notification.api.dart';
import 'package:vietq_hrm/configs/apiConfig/schedule.api.dart';
import 'package:vietq_hrm/configs/apiConfig/user.api.dart';

class BlocManager {
  static final List<BlocBase> _blocs = [];

  static List<BlocProvider> buildProviders() {
    // Đóng cũ trước khi tạo mới (rất quan trọng khi đăng nhập lại)
    closeAllBlocs();

    return [
      BlocProvider(create: (_) {
        final bloc = UserBloc(UserApi());
        _blocs.add(bloc);
        return bloc;
      }),
      BlocProvider(create: (_) {
        final bloc = NotificationBloc(NotificationApi());
        _blocs.add(bloc);
        return bloc;
      }),
      BlocProvider(create: (_) {
        final bloc = CalendarBloc(ScheduleApi());
        _blocs.add(bloc);
        return bloc;
      }),
      BlocProvider(create: (_) {
        final bloc = AttendanceBloc(ScheduleApi());
        _blocs.add(bloc);
        return bloc;
      }),
    ];
  }

  // Gọi khi logout
  static Future<void> closeAllBlocs() async {
    for (final bloc in _blocs) {
      if (!bloc.isClosed) {
        await bloc.close();
      }
    }
    _blocs.clear();
  }
}