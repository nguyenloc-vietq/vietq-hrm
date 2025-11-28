import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
class AppBarAction {
  final String icon;
  final VoidCallback action;

  AppBarAction({required this.icon, required this.action});
}
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<AppBarAction>? actions;

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
            if (actions?.length != 0)
              Container(
                 child: Wrap(
                    spacing: 4.w,
                    children: actions!.map((action) => IconButton(
                      icon: SvgPicture.asset(action.icon, color: isDarkMode ? Colors.white : Colors.black,),
                      onPressed: action.action,
                    )).toList(),
                  )
              ),
          ],
        )
      ),
    );
  }
}
