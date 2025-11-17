import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vietq_hrm/blocs/calendars/calendar_bloc.dart';
import 'package:vietq_hrm/configs/apiConfig/schedule.api.dart';
import 'package:vietq_hrm/models/timeSheet.models.dart';
import 'package:vietq_hrm/utils/converMinutes.dart';

class TimeSheet extends StatefulWidget {
  const TimeSheet({super.key});

  @override
  State<TimeSheet> createState() => _TimeSheetState();
}

Widget _timeSheetItems(Map<String, dynamic> dataItem, BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 10,
            decoration: BoxDecoration(
              color: dataItem['attendance_status'] == 'late'
                  ? Colors.red
                  : dataItem['attendance_status'] == 'present'
                  ? Colors.green
                  : dataItem['attendance_status'] == 'tardy'
                  ? Colors.orange
                  : Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
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
                    Text(
                      dataItem['company'] + ' - ' + dataItem['attendance_date'],
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text('Late: ${dataItem['timeLate']}'),
                Text('Early Leaving: ${dataItem['earlyLeaving']}'),
                // Text('Over Time: ${dataItem['overtime']}'),
                Row(
                  spacing: 20,
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
                        Text(dataItem['timeIn']),
                      ],
                    ),
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
                        Text(dataItem['timeOut']),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _TimeSheetState extends State<TimeSheet>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state is CalendarLoading) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Color(0xFFF8D448),
                strokeWidth: 3,
              ),
            ),
          );
        }
        if (state is CalendarError) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CalendarBloc>().add(
                const LoadCalendarEvent(isRefresh: false),
              );
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0xFFF8D448).withAlpha(600),
                            ),
                            child: SizedBox(
                              width: 70,
                              height: 70,
                              child: SvgPicture.asset(
                                'assets/icons/calendar-error.svg',
                                color: Color(0xFFF8D448),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Fetch calendar is error, please refresh calendar ${state.message}",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (state is CalendarLoaded) {
          print("#==========> NEW TIME SHEETS ${state.timeSheets?.attendanceRecs}");
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CalendarBloc>().add(
                const LoadCalendarEvent(isRefresh: true),
              );
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount:
                  state.timeSheets!.attendanceRecs!.length,
              itemBuilder: (context, index) {
                final attendanceRecs = state.timeSheets!.attendanceRecs;

                return _timeSheetItems({
                  "company": state.timeSheets?.company?.companyName,
                  "employee_leave": [],
                  "attendance_date": DateFormat("yyyy-MM-dd")
                      .format(
                        DateTime.parse(
                          attendanceRecs![index].workDay ?? '',
                        ).toLocal(),
                      )
                      .toString(),
                  "attendance_status": "present",
                  "timeIn": DateFormat("HH:mm:ss")
                      .format(
                        DateTime.parse(
                          attendanceRecs[index].timeIn as String,
                        ).toLocal(),
                      )
                      .toString(),
                  "timeOut": attendanceRecs[index].timeOut!= null ? DateFormat("HH:mm:ss")
                      .format(
                        DateTime.parse(
                          attendanceRecs[index].timeOut as String,
                        ).toLocal(),
                      )
                      .toString() : "Not yet timed out",
                  "timeLate": formatMinutesToHHMM(
                    attendanceRecs[index].lateMinutes ?? 0,
                  ),
                  "earlyLeaving": formatMinutesToHHMM(
                    attendanceRecs[index].earlyMinutes ?? 0,
                  ),
                  // "overtime": attendanceRecs[index].overtime,
                }, context);
              },
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<CalendarBloc>().add(
              const LoadCalendarEvent(isRefresh: true),
            );
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFF8D448).withAlpha(600),
                          ),
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: SvgPicture.asset(
                              'assets/icons/calendar.svg',
                              color: Color(0xFFF8D448),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Time sheet is empty",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
