import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vietq_hrm/main.dart';
import 'package:vietq_hrm/screens/layout/%20MyProfilePage.dart';
import 'package:vietq_hrm/screens/layout/NotificationDetailPages.dart';
import 'package:vietq_hrm/screens/layout/PrivacyDetailPage.dart';
import 'package:vietq_hrm/screens/layout/SettingPage.dart';
import 'package:vietq_hrm/screens/layout/TermsDetailsPage.dart';
import 'package:vietq_hrm/screens/pages/CalendarPage.dart';
import 'package:vietq_hrm/screens/pages/ForgotPage.dart';
import 'package:vietq_hrm/screens/pages/HomePage.dart';
import 'package:vietq_hrm/screens/pages/LoginPage.dart';
import 'package:vietq_hrm/screens/pages/NotificationPage.dart';
import 'package:vietq_hrm/screens/pages/ProfilePage.dart';
import 'package:vietq_hrm/screens/pages/RegisterPage.dart';
import 'package:vietq_hrm/screens/pages/ResetPasswordPage.dart';

class RouterObject {
  final String name;
  final Widget? icon;
  final String route;
  final Widget page;
  final List<RouterObject> children;
  RouterObject? parent; // thêm parent
  RouterObject({
    required this.name,
    this.icon,
    required this.route,
    required this.page,
    this.children = const [],
    this.parent,
  });

  String get fullPath {
    if (parent == null) return route.startsWith('/') ? route : '/$route';
    final prefix = parent!.fullPath;
    print("#>>>>>>>>>>>>>>>>>>>: $prefix ");
    return '$prefix/${route.replaceAll('/', '')}';
  }

  @override
  String toString() => "RouterObject(name: $name, route: $route, page: $page)";
}

// Bottom navigation routers
List<RouterObject> ListBottomNavigatonRouter = [
  RouterObject(
    name: 'Trang chủ',
    icon: SvgPicture.asset(
      'assets/icons/home.svg',
      width: 24,
      height: 24,
      color: Colors.grey,
      // colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
    ),
    route: '/',
    page: HomePage(),
  ),
  RouterObject(
    name: 'Lịch Làm Việc',
    icon: SvgPicture.asset(
      'assets/icons/calendar.svg',
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
    ),
    route: '/calendar',
    page: CalendarPage(),
  ),
  RouterObject(
    name: 'Dơn Đăng Ký',
    icon: SvgPicture.asset(
      'assets/icons/library.svg',
      width: 30,
      height: 30,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    ),
    route: '/register-form',
    page: RegisterPage(),
  ),
  RouterObject(
    name: 'Thong Bao',
    icon: SvgPicture.asset(
      'assets/icons/notifications.svg',
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
    ),
    route: '/notification',
    page: NotificationPage(),
  ),
  RouterObject(
    name: 'Hot',
    icon: SvgPicture.asset(
      'assets/icons/user.svg',
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
    ),
    route: '/profile',
    page: ProfilePage(),
  ),
];
// public Routes
List<RouterObject> ListPublicRouter = [
  RouterObject(
    name: 'Login',
    route: '/login',
    page: LoginPage(),
  ),RouterObject(
    name: 'Forgot',
    route: '/forgot',
    page: ForgotPage(),
  ),RouterObject(
    name: 'reset',
    route: '/reset_password',
    page: ResetPassword(),
  ),
  // RouterObject(
  //   name: 'Register',
  //   route: '/register',
  //   page: MyHomePage(title: 'hello'),
  // ),
  // RouterObject(
  //   name: 'Product Details',
  //   route: '/product/:id',
  //   page: MyHomePage(title: 'hello'),
  // ),
];

List<RouterObject> ListDetailsRouter = [
  RouterObject(
    name: 'Details Notification',
    icon: SvgPicture.asset(
      'assets/icons/notifications.svg',
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
    ),
    route: '/notification/:idNotification',
    page: NotificationDetailPages(),
  ),
];
List<RouterObject> ListDetailProfileRouter = [
  RouterObject(
    name: 'My Profile',
    icon: SvgPicture.asset(
      'assets/icons/user.svg',
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
    ),
    route: '/my_profile',
    page: MyProfilePage(),
  ),
  RouterObject(
    name: 'Setting Page',
    icon: SvgPicture.asset(
      'assets/icons/settings.svg',
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
    ),
    route: '/settings',
    page: SettingPage(),
  ),
  RouterObject(
    name: 'Terms & Conditions',
    icon: SvgPicture.asset(
      'assets/icons/terms.svg',
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
    ),
    route: '/terms',
    page: TermsDetailPage(),
  ),
  RouterObject(
    name: 'Privacy',
    icon: SvgPicture.asset(
      'assets/icons/privacy.svg',
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
    ),
    route: '/privacy',
    page: PrivacyDetailPage(),
  ),
  RouterObject(
    name: 'Logout',
    icon: SvgPicture.asset(
      'assets/icons/logout.svg',
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
    ),
    route: '/logout',
    page: NotificationDetailPages(),
  ),
];
