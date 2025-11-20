import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vietq_hrm/blocs/calendars/calendar_bloc.dart';
import 'package:vietq_hrm/models/timeSheet.models.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Dữ liệu check-in: Map<Ngày, Giờ vào - ra>

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        print(state);
        if (state is CalendarLoaded) {
          return Scaffold(
            backgroundColor: isDarkMode ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<CalendarBloc>().add(
                  LoadCalendarEvent(isRefresh: true),
                );
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: TableCalendar(
                      availableGestures: AvailableGestures.horizontalSwipe,
                      rowHeight: 80.h,
                      daysOfWeekHeight: 50.h,
                      firstDay: DateTime(DateTime.now().year, 1, 1),
                      lastDay: DateTime(DateTime.now().year, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      // locale: '',
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black ),
                        weekendStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        leftChevronIcon: Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8).r,
                            color: Theme.of(context).primaryColor.withAlpha(50),
                            // border: Border.all(color: Colors.orange),
                          ),
                          child: Icon(
                            Icons.chevron_left_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 30.sp,
                          ),
                        ),
                        rightChevronIcon: Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8).r,
                            color: Theme.of(context).primaryColor.withAlpha(50),
                            // border: Border.all(color: Colors.orange),
                          ),
                          child: Icon(
                            Icons.chevron_right_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 30.sp,
                          ),
                        ),
                        headerPadding: EdgeInsets.symmetric(vertical: 8),
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      calendarStyle: CalendarStyle(
                        todayTextStyle: TextStyle(color: Colors.orange),
                        todayDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8).r,
                          color: Colors.orange[50],
                          border: Border.all(color: Colors.orange),
                        ),

                        weekendTextStyle: TextStyle(color: Colors.red),
                      ),

                      startingDayOfWeek: StartingDayOfWeek.monday,
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Tháng',
                      },

                      calendarBuilders: CalendarBuilders(
                        todayBuilder: (context, day, focusedDay) {
                          final key = DateTime(day.year, day.month, day.day);
                          final _checkInData = parseCheckInData(
                            state.timeSheets,
                          );
                          final inTime = _checkInData[key]?.inTime ?? '';
                          final outTime = _checkInData[key]?.outTime ?? '';

                          return Stack(
                            clipBehavior: Clip.none,
                            // Cho phép overlay ra ngoài
                            children: [
                              // Khối chính (nền của ô ngày)
                              Container(
                                width: 60.w,
                                margin: const EdgeInsets.all(4).r,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ).r,
                                decoration: BoxDecoration(
                                  color: outTime.isNotEmpty && inTime.isNotEmpty
                                      ? !isDarkMode
                                      ? Colors.green[50]
                                      : Colors.green[50]?.withAlpha(50)
                                      : inTime.isNotEmpty
                                      ? !isDarkMode
                                      ? Colors.orange[50]
                                      : Colors.orange[50]?.withAlpha(50)
                                      : !isDarkMode
                                      ? Colors.grey[50]
                                      : Colors.grey[50]?.withAlpha(50),
                                  borderRadius: BorderRadius.circular(8).r,
                                  border: Border.all(
                                    color:
                                        outTime.isNotEmpty && inTime.isNotEmpty
                                        ? Colors.green
                                        : inTime.isNotEmpty
                                        ? Colors.orange
                                        : Theme.of(context).colorScheme.primary,
                                    width: 1.2.w,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Số ngày
                                    Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: outTime.isNotEmpty
                                            ? Colors.green[800]
                                            : inTime.isNotEmpty
                                            ? Colors.orange[800]
                                            : Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 2.h),

                                    // Hiển thị giờ vào/ra
                                    if (inTime.isNotEmpty || outTime.isNotEmpty)
                                      Text(
                                        inTime.isNotEmpty ? '$inTime <-' : '',
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              inTime.isNotEmpty &&
                                                  isBefore(inTime, "08:15")
                                              ? Colors.green[700]
                                              : Colors.red[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    Text(
                                      outTime.isNotEmpty ? '$outTime ->' : '',
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            outTime.isNotEmpty &&
                                                isBefore(outTime, "17:00")
                                            ? Colors.red[600]
                                            : Colors.green[700],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              if (true)
                                Positioned(
                                  top: -5.h, // hơi nhô lên trên
                                  right: -10.w, // góc phải
                                  child: Transform(
                                    transform: Matrix4.rotationZ(0.5.r),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ).r,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(
                                          6,
                                        ).r,
                                      ),
                                      child: Text(
                                        'NOW',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                        defaultBuilder: (context, day, focusedDay) {
                          final key = DateTime(day.year, day.month, day.day);
                          final _checkInData = parseCheckInData(
                            state.timeSheets,
                          );
                          final inTime = _checkInData[key]?.inTime ?? '';
                          final outTime = _checkInData[key]?.outTime ?? '';
                          final isWeeken =
                              day.weekday == DateTime.saturday ||
                              day.weekday == DateTime.sunday;
                          return Container(
                            width: 60.w,
                            margin: const EdgeInsets.all(4).r,
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 4,
                            ).r,
                            decoration: BoxDecoration(
                              color: outTime.isNotEmpty && inTime.isNotEmpty
                                  ? !isDarkMode
                                      ? Colors.green[50]
                                      : Colors.green[50]?.withAlpha(50)
                                  : inTime.isNotEmpty
                                  ? !isDarkMode
                                      ? Colors.orange[50]
                                      : Colors.orange[50]?.withAlpha(50)
                                  : !isDarkMode
                                      ? Colors.grey[50]
                                      : Colors.grey[50]?.withAlpha(50),
                              borderRadius: BorderRadius.circular(8).r,
                              border: Border.all(
                                color: outTime.isNotEmpty && inTime.isNotEmpty
                                    ? Colors.green
                                    : inTime.isNotEmpty
                                    ? Colors.orange
                                    : Colors.transparent,
                                width: 1.2.w,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Số ngày
                                Text(
                                  '${day.day}',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isWeeken
                                        ? Colors.red
                                        : outTime.isNotEmpty
                                        ? Colors.green[800]
                                        : inTime.isNotEmpty
                                        ? Colors.orange[800]
                                        : isDarkMode
                                            ? Colors.white
                                            : Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 2.h),

                                // Hiển thị giờ vào/ra
                                if (inTime.isNotEmpty || outTime.isNotEmpty)
                                  Text(
                                    inTime.isNotEmpty ? '$inTime <-' : '',
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          inTime.isNotEmpty &&
                                              isBefore(inTime, "08:15")
                                          ? Colors.green[700]
                                          : Colors.red[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                Text(
                                  outTime.isNotEmpty ? '$outTime ->' : '',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        outTime.isNotEmpty &&
                                            isBefore(outTime, "17:00")
                                        ? Colors.red[600]
                                        : Colors.green[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(child: Text("No data"));
      },
    );
  }
}

class CheckInData {
  final String? inTime;
  final String? outTime;

  CheckInData({this.inTime, this.outTime});
}

bool isBefore(String time1, String time2) {
  int hour1 = int.parse(time1.split(':')[0]);
  int minute1 = int.parse(time1.split(':')[1]);

  int hour2 = int.parse(time2.split(':')[0]);
  int minute2 = int.parse(time2.split(':')[1]);

  if (hour1 == hour2) {
    return minute1 < minute2;
  }
  return hour1 < hour2;
}

Map<DateTime, CheckInData> parseCheckInData(TimeSheetModels? res) {
  final List<AttendanceRecs> attendance = res?.attendanceRecs ?? [];

  DateTime normalize(DateTime d) => DateTime(d.year, d.month, d.day);
  String formatTime(String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.parse(isoDate).toLocal();
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  return {
    for (final rec in attendance)
      normalize(DateTime.parse(rec.workDay!)): CheckInData(
        inTime: formatTime(rec.timeIn),
        outTime: formatTime(rec.timeOut),
      ),
  };
}
