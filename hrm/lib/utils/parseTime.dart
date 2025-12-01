DateTime getEndOfMonth(DateTime date) {
  // day = 0 của tháng tiếp theo → ngày cuối cùng của tháng hiện tại
  return DateTime(date.year, date.month + 1, 0).toUtc();
}
DateTime getStartOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1).toUtc();
}