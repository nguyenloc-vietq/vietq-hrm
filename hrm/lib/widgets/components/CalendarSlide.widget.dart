import 'package:flutter/material.dart';
import 'package:vietq_hrm/utils/getDayInMonth.dart';

class CalendarSlideWidget extends StatefulWidget {
  const CalendarSlideWidget({super.key});

  @override
  State<CalendarSlideWidget> createState() => _CalendarSlideWidgetState();
}

class _CalendarSlideWidgetState extends State<CalendarSlideWidget> {
  final listDay = getDaysInfoInCurrentMonth();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDay();
    });
  }

  void _scrollToCurrentDay() {
    // Tìm index của ngày hiện tại
    final currentIndex =
    listDay.indexWhere((day) => day["currentDay"] == true);

    if (currentIndex != -1) {
      const itemWidth = 86.0; // 80 (width) + 6 (margin)
      final position = (currentIndex-2) * itemWidth;
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemCount: listDay.length,
      itemBuilder: (context, index) {
        final day = listDay[index];
        return Container(
          width: 80,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: day["currentDay"]
                ? Color(0xFFF6C951).withOpacity(0.8)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: day["currentDay"]
                  ? Color(0xFFF6C951)
                  : Colors.grey.shade300,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day["day"].toString(),
                style: textTheme.headlineMedium?.copyWith(
                  color: day["currentDay"] ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                day["weekday"].toString(),
                style: textTheme.bodyMedium?.copyWith(
                  color: day["currentDay"] ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
