import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vietq_hrm/widgets/customWidgets/HalfCircleProgress.widget.dart';

class TodayAttendance extends StatefulWidget {
  const TodayAttendance({super.key});

  @override
  State<TodayAttendance> createState() => _TodayAttendanceState();
}

class _TodayAttendanceState extends State<TodayAttendance> {
  final int totalDays = 26;
  final int workingDays = 10;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double percent = totalDays == 0 ? 0 : workingDays / totalDays;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today Attendance', style: textTheme.headlineMedium),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            double spacing = 16;
            double itemWidth = (constraints.maxWidth - spacing) / 2;
            double itemHeight = 150;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                Container(
                  width: itemWidth,
                  height: itemHeight,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color(0xFFF6C951).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/login.svg',
                              width: 5,
                              height: 5,
                              colorFilter: ColorFilter.mode(
                                Color(0xFFF6C951),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          Text('Check In', style: textTheme.bodyMedium),
                        ],
                      ),
                      Text('08:00 am', style: textTheme.headlineMedium),
                      Text('On Office', style: textTheme.bodyMedium),
                    ],
                  ),
                ),
                Container(
                  height: itemHeight,
                  width: itemWidth,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color(0xFFF6C951).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/logout.svg',
                              width: 5,
                              height: 5,
                              colorFilter: ColorFilter.mode(
                                Color(0xFFF6C951),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          Text('Check Out', style: textTheme.bodyMedium),
                        ],
                      ),
                      Text('05:00 pm', style: textTheme.headlineMedium),
                      Text('Go Home', style: textTheme.bodyMedium),
                    ],
                  ),
                ),
                Container(
                  width: itemWidth,
                  height: itemHeight,

                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color(0xFFF6C951).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/break.svg',
                              width: 5,
                              height: 5,
                              colorFilter: ColorFilter.mode(
                                Color(0xFFF6C951),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          Text('Break Time', style: textTheme.bodyMedium),
                        ],
                      ),
                      Text('01:00 hour', style: textTheme.headlineMedium),
                      Text('Break', style: textTheme.bodyMedium),
                    ],
                  ),
                ),
                Container(
                  height: itemHeight,
                  width: itemWidth,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hàng trên: icon + tiêu đề
                      Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color(0xFFF6C951).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/calendar.svg',
                              width: 5,
                              height: 5,
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
                          size: 80,
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
        ),
      ],
    );
  }
}
