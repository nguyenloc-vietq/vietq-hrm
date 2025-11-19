import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                  filter: ImageFilter.blur(sigmaX: 6.r, sigmaY: 6.r),
                  child: Container(
                    color: Colors.black.withOpacity(0.3), // mờ nhẹ
                  ),
                ),

                // Loader giữa màn hình
                Center(
                  child: SizedBox(
                    height: 80.w,
                    width: 80.h,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)).r,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.r,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(25.0).r,
                        child: CircularProgressIndicator(
                          strokeWidth: 4.r,
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
