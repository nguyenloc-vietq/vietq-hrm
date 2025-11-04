import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<dynamic>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: textTheme.headlineMedium),
            if (actions != null)
              Container(
                 child: Wrap(
                    spacing: 4,
                    children: actions!.map((action) => IconButton(
                      icon: SvgPicture.asset(action['icon']),
                      onPressed: action['action'],
                    )).toList(),
                  )
              ),
          ],
        )
      ),
    );
  }
}
