import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegistCardLeaveWidget extends StatefulWidget {
  const RegistCardLeaveWidget({super.key});

  @override
  State<RegistCardLeaveWidget> createState() => _RegistCardLeaveWidgetState();
}

class _RegistCardLeaveWidgetState extends State<RegistCardLeaveWidget> {
  final List<dynamic> leaveTypes = [
    {"title": "Annual \nLeave", "balance": "12", "color": "0xFF266CCB"},
    {"title": "Leave \nApproved", "balance": "12", "color": "0xFF94CB2C"},
    {"title": "Leave \nPending", "balance": "12", "color": "0xFF2CB2A7"},
    {"title": "Leave \nRejected", "balance": "12", "color": "0xFFFC6861"},
  ];
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
        ),
        itemCount: leaveTypes.length,
        itemBuilder: (context, index) {
          final item = leaveTypes[index];
          final color = Color(int.parse(item['color']));
          return Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['title'],
                  style: textTheme.titleLarge?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  item['balance'],
                  style: textTheme.headlineLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
