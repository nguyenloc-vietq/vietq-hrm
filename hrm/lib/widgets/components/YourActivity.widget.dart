import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vietq_hrm/widgets/customWidgets/HalfCircleProgress.widget.dart';

class YourActivity extends StatefulWidget {
  const YourActivity({super.key});

  @override
  State<YourActivity> createState() => _YourActivityState();
}

class _YourActivityState extends State<YourActivity> {
  final int totalDays = 26;
  final int workingDays = 10;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double percent = totalDays == 0 ? 0 : workingDays / totalDays;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Activity', style: textTheme.headlineMedium),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8D448).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/login.svg',
                      width: 5,
                      height: 5,
                      colorFilter: ColorFilter.mode(
                        Color(0xFFF8D448),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check In', style: textTheme.headlineSmall),
                      Text(
                        'April 10, 2025',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('08:00 am', style: textTheme.headlineSmall),
                      Text(
                        'On Office',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ],
    );
  }
}
