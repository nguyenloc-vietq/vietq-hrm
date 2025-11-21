import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SalaryInfoWidget extends StatelessWidget {
  const SalaryInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.h,
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Salary Info', style: textTheme.headlineMedium),
              Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),

                onPressed: () {},
                child: Text(
                  "View All",
                  style: textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
        ),

        Wrap(
          spacing: 16.r,
          runSpacing: 16.r,
          children: [
            Container(
              padding: EdgeInsets.all(16).r,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Theme.of(context).appBarTheme.foregroundColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(16).r,
              ),
              child: Row(
                spacing: 15.w,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    padding: EdgeInsets.all(5).r,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/money-receive.svg',
                      width: 5.w,
                      height: 5.h,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payroll 10/2025', style: textTheme.headlineSmall),
                      Text(
                        DateFormat(
                          "MMMM d, yyyy",
                        ).format(DateTime.parse("2025-11-10").toLocal()),
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  SizedBox(
                    width: 40.w,
                    height: 40.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Adjust the radius as needed
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {},
                      child: Icon(
                        Icons.download,
                        size: 30.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
