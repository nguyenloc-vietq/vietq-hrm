import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<dynamic>? actions;

  const CustomDetailAppBar({
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
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_outlined, color: isDarkMode ? Colors.white : Colors.black),
         onPressed: () => context.pop(),
      ),
      title: Text(
        title,
        style: textTheme.headlineMedium,
      ),
      actions: actions?.map((action) {
        return IconButton(
          icon: SvgPicture.asset(action['icon']),
          onPressed: action['action'],
        );
      }).toList(),
    );
  }
}
