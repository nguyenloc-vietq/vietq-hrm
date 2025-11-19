import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientIcon extends StatelessWidget {
  final Widget icon;
  final double size;
  final Gradient? gradient;
  final Color? color;

  const GradientIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.gradient,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (gradient != null) {
      return ShaderMask(
        shaderCallback: (bounds) =>
            gradient!.createShader(Rect.fromLTWH(0, 0, size, size)),
        blendMode: BlendMode.srcIn,
        child: SizedBox(
          width: size,
          height: size,
          child: icon,
        ),
      );
    }

    // Nếu không có gradient, chỉ đổi màu nếu có truyền
    if (color != null) {
      return SizedBox(
        width: size,
        height: size,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
          child: icon,
        ),
      );
    }

    return SizedBox(width: size, height: size, child: icon);
  }
}
