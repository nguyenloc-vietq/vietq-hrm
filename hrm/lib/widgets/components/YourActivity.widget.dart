import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vietq_hrm/blocs/attendance/attendance_bloc.dart';
import 'package:vietq_hrm/widgets/customWidgets/HalfCircleProgress.widget.dart';

class YourActivity extends StatefulWidget {
  const YourActivity({super.key});

  @override
  State<YourActivity> createState() => _YourActivityState();
}

class _YourActivityState extends State<YourActivity> {
  final int totalDays = 26;
  final int workingDays = 10;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double percent = totalDays == 0 ? 0 : workingDays / totalDays;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.h,
          children: [
            if (state is AttendanceLoading)...[

              Skeletonizer(
                enabled: true,
                effect: PulseEffect(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text('Your Activity', style: textTheme.headlineMedium),
                    Container(
                      height: 70.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        spacing: 15.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Skeleton.replace(
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              padding: EdgeInsets.all(5).r,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/login.svg',
                                width: 5.w,
                                height: 5.h,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Check In',
                                style: textTheme.headlineSmall,
                              ),
                              Text(
                                "ske",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ske",
                                style: textTheme.headlineSmall,
                              ),
                              Text(
                                'On Office',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]

            else if (state is AttendanceError)
              Center(
                child: Text(
                  "Your activity empty!",
                  style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              )
            else if (state is AttendanceLoaded) ...[
              if (state.timeSheets?.attendanceRecs?.length != 0) ...[
                if (state.timeSheets?.attendanceRecs?.first.timeIn != null) ...[
                  Text('Your Activity', style: textTheme.headlineMedium),
                  Wrap(
                    spacing: 16.r,
                    runSpacing: 16.r,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16).r,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Theme.of(context).appBarTheme.foregroundColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16).r,
                        ),
                        child: Row(
                          spacing: 15.w,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.h,
                              padding: EdgeInsets.all(5).r,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/login.svg',
                                width: 5.w,
                                height: 5.h,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check In',
                                  style: textTheme.headlineSmall,
                                ),
                                Text(
                                  DateFormat("MMMM d, yyyy").format(
                                    DateTime.parse(
                                      state
                                              .timeSheets
                                              ?.attendanceRecs
                                              ?.first
                                              .workDay ??
                                          "",
                                    ).toLocal(),
                                  ),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat("HH:mm:ss").format(
                                    DateTime.parse(
                                      state
                                              .timeSheets
                                              ?.attendanceRecs
                                              ?.first
                                              .timeIn ??
                                          "",
                                    ).toLocal(),
                                  ),
                                  style: textTheme.headlineSmall,
                                ),
                                Text(
                                  'On Office',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                if (state.timeSheets?.attendanceRecs?.first.timeOut !=
                    null) ...[
                  Wrap(
                    spacing: 16.r,
                    runSpacing: 16.r,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16).r,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Theme.of(context).appBarTheme.foregroundColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16).r,
                        ),
                        child: Row(
                          spacing: 15.w,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.h,
                              padding: EdgeInsets.all(5).r,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/logout.svg',
                                width: 5.w,
                                height: 5.h,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check Out',
                                  style: textTheme.headlineSmall,
                                ),
                                Text(
                                  DateFormat("MMMM d, yyyy").format(
                                    DateTime.parse(
                                      state
                                              .timeSheets
                                              ?.attendanceRecs
                                              ?.first
                                              .workDay ??
                                          "",
                                    ).toLocal(),
                                  ),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat("HH:mm:ss").format(
                                    DateTime.parse(
                                      state
                                              .timeSheets
                                              ?.attendanceRecs
                                              ?.first
                                              .timeOut ??
                                          "",
                                    ).toLocal(),
                                  ),
                                  style: textTheme.headlineSmall,
                                ),
                                Text(
                                  'On Office',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ] else ...[
                Center(
                  child: Text(
                    "You haven't clocked in yet today",
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ),
              ],
            ],

          ],
        );
      },
    );
  }
}
