// lib/services/navigation_service.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  // Dùng GlobalKey để lấy context ở bất kỳ đâu (kể cả trong Interceptor)
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Hàm tiện ích (dùng ở mọi nơi)
  static BuildContext? get context => navigatorKey.currentContext;

  // Các hàm go, push, pop... tiện dùng
  static void go(String path) => context?.go(path);
  static void push(String path) => context?.push(path);
  static void pop() => context?.pop();
  static void goLogin() => context?.go('/login');
}