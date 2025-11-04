import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
  final Map<DateTime, CheckInData> _checkInData = {
    DateTime(2025, 9, 3): CheckInData(inTime: '08:30', outTime: '17:31'),
    DateTime(2025, 9, 4): CheckInData(inTime: '08:11', outTime: '17:32'),
    DateTime(2025, 9, 5): CheckInData(inTime: '08:01', outTime: '17:31'),
    DateTime(2025, 9, 6): CheckInData(inTime: '08:12', outTime: '17:32'),
    DateTime(2025, 9, 7): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 8): CheckInData(inTime: '08:12', outTime: '17:32'),
    DateTime(2025, 9, 9): CheckInData(inTime: '08:12'),
    DateTime(2025, 9, 10): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 11): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 12): CheckInData(inTime: '08:12', outTime: '17:24'),
    DateTime(2025, 9, 13): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 14): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 15): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 16): CheckInData(inTime: '08:31'),
    DateTime(2025, 9, 17): CheckInData(inTime: '08:30', outTime: '17:36'),
    DateTime(2025, 9, 18): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 19): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 20): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 24): CheckInData(inTime: '08:30', outTime: '17:31'),
    DateTime(2025, 9, 25): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 26): CheckInData(inTime: '08:30', outTime: '17:31'),
    DateTime(2025, 9, 27): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 28): CheckInData(inTime: '08:12', outTime: '17:31'),
    DateTime(2025, 9, 29): CheckInData(inTime: '08:15', outTime: '17:32'),
    DateTime(2025, 9, 30): CheckInData(inTime: '08:31'),
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TableCalendar(
        rowHeight: 80,
        daysOfWeekHeight: 50,
        firstDay: DateTime(2025, 1, 1),
        lastDay: DateTime(2025, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        locale: 'vi_VN',
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontWeight: FontWeight.w600),
          weekendStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          leftChevronIcon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              color: Color(0xFFF8D448).withAlpha(50),
              // border: Border.all(color: Colors.orange),
            ),
            child: Icon(
              Icons.chevron_left_outlined,
              color: Color(0xFFF8D448),
              size: 30,
            ),
          ),
          rightChevronIcon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              color: Color(0xFFF8D448).withAlpha(50),
              // border: Border.all(color: Colors.orange),
            ),
            child: Icon(
              Icons.chevron_right_outlined,
              color: Color(0xFFF8D448),
              size: 30,
            ),
          ),
          headerPadding: EdgeInsets.symmetric(vertical: 8),
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),

        calendarStyle: CalendarStyle(
          todayTextStyle: TextStyle(color: Colors.orange),
          todayDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.orange[50],
            border: Border.all(color: Colors.orange),
          ),
          weekendTextStyle: TextStyle(color: Colors.red),
        ),

        startingDayOfWeek: StartingDayOfWeek.monday,
        availableCalendarFormats: const {CalendarFormat.month: 'Tháng'},
        // onDaySelected: (selectedDay, focusedDay) {
        //   setState(() {
        //     _selectedDay = selectedDay;
        //     _focusedDay = focusedDay;
        //   });
        //   // _showCheckInDetail(selectedDay); // Mở bottom sheet để xem/sửa
        // },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final key = DateTime(day.year, day.month, day.day);
            print(key);
            final data = _checkInData[key];
            print(data);
            if (data == null) return null; // Không có check-in → để trống

            final inTime = data.inTime ?? '';
            final outTime = data.outTime ?? '';

            return Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: outTime.isNotEmpty && inTime.isNotEmpty
                    ? Colors.green[50]
                    : inTime.isNotEmpty
                    ? Colors.orange[50]
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: outTime.isNotEmpty && inTime.isNotEmpty
                      ? Colors.green
                      : inTime.isNotEmpty
                      ? Colors.orange
                      : Colors.grey,
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Số ngày
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: outTime.isNotEmpty
                          ? Colors.green[800]
                          : inTime.isNotEmpty
                          ? Colors.orange[800]
                          : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Hiển thị giờ vào/ra
                  if (inTime.isNotEmpty || outTime.isNotEmpty)
                    Text(
                      inTime.isNotEmpty ? '$inTime <-' : '',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: inTime.isNotEmpty && isBefore(inTime, "08:15")
                            ? Colors.green[700]
                            : Colors.red[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  Text(
                    outTime.isNotEmpty ? '$outTime ->' : '',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: outTime.isNotEmpty && isBefore(outTime, "17:00")
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
    );
  }
}

// Model dữ liệu
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
