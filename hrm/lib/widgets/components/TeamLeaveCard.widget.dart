import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TeamLeaveWidget extends StatelessWidget {
  final dynamic data;
  final Function(String id)? onApprove;
  final Function(String id)? onReject;

  const TeamLeaveWidget({
    super.key,
    required this.data,
    this.onApprove,
    this.onReject,
  });

  // Helper xác định màu sắc cho từng loại trạng thái
  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'APPROVED':
        return const Color(0xFF94CB2C);
      case 'REJECTED':
        return const Color(0xFFFC6861);
      default:
        return const Color(0xFF2CB2A7); // PENDING
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null || data is! Map || data.isEmpty) return const SizedBox();

    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Đảm bảo lấy đúng các key từ response JSON của bạn
    final status = data['status'] ?? 'PENDING';
    final userCode = data['user']['fullName'] ?? "Unknown";
    final registrationCode = data['registrationCode'] ?? "N/A";
    final statusColor = _getStatusColor(status);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar & Thông tin nhân viên
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  userCode.isNotEmpty ? userCode[0].toUpperCase() : "U",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userCode,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      "ID: $registrationCode",
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  status,
                  style: textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),
          const Divider(height: 1),
          SizedBox(height: 16.h),

          // Thông tin chi tiết nghỉ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(context, "Type", data['type'] ?? "LEAVE"),
              _buildInfoItem(context, "Start", _formatDate(data['startDate'])),
              _buildInfoItem(context, "End", _formatDate(data['endDate'])),
            ],
          ),

          SizedBox(height: 12.h),
          Text("Reason:", style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
          SizedBox(height: 4.h),
          Text(
            data['reason'] ?? "No reason provided",
            style: textTheme.bodyMedium,
          ),

          // Nút hành động (Chỉ hiện khi PENDING)
          if (status.toString().toUpperCase() == 'PENDING') ...[
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onReject?.call(data['registrationCode']),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: const Text("Reject"),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onApprove?.call(data['registrationCode']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF94CB2C),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: const Text("Approve"),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
        SizedBox(height: 4.h),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : Colors.black)
        ),
      ],
    );
  }
}
