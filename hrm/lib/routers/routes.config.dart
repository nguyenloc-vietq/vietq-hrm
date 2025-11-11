import 'dart:io';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';
import 'package:vietq_hrm/screens/layout/DetailsLayout.dart';
import 'package:vietq_hrm/widgets/BottomNavigation/bottomNavigation.widget.dart';
import 'router.config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// void setParentRecursive(RouterObject parent) {
//   for (final child in parent.children) {
//     child.parent = parent;
//     setParentRecursive(child);
//   }
// }

//config routers
GoRoute toGoRoute(RouterObject r) {
  return GoRoute(
    path: r.route,
    name: r.name,
    pageBuilder: (context, state) {
      // if is bottom navigation no Transition Animation
      if (ListBottomNavigatonRouter.any(
        (element) => element.route == r.route,
      )) {
        return NoTransitionPage(key: state.pageKey, child: r.page);
      }
      // Nếu là iOS → dùng CupertinoPage (có gesture vuốt trái để back)
      if (Platform.isIOS) {
        print("#>>>>>>>>>>>>>>>>>>>: this ios platform ");
        return CupertinoPage(key: state.pageKey, child: r.page);
      } else {
        print("#>>>>>>>>>>>>>>>>>>>: this android platform ");
        return CustomTransitionPage(
          key: state.pageKey,
          child: r.page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0), // slide từ phải qua trái
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      }
    },
    // Đệ quy children
    routes: r.children.map(toGoRoute).toList(),
  );
}

// def and call routers
final GoRouter appRouter = GoRouter(
  routes: [
    // ShellRoute cho phần chính (MainScaffold)
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) {
        return BottomNavigationCustom(shell: child);
      },
      branches: ListBottomNavigatonRouter.map((routerObj) {
        return StatefulShellBranch(routes: [toGoRoute(routerObj)]);
      }).toList(),
    ),

    // shellroute exits childrend
    ShellRoute(
      pageBuilder: (context, state, child) {
        final title = (state.extra is String) ? (state.extra as String) : ' ';
        if (Platform.isIOS) {
          return CupertinoPage(
            key: state.pageKey,
            child: DetailsLayout(title: title, child: child),
          );
        }
        return CustomTransitionPage(
          key: state.pageKey, // Đảm bảo key duy nhất
          child: DetailsLayout(title: title, child: child),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1, 0), // Trượt từ phải sang
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            );
          },
        );
      },
      routes: [
        ...ListDetailProfileRouter.map(toGoRoute),
        ...ListDetailsRouter.map(toGoRoute),
      ],
    ),

    // Các route công khai
    ...ListPublicRouter.map(toGoRoute),
  ],
  // redirect check is login
  redirect: (context, state) async {
    final loggedIn = SharedPreferencesConfig.users;
    print(loggedIn);
    final loggingIn = state.uri.toString() == '/login';
    if (loggedIn == null && !loggingIn &&
        ListPublicRouter.every((e) => e.route != state.uri.toString())) {
      return loggingIn ? null : '/login';
    }

    if (loggedIn != null && loggingIn) {
      return '/';
    }

    return null;
  },
);
