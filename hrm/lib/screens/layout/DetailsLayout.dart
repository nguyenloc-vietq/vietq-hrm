import 'package:flutter/material.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/CustomAppBar.widget.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/CustomDetailAppBar.widget.dart';

class DetailsLayout extends StatelessWidget {
  final Widget child;
  final String title;
  const DetailsLayout({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDetailAppBar(title: title.isNotEmpty ? title : 'Detail Notification' ),
      body: child,
    );
  }
}
