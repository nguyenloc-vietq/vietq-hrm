import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vietq_hrm/blocs/notifications/notifications_bloc.dart';
import 'package:vietq_hrm/models/notification.models.dart';
import 'package:vietq_hrm/utils/converHtmlToText.dart';


class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Khi cuộn gần cuối → load thêm
      context.read<NotificationBloc>().add(const FetchNotificationEvent());
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const Center(child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Color(0xFFF8D448),
                strokeWidth: 3,
              ))

          );
        }
        if (state is NotificationError) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(
                const FetchNotificationEvent(isRefresh: false),
              );
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFF8D448).withAlpha(600),
                            ),
                            child: SizedBox(
                              width: 70,
                              height: 70,
                              child: SvgPicture.asset(
                                'assets/icons/notification-error.svg',
                                color: Color(0xFFF8D448),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text("Fetch Notification is error, please refresh notification", style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (state is NotificationLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(
                const FetchNotificationEvent(isRefresh: false),
              );
            },
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.notifications.length + (state.hasReachedMax ? 0 : 1),
              separatorBuilder: (context, index) {
                return Divider(color: Colors.grey.shade200, height: 1);
              },
              itemBuilder: (context, index) {
                return NotificationItems(notification: state.notifications[index]);
              },
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            context.read<NotificationBloc>().add(
              const FetchNotificationEvent(isRefresh: true),
            );
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFF8D448).withAlpha(600),
                          ),
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: SvgPicture.asset(
                              'assets/icons/notifications.svg',
                              color: Color(0xFFF8D448),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text("Notification is empty", style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );

      },
    );
  }
}

class NotificationItems extends StatelessWidget {
  final NotificationModel notification;
  const NotificationItems({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          overlayColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          context.push('/notification/${notification.notificationCode}');
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF8D448).withAlpha(600),
              ),
              child: SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  'assets/icons/notification-icon.svg',
                  color: Color(0xFFF8D448),
                ),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.notification?.title ?? '',
                    style: textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    extractCleanText(notification.notification?.body ?? ''),
                    // notification.notification?.body ?? '',
                    style: textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(notification.updatedAt as String).toLocal()).toString(),
                    style: textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
