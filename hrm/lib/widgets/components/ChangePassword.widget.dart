import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          context.push('/user/change-password', extra: "Change Password");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Change Password", style: textTheme.headlineSmall,),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(Icons.arrow_forward_ios, size: 20),
            )
          ],
        ),
      ),
    );
  }
}
