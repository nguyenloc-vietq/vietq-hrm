import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vietq_hrm/blocs/calendars/calendar_bloc.dart';
import 'package:vietq_hrm/routers/router.config.dart';
import 'package:vietq_hrm/widgets/BottomNavigation/GradientIcon.widget.dart';

class BottomNavigationCustom extends StatefulWidget {
  final StatefulNavigationShell shell;

  const BottomNavigationCustom({super.key, required this.shell});

  @override
  State<BottomNavigationCustom> createState() => _BottomNavigationCustomState();
}

class _BottomNavigationCustomState extends State<BottomNavigationCustom> {
  int get _currentIndex => widget.shell.currentIndex;

  void _onTap(int index) {
    widget.shell.goBranch(index, initialLocation: false);
    print("#>>>>>>>>>>>>>>>>>>>: $_currentIndex");
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ListBottomNavigatonRouter;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: Container(
        height: 100,
        // color: isDarkMode ? Colors.black : Colors.white,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedLabelStyle: const TextStyle(fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _onTap,
          unselectedItemColor: Colors.grey,
          items: tabs.map((e) {
            final isCenter = e.route == '/register-form';
            final isActive = tabs.indexOf(e) == _currentIndex;

            Widget iconWidget;

            if (isCenter) {
              iconWidget = SizedBox(
                height: 30, // 👈 Chiều cao cố định cho toàn bộ vùng
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -30,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFF6C951), Color(0xFFB18114)],
                            begin: Alignment.topCenter,
                            stops: [0.3, 1.0],
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF6C951).withOpacity(0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : Colors.white,
                            width: 5,
                          ),
                        ),
                        child: e.icon,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              iconWidget = isActive
                  ? GradientIcon(
                icon: e.icon as Widget,
                size: 24,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF6C951), Color(0xFFB18114)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              )
                  : e.icon ?? const SizedBox();
            }
            return BottomNavigationBarItem(icon: iconWidget, label: '');
          }).toList(),
        ),
      ),
    );
  }
}
