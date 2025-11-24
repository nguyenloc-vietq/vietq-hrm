import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietq_hrm/blocs/blocManager/bloc_manager.dart';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';
import 'package:vietq_hrm/screens/layout/DetailsLayout.dart';
import 'package:vietq_hrm/services/navigation_services.dart';
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
GoRouter createRouter() {
  return GoRouter(
  navigatorKey: NavigationService.navigatorKey,
    routes: [
      // ShellRoute cho phần chính (MainScaffold)
      ShellRoute(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: BlocManager.buildProviders(),
            child: child,
          );
          // return child;
        },
        routes: [

          // MAIN SHELL WITH TABS
          StatefulShellRoute.indexedStack(
            builder: (context, state, child) {
              return BottomNavigationCustom(shell: child);
            },
            branches: ListBottomNavigatonRouter
                .map((routerObj) => StatefulShellBranch(routes: [toGoRoute(routerObj)]))
                .toList(),
          ),

          // DETAIL ROUTES (NOW HAVE BLOC!)
          ShellRoute(
            pageBuilder: (context, state, child) {
              final title = state.extra is String ? state.extra as String : "";
              if (Platform.isIOS) {
                return CupertinoPage(
                  child: DetailsLayout(title: title, child: child),
                );
              }
              return CustomTransitionPage(
                child: DetailsLayout(title: title, child: child),
                transitionsBuilder: (_, animation, __, child) =>
                    SlideTransition(
                      position: Tween(begin: Offset(1,0), end: Offset.zero)
                          .animate(animation),
                      child: child,
                    ),
              );
            },
            routes: [
              ...ListDetailProfileRouter.map(toGoRoute),
              ...ListDetailsRouter.map(toGoRoute),
            ],
          ),
        ],
      ),
      // Các route công khai
      ...ListPublicRouter.map(toGoRoute),
    ],
    // redirect giờ đã có Bloc rồi!
    redirect: (context, state) async {
      final user = SharedPreferencesConfig.users;
      final isLoggingIn = state.uri.toString() == '/login';
      // final userBloc = context.read<UserBloc>();
      // if (userBloc.state.isLoggedIn == false && !isLoggingIn) ...
      if (user == null &&
          !isLoggingIn &&
          ListPublicRouter.every((e) => e.route != state.uri.toString())) {
        return '/login';
      }
      if (user != null && isLoggingIn) {
        return '/';
      }
      return null;
    },
  );
}
