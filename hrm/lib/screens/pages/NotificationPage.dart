import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietq_hrm/blocs/notifications/notifications_bloc.dart';
import 'package:vietq_hrm/configs/apiConfig/notification.api.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/CustomAppBar.widget.dart';
import 'package:vietq_hrm/widgets/components/NotificationList.widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).appBarTheme.backgroundColor
          : Colors.white,
      appBar: CustomAppBar(
        title: 'Notification',
        actions: [
        ],
      ),
      body: NotificationWidget(),
    );
  }
}
