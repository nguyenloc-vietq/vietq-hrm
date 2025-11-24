import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vietq_hrm/blocs/notifications/notifications_bloc.dart';
import 'package:vietq_hrm/widgets/components/NotificationList.widget.dart';

class NotificationHomeWidget extends StatefulWidget {
  const NotificationHomeWidget({super.key});

  @override
  State<NotificationHomeWidget> createState() => _NotificationHomeWidgetState();
}

class _NotificationHomeWidgetState extends State<NotificationHomeWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.h,
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Notification', style: textTheme.headlineMedium),
            Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                context.go('/notification');
              },
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

        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return Skeletonizer(
                enabled: true,
                effect: PulseEffect(),
                child: Container(
                  width: double.infinity,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey.shade900
                        : Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ).r,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("this is content notification"),
                      Text("time"),
                    ],
                  ),
                ),
              );
            }
            if (state is NotificationLoaded) {
              return Column(
                spacing: 12.h,
                children: [
                  ...state.notifications
                      .take(5)
                      .map(
                        (e) => NotificationItems(
                          notification: e,
                          isShowIcon: true,
                        ),
                      ),
                  ...state.notifications
                      .take(5)
                      .map(
                        (e) => NotificationItems(
                          notification: e,
                          isShowIcon: true,
                        ),
                      ),
                  ...state.notifications
                      .take(5)
                      .map(
                        (e) => NotificationItems(
                          notification: e,
                          isShowIcon: true,
                        ),
                      ),
                  ...state.notifications
                      .take(5)
                      .map(
                        (e) => NotificationItems(
                          notification: e,
                          isShowIcon: true,
                        ),
                      ),
                  SizedBox(height: 100.h),
                ],
              );
            }
            return Center(child: Text("No Notification"));
          },
        ),
      ],
    );
  }
}
