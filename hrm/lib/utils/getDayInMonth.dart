List<Map<String, dynamic>> getDaysInfoInCurrentMonth() {
  final now = DateTime.now();
  final firstDay = DateTime(now.year, now.month, 1);
  final nextMonth = DateTime(now.year, now.month + 1, 1);
  final lastDay = nextMonth.subtract(const Duration(days: 1));

  const weekdays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  final List<Map<String, dynamic>> daysInfo = [];

  for (int i = 0; i < lastDay.day; i++) {
    final date = DateTime(now.year, now.month, i + 1);

    daysInfo.add({
      "day": date.day,
      "month": date.month,
      "year": date.year,
      "weekday": weekdays[date.weekday - 1],
      "currentDay": date.day == now.day,
    });
  }

  return daysInfo;
}