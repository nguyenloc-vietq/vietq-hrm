import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vietq_hrm/blocs/calendars/calendar_bloc.dart';
import 'package:vietq_hrm/widgets/customWidgets/HalfCircleProgress.widget.dart';

class TodayAttendance extends StatefulWidget {
  const TodayAttendance({super.key});

  @override
  State<TodayAttendance> createState() => _TodayAttendanceState();
}

class _TodayAttendanceState extends State<TodayAttendance> {
  int totalDays = 0;
  int workingDays = 0;
  @override
  void initState() {
    super.initState();
     context.read<CalendarBloc>().add(LoadCalendarEvent(isRefresh: true, today: DateTime.now().toString()));
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double percent = totalDays == 0 ? 0 : workingDays / totalDays;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today Attendance', style: textTheme.headlineMedium),
         SizedBox(height: 20.h),
        BlocListener<CalendarBloc, CalendarState>(
          listener: (context, state) {
            if(state is CalendarLoaded){
              setState(() {
                totalDays = state.schedules.first.totalDay ?? 0;
                workingDays = state.schedules.first.totalWokingDay ?? 0;
              });
            }
          },
          child: BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  double spacing = 16.h;
                  double itemWidth = (constraints.maxWidth - spacing) / 2;
                  double itemHeight = 150.h;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      Container(
                        width: itemWidth,
                        height: itemHeight,
                        padding: EdgeInsets.all(16).r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16).r,
                        ),
                        child: Column(
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 10.w,
                              children: [
                                Container(
                                  width: 30.w,
                                  height: 30.h,
                                  padding: EdgeInsets.all(5).r,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF6C951).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10).r,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/login.svg',
                                    width: 5.w,
                                    height: 5.h,
                                    colorFilter: ColorFilter.mode(
                                      Color(0xFFF6C951),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                Text('Check In', style: textTheme.bodyMedium),
                              ],
                            ),
                            if(state is CalendarLoading)
                              SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator( strokeWidth: 3,)),
                            if(state is CalendarLoaded)...[
                              if(state.scheduleToday.isNotEmpty)...[

                              Text(DateFormat('HH:mm').format(DateTime.parse("${DateTime.now().toIso8601String().split('T')[0]} ${state.scheduleToday.first.shift?.startTime}")), style: textTheme.headlineMedium),
                              Text('On Office', style: textTheme.bodyMedium),
                              ]
                              else...[
                                Text('Today is your day off!', style: textTheme.headlineMedium,textAlign: TextAlign.center,),
                              ]
                            ]

                          ],
                        ),
                      ),
                      Container(
                        height: itemHeight,
                        width: itemWidth,
                        padding: EdgeInsets.all(16).r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16).r,
                        ),
                        child: Column(
                          spacing: 15.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 10.w,
                              children: [
                                Container(
                                  width: 30.w,
                                  height: 30.h,
                                  padding: EdgeInsets.all(5).r,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF6C951).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10).r,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/logout.svg',
                                    width: 5.w,
                                    height: 5.h,
                                    colorFilter: ColorFilter.mode(
                                      Color(0xFFF6C951),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                Text('Check Out', style: textTheme.bodyMedium),
                              ],
                            ),
                            if(state is CalendarLoading)
                              SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator( strokeWidth: 3,)),
                            if(state is CalendarLoaded) ...[
                              if(state.scheduleToday.isNotEmpty) ...[

                                Text(DateFormat('HH:mm').format(DateTime.parse("${DateTime.now().toIso8601String().split('T')[0]} ${state.scheduleToday.first.shift?.endTime}")), style: textTheme.headlineMedium),
                                Text('Go Home', style: textTheme.bodyMedium),
                              ]else ...[
                                Text('Today is your day off!', style: textTheme.headlineMedium, textAlign: TextAlign.center,),
                              ]
                            ]
                          ],
                        ),
                      ),
                      Container(
                        width: itemWidth,
                        height: itemHeight,

                        padding: EdgeInsets.all(16).r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16).r,
                        ),
                        child: Column(
                          spacing: 15.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 10.w,
                              children: [
                                Container(
                                  width: 30.w,
                                  height: 30.h,
                                  padding: EdgeInsets.all(5).r,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF6C951).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10).r,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/break.svg',
                                    width: 5.w,
                                    height: 5.h,
                                    colorFilter: ColorFilter.mode(
                                      Color(0xFFF6C951),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                Text('Break', style: textTheme.bodyMedium),
                              ],
                            ),
                            if(state is CalendarLoading)
                              SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator( strokeWidth: 3.r,)),
                            if(state is CalendarLoaded)
                              if(state.scheduleToday.isNotEmpty)...[

                              Text("0 hours", style: textTheme.headlineMedium),
                              Text('Break', style: textTheme.bodyMedium),
                              ] else ...[
                                Text("No break!", style: textTheme.headlineMedium),
                              ]
                          ],
                        ),
                      ),
                      Container(
                        height: itemHeight,
                        width: itemWidth,
                        padding: const EdgeInsets.all(16).r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16).r,
                        ),
                        child: Column(
                          spacing: 10.h,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hàng trên: icon + tiêu đề
                            Row(
                              spacing: 10.w,
                              children: [
                                Container(
                                  width: 30.w,
                                  height: 30.h,
                                  padding: EdgeInsets.all(5).r,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF6C951).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10).r,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/calendar.svg',
                                    width: 5.w,
                                    height: 5.h,
                                    colorFilter: ColorFilter.mode(
                                      Color(0xFFF6C951),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                Text('Total Days', style: textTheme.bodyMedium),
                              ],
                            ),
                            Center(
                              child: HalfCircleProgress(
                                progress: percent,
                                progressColor: Color(0xFFF6C951),
                                backgroundColor: Colors.grey.shade300,
                                size: 80.sp,
                              ),
                            ),
                            Center(
                              child: Text(
                                "$workingDays / $totalDays days ",
                                style: textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          ),
        ),
      ],
    );
  }
}
