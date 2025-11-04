import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  final Widget icon;
  final double size;
  final Gradient gradient;

  const GradientIcon(
      this.icon, {
        super.key,
        this.size = 24,
        required this.gradient,
      });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          gradient.createShader(Rect.fromLTWH(0, 0, size, size)),
      child: icon,
    );
  }
}
