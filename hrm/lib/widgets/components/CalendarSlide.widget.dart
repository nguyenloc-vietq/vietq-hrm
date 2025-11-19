import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vietq_hrm/blocs/attendance/attendance_bloc.dart';
import 'package:vietq_hrm/blocs/calendars/calendar_bloc.dart';
import 'package:vietq_hrm/utils/getDayInMonth.dart';

class CalendarSlideWidget extends StatefulWidget {
  const CalendarSlideWidget({super.key});

  @override
  State<CalendarSlideWidget> createState() => _CalendarSlideWidgetState();
}

class _CalendarSlideWidgetState extends State<CalendarSlideWidget> {
  final listDay = getDaysInfoInCurrentMonth();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDay();
    });
  }
  Future<String> _onSelectDay(int index) async {
    late String result;

    if (listDay[index]["isSelected"] == true) {
      listDay[index]["isSelected"] = false;

      final currentIndex = listDay.indexWhere((day) => day["currentDay"] == true);
      listDay[currentIndex]["isSelected"] = true;
      print("DAYYYYY" + listDay[currentIndex]["day"].toString());
      result = _toUtcIsoString(
        listDay[currentIndex]["year"].toString(),
        listDay[currentIndex]["month"].toString(),
        listDay[currentIndex]["day"].toString(),
      );
    } else {
      for (var day in listDay) {
        day["isSelected"] = false;
      }

      listDay[index]["isSelected"] = true;
      print("DAYYYYY" + listDay[index]["day"].toString());
      result = _toUtcIsoString(
        listDay[index]["year"].toString(),
        listDay[index]["month"].toString(),
        listDay[index]["day"].toString(),
      );
    }

    setState(() {});

    return result;
  }


  String _toUtcIsoString(String year, String month, String day) {
    final y = int.parse(year);
    final m = int.parse(month.padLeft(2, '0'));
    final d = int.parse(day.padLeft(2, '0'));

    return DateTime.utc(y, m, d).toIso8601String();
  }

  void _scrollToCurrentDay() {
    // Tìm index của ngày hiện tại
    final currentIndex = listDay.indexWhere((day) => day["currentDay"] == true);

    if (currentIndex != -1) {
      final itemWidth = 86.0.w; // 80 (width) + 6 (margin)
      final position = (currentIndex - 2) * itemWidth;
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0).r,
          child: ListView.builder(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: listDay.length,
            itemBuilder: (context, index) {
              final day = listDay[index];
              return ElevatedButton(
                onPressed: () async {
                  final day = await _onSelectDay(index);
                  print("#==========> ON SELECT DAY" + day);
                  context.read<CalendarBloc>().add(LoadCalendarEvent(isRefresh: true, today: day.toString()));
                  context.read<AttendanceBloc>().add(LoadAttendanceEvent(today: day.toString()));
                },
                style: ElevatedButton.styleFrom(
                  overlayColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80.w,
                      margin: const EdgeInsets.only(right: 6).r,
                      decoration: BoxDecoration(
                        color: day["isSelected"]
                            ? Color(0xFFF6C951).withOpacity(0.8)
                            : Colors.white ,
                        borderRadius: BorderRadius.circular(12).r,
                        border: Border.all(
                          color: day["isSelected"]
                              ? Color(0xFFF6C951)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day["day"].toString(),
                            style: textTheme.headlineMedium?.copyWith(
                              color: day["isSelected"] ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            day["weekday"].toString(),
                            style: textTheme.bodyMedium?.copyWith(
                              color: day["isSelected"] ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if(day["currentDay"])
                     Positioned(
                      top: -10.h, // hơi nhô lên trên
                      left: 20.w, // góc phải
                      child: Transform(
                        transform: Matrix4.rotationZ(0.r),
                        child: Container(
                          width: 40.w,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ).r,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(6).r,
                          ),
                          child: Text(
                            'Today',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
