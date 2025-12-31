import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart'; // Thêm thư viện để format ngày tháng

class CardLeaveWidget extends StatelessWidget {
  // Nhận dữ liệu của từng đơn đăng ký từ RegisterPage
  final dynamic data;

  const CardLeaveWidget({
    super.key,
    required this.data,
  });

  // Hàm helper để xác định màu sắc dựa trên status
  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'APPROVED':
        return const Color(0xFF94CB2C);
      case 'PENDING':
        return const Color(0xFF2CB2A7);
      case 'REJECTED':
        return const Color(0xFFFC6861);
      default:
        return Colors.grey;
    }
  }

  // Hàm format hiển thị ngày tháng
  String _formatDate(String? dateStr) {
    if (dateStr == null) return "N/A";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox();

    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final appBarTheme = Theme.of(context).appBarTheme;

    final status = data['status'] ?? 'PENDING';
    final statusColor = _getStatusColor(status);

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
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date Range", style: textTheme.bodySmall),
                    SizedBox(height: 5.h),
                    Text(
                      "${_formatDate(data['startDate'])} - ${_formatDate(data['endDate'])}",
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: statusColor.withOpacity(0.5)),
                ),
                child: Text(
                  status,
                  style: textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: Colors.grey.withAlpha(40), thickness: 1),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(
                context,
                "Reason",
                data['reason'] ?? "No reason",
              ),
              _buildInfoColumn(
                context,
                "Days",
                "${data['totalDays'] ?? '0'} Days",
              ),
              _buildInfoColumn(
                context,
                "Type",
                data['type'] ?? "Leave",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
          SizedBox(height: 5.h),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
