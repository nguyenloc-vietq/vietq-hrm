import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          color: dataItem['attendance_status'] == 'late' ? Colors.red : dataItem['attendance_status'] == 'present' ? Colors.green : dataItem['attendance_status'] == 'tardy' ? Colors.orange : Colors.grey,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
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
                    Text(dataItem['company'] + ' - ' + dataItem['attendance_date'], style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),),
                  ],
                ),
                    Text('Late: ${dataItem['timeLate']}'),
                    Text('Early Leaving: ${dataItem['earlyLeaving']}'),
                    Text('Over Time: ${dataItem['overtime']}'),
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

              ]
            ),
          ),
        ],
      ),
    ),
  );
}

class _TimeSheetState extends State<TimeSheet> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return _timeSheetItems({
          "company": "VietQ",
          "employee_leave": [],
          "attendance_date": "2025/11/04",
          "attendance_status": "present",
          "timeIn": "10:38",
          "timeOut": "10:49",
          "timeLate": "02:38",
          "earlyLeaving": "06:10",
          "overtime": "00:00",
        }, context);
      },
    );
  }
}
