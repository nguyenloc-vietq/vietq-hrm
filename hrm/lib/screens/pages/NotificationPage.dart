import 'package:flutter/material.dart';
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
      appBar: CustomAppBar(title: 'Notification', actions: [
        {
          'icon': 'assets/icons/setting.svg',
          'action': () {
            print('hello');
          },
        }
      ],),
      body: NotificationWidget()
    );
  }
}
