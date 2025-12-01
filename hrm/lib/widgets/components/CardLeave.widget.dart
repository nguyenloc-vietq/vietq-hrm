import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardLeaveWidget extends StatelessWidget {
  const CardLeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final appBarTheme = Theme.of(context).appBarTheme;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDarkMode ? appBarTheme.foregroundColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.withAlpha(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date", style: textTheme.bodyMedium),
                  SizedBox(height: 10.h),
                  Text(
                    "10/10/2025 - 12/10/2025",
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineSmall,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF94CB2C).withAlpha(50),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    "Approved",
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF94CB2C),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(color: Colors.grey.withAlpha(50), thickness: 1),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Apply Days", style: textTheme.bodyMedium),
                  SizedBox(height: 10.h),
                  Text(
                    "2 Days",
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineSmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Leave Balance", style: textTheme.bodyMedium),
                  SizedBox(height: 10.h),
                  Text(
                    "19",
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineSmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Approved By", style: textTheme.bodyMedium),
                  SizedBox(height: 10.h),
                  Text(
                    "Duy Huu",
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineSmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
