import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vietq_hrm/blocs/calendars/calendar_bloc.dart';
import 'package:vietq_hrm/widgets/customWidgets/HalfCircleProgress.widget.dart';

class TodayInfoWidget extends StatefulWidget {
  const TodayInfoWidget({super.key});

  @override
  State<TodayInfoWidget> createState() => _TodayInfoWidgetState();
}

class _TodayInfoWidgetState extends State<TodayInfoWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if(state is CalendarLoading) {
            return Skeletonizer(
              enabled: true,
              effect: PulseEffect(),
              child: Container(
                child: Column(
                  spacing: 16.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Work Day", style: textTheme.headlineMedium,),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  'assets/icons/calendar.svg',
                                  width: 5.w,
                                  height: 5.h,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              Column(
                                spacing: 5.h,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${DateFormat("dd-MM-yyyy").format(DateTime.now().toLocal()).toString()}', style: textTheme.headlineSmall),
                                  Text(
                                      "Begin in: 08:00"
                                  ),
                                  Text(
                                      "End in: 17:00"
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                spacing: 16.h,
                                children: [
                                  Center(
                                    child: HalfCircleProgress(
                                      progress: 4/26,
                                      progressColor: Theme.of(context).colorScheme.primary,
                                      backgroundColor: Colors.grey.shade300,
                                      size: 80.sp,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "04 / 26 days ",
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            );
          }
          if(state is CalendarLoaded) {
            return Container(
              child: Column(
                spacing: 16.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Work Day", style: textTheme.headlineMedium,),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                'assets/icons/calendar.svg',
                                width: 5.w,
                                height: 5.h,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Column(
                              spacing: 5.h,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(DateFormat("dd-MM-yyyy").format(DateTime.now().toLocal()), style: textTheme.headlineSmall),
                                if(state.scheduleToday.length == 0) ...[
                                  Text("Begin in: OFF"),
                                  Text("End in: OFF"),
                                ] else ...[
                                  Text(
                                      "Begin in: ${DateFormat('HH:mm').format(DateTime.parse("${DateTime.now().toIso8601String().split('T')[0]} ${state.scheduleToday.first.shift?.startTime}")).toString()}"
                                  ),
                                  Text(
                                      "End in: ${DateFormat('HH:mm').format(DateTime.parse("${DateTime.now().toIso8601String().split('T')[0]} ${state.scheduleToday.first.shift?.endTime}")).toString()}"
                                  ),
                                ]
                              ],
                            ),
                            Spacer(),
                            Column(
                              spacing: 16.h,
                              children: [
                                Center(
                                  child: HalfCircleProgress(
                                    progress: 4/26,
                                    progressColor: Theme.of(context).colorScheme.primary,
                                    backgroundColor: Colors.grey.shade300,
                                    size: 80.sp,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "04 / 26 days ",
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            );
          }
          return Container(
            child: Column(
              spacing: 16.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Work Day", style: textTheme.headlineMedium,),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              'assets/icons/calendar.svg',
                              width: 5.w,
                              height: 5.h,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          Column(
                            spacing: 5.h,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${DateFormat("dd-MM-yyyy").format(DateTime.now().toLocal()).toString()}', style: textTheme.headlineSmall),
                              Text(
                                  "Begin in: 08:00"
                              ),
                              Text(
                                  "End in: 17:00"
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            spacing: 16.h,
                            children: [
                              Center(
                                child: HalfCircleProgress(
                                  progress: 4/26,
                                  progressColor: Theme.of(context).colorScheme.primary,
                                  backgroundColor: Colors.grey.shade300,
                                  size: 80.sp,
                                ),
                              ),
                              Center(
                                child: Text(
                                  "04 / 26 days ",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
          );
        }
    );
  }
}
