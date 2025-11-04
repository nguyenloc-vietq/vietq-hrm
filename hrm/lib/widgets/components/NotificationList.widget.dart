import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey.shade200,
          height: 1,
        );
      },
      itemBuilder: (context, index) {
        return NotificationItems();
      },
    );
  }
}

class NotificationItems extends StatelessWidget {
  const NotificationItems({super.key});

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
          context.push('/notification/11771');
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF8D448).withAlpha(600),
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  "https://iweather.edu.vn/upload/2025/04/avatar-memes.webp",
                ),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('<Name> is approved your leave application', style: textTheme.headlineSmall, overflow: TextOverflow.ellipsis,),
                  Text('Your leave application has been approved by <Name>', style: textTheme.bodyMedium, overflow: TextOverflow.ellipsis,),
                  Text('10-10-2025 10:10:10', style: textTheme.bodySmall, overflow: TextOverflow.ellipsis,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
