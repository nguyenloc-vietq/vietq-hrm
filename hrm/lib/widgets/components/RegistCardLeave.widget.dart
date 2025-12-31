import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegistCardLeaveWidget extends StatelessWidget {
  // Thêm tham số summary để nhận dữ liệu từ RegisterPage
  final Map<String, dynamic> summary;

  const RegistCardLeaveWidget({
    super.key,
    this.summary = const {}, // Mặc định là map rỗng để tránh lỗi null
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Chuẩn bị danh sách dựa trên dữ liệu thực tế từ summary
    final List<Map<String, dynamic>> leaveTypes = [
      {
        "title": "Annual \nLeave",
        "balance": "${summary['annualLeave'] ?? 0}",
        "color": "0xFF266CCB"
      },
      {
        "title": "Leave \nApproved",
        "balance": "${summary['approved'] ?? 0}",
        "color": "0xFF94CB2C"
      },
      {
        "title": "Leave \nPending",
        "balance": "${summary['pending'] ?? 0}",
        "color": "0xFF2CB2A7"
      },
      {
        "title": "Leave \nRejected",
        "balance": "${summary['rejected'] ?? 0}",
        "color": "0xFFFC6861"
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w, // Thêm .w để responsive
          mainAxisSpacing: 12.h,  // Thêm .h để responsive
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
              border: Border.all(color: color.withOpacity(0.5)), // Làm mờ border một chút cho đẹp
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['title'],
                  style: textTheme.titleMedium?.copyWith( // Dùng titleMedium để tránh quá to trên màn hình nhỏ
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  item['balance'],
                  style: textTheme.headlineMedium?.copyWith(
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
