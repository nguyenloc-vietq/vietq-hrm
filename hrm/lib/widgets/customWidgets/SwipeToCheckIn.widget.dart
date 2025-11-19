import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:flutter/material.dart';

class SwipeToCheckIn extends StatelessWidget {
  final Color background;
  final String title;
  final Future<void> Function() onSwipe;

  const SwipeToCheckIn({
    super.key,
    required this.background,
    required this.title,
    required this.onSwipe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      child: SlideAction(
        innerColor: Colors.white,
        outerColor: background,
        sliderButtonIcon: Icon(Icons.arrow_forward, color: background),
        text: title,
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        onSubmit: () => onSwipe(),
      ),
    );
  }
}
