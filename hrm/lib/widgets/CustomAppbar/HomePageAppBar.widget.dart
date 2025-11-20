import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String avatar;
  final String name;
  final String position;

  const HomePageAppBar({
    super.key,
    required this.avatar,
    required this.name,
    required this.position,
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
      flexibleSpace: Container(
        color: isDarkMode ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
        padding: const EdgeInsets.only(top: 60, left: 16, right: 16).r,
        child: Row(
          spacing: 10.w,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3.r),
              ),
              child: CircleAvatar(
                radius: 50.r,
                backgroundImage: NetworkImage(avatar),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: textTheme.headlineMedium),
                Text(position, style: textTheme.headlineSmall?.copyWith(color: Colors.grey)),
              ],
            ),
            Spacer(),
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1.r),
              ),
              child: SizedBox(
                width: 30.w,
                height: 30.h,
                child: IconButton(onPressed: () {
                  context.go("/notification");
                }, icon: SvgPicture.asset(
                  'assets/icons/notifications.svg',
                  colorFilter: ColorFilter.mode(
                    isDarkMode ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),),
              )
            ),
          ],
        ),
      ),
    );
  }
}
