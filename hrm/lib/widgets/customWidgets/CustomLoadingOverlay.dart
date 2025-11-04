import 'dart:ui';
import 'package:flutter/material.dart';

class CustomLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  const CustomLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // UI chính
        child,

        // Layer loading đè lên trên
        if (isLoading)
          Positioned.fill(
            child: Stack(
              children: [
                // Nền mờ kiểu blur
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    color: Colors.black.withOpacity(0.3), // mờ nhẹ
                  ),
                ),

                // Loader giữa màn hình
                const Center(
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(25.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: Color(0xFFF8D448),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
