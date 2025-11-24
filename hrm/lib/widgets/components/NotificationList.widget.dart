import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final state = context.read<NotificationBloc>().state;
    if (state is NotificationLoaded &&
        !state.hasReachedMax &&
        !state.isLoadingMore &&
        position.pixels >= position.maxScrollExtent - 200) {
      print("#==========> Load");
      context
          .read<NotificationBloc>()
          .add(const FetchNotificationEvent(isRefresh: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return Center(child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
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
                            color: Theme.of(context).primaryColor.withAlpha(600),
                            ),
                            child: SizedBox(
                              width: 70,
                              height: 70,
                              child: SvgPicture.asset(
                                'assets/icons/notification-error.svg',
                                color: Theme.of(context).primaryColor,
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
                const FetchNotificationEvent(),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
              child: ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.notifications.length+ (state.hasReachedMax ? 0 : 1),
                separatorBuilder: (context, index) {
                  return Divider(color: Colors.grey.shade200, height: 1);
                },
                itemBuilder: (context, index) {
                  return NotificationItems(notification: state.notifications[0], isShowIcon: true,);
                },
              ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20).r,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 70.w,
                          height: 70.h,
                          padding: EdgeInsets.all(15).r,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100).r,
                            color: Theme.of(context).primaryColor.withAlpha(600),
                          ),
                          child: SizedBox(
                            width: 70.w,
                            height: 70.w,
                            child: SvgPicture.asset(
                              'assets/icons/notifications.svg',
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h,),
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
  final bool isShowIcon;
  const NotificationItems({super.key, required this.notification, required this.isShowIcon});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16).r,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          overlayColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          context.push('/notification/${notification.notificationCode}', extra: "Notification");
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: isShowIcon ? 20.h : 0,
          children: [
            isShowIcon ? Container(
              padding: EdgeInsets.all(15).r,
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withAlpha(600),
              ),
              child: SizedBox(
                width: 20.w,
                height: 20.h,
                child: SvgPicture.asset(
                  'assets/icons/notification-icon.svg',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ) : SizedBox(width: 0,),
            Expanded(
              child: Column(
                spacing: 5.h,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.notification?.title ?? '',
                    style: textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Text(
                  //   extractCleanText(notification.notification?.body ?? ''),
                  //   // notification.notification?.body ?? '',
                  //   style: textTheme.bodyMedium,
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
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
