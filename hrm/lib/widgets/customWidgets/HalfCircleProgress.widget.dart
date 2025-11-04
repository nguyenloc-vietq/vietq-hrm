import 'package:flutter/material.dart';
import 'dart:math' as math;

class HalfCircleProgress extends StatelessWidget {
  final double progress; // 0.0 → 1.0
  final double size;
  final Color backgroundColor;
  final Color progressColor;

  const HalfCircleProgress({
    super.key,
    required this.progress,
    this.size = 120,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size / 2),
      painter: _HalfCirclePainter(
        progress: progress,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
      ),
    );
  }
}

class _HalfCirclePainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _HalfCirclePainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Vẽ vòng cung nền (180°)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // bắt đầu từ bên trái
      math.pi, // quét nửa vòng (180°)
      false,
      backgroundPaint,
    );

    // Vẽ vòng cung tiến độ
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // từ bên trái
      math.pi * progress, // tỉ lệ tiến độ
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
