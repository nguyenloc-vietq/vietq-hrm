import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:vietq_hrm/blocs/attendance/attendance_bloc.dart';
import 'package:vietq_hrm/configs/apiConfig/user.api.dart';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';
import 'package:vietq_hrm/services/push_notification/notification.service.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/HomePageAppBar.widget.dart';
import 'package:vietq_hrm/widgets/components/CalendarSlide.widget.dart';
import 'package:vietq_hrm/widgets/components/TodayAttendance.widget.dart';
import 'package:vietq_hrm/widgets/components/YourActivity.widget.dart';
import 'package:vietq_hrm/widgets/customWidgets/CustomLoadingOverlay.dart';
import 'package:vietq_hrm/widgets/customWidgets/SwipeToCheckIn.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String currentViewDay = DateTime.now().toString();
  int num = 0;
  Widget? _cachedAttendanceUI;
  bool isLoading = true;
  Map<String, dynamic>? userData;


  @override
  void initState() {
    super.initState();
    _getUserProfile();
    NotificationService().requestNotificationPermission();
    NotificationService().getToken();
    NotificationService().firebaseInit(context);
    NotificationService().setupInteractions(context);
  }
  Future<void> _getUserProfile() async {
    final userData = await UserApi().getProfile();
    await SharedPreferencesConfig.add('user-profile', userData.toString());
    print("#==========> USER PROFILE" + userData.toString());
    setState(() {
      isLoading = false;
      this.userData = userData;
    });
  }
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (isLoading) {
      return const Scaffold(
        body: Center(child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator())),
      );
    }

    final avatarUrl = userData?['avatar'] ?? '';
    final name = userData?['fullName'] ?? '';
    final position = userData?['userProfessionals'].length > 0 ? userData?['userProfessionals']?[0]['position'] : '';
    return CustomLoadingOverlay(
      isLoading: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: HomePageAppBar(
            avatar: "${dotenv.env['IMAGE_ENDPOINT']}$avatarUrl" ?? "",
            name: name,
            position: position,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocListener<AttendanceBloc, AttendanceState>(
            listener: (context, state) {
              if (state is AttendanceCheckIn) {
                CherryToast.success(
                  description: Text(
                    "Check In successfully",
                    style: TextStyle(color: Colors.black),
                  ),
                  animationType: AnimationType.fromTop,
                  animationDuration: Duration(milliseconds: 200),
                  autoDismiss: true,
                ).show(context);
              }
              if (state is AttendanceCheckOut) {
                CherryToast.success(
                  description: Text(
                    "Check Out successfully",
                    style: TextStyle(color: Colors.black),
                  ),
                  animationType: AnimationType.fromTop,
                  animationDuration: Duration(milliseconds: 200),
                  autoDismiss: true,
                ).show(context);
              }
              if (state is AttendanceCheckInError) {
                CherryToast.error(
                  description: Text(
                    state.message,
                    style: TextStyle(color: Colors.black),
                  ),
                  animationType: AnimationType.fromTop,
                  animationDuration: Duration(milliseconds: 200),
                  autoDismiss: true,
                ).show(context);
              }
              if (state is AttendanceCheckOutError) {
                CherryToast.error(
                  description: Text(
                    state.message,
                    style: TextStyle(color: Colors.black),
                  ),
                  animationType: AnimationType.fromTop,
                  animationDuration: Duration(milliseconds: 200),
                  autoDismiss: true,
                ).show(context);
              }
            },
            child: BlocBuilder<AttendanceBloc, AttendanceState>(
              buildWhen: (previous, current) {
                if (current is AttendanceLoaded) {
                  final list = current.timeSheets?.attendanceRecs ?? [];
                  if (list.isNotEmpty) {
                    final serverDay = list.first.workDay;
                    if (serverDay != null) {
                      return _sameDate(serverDay, currentViewDay);
                    }
                  }
                  return _sameDate(current.today.toString(), currentViewDay);
                }
                return true;
              },
              builder: (context, state) {
                if (state is AttendanceLoaded) {
                  _cachedAttendanceUI = _buildSwipeUI(state, context);
                  return _cachedAttendanceUI!;
                }

                if (_cachedAttendanceUI != null) {
                  return _cachedAttendanceUI!;
                }

                return Container();
              },
            ),
          ),
        ),
        body: Column(
          spacing: 20,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 100,
              child: CalendarSlideWidget(),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [TodayAttendance(), YourActivity()],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool _sameDate(String workDay, String uiDay) {
  final d1 = DateTime.parse(workDay).toLocal();
  final d2 = DateTime.parse(uiDay); // yyyy-MM-dd

  return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
}

Widget _buildSwipeUI(AttendanceLoaded state, BuildContext context) {
  final dataAtt = state.timeSheets?.attendanceRecs ?? [];
  final hasRecord = dataAtt.isNotEmpty;

  final isCheckIn = hasRecord && dataAtt.first.timeIn != null;
  final isCheckOut = hasRecord && dataAtt.first.timeOut != null;
  return SwipeToCheckIn(
    background: isCheckIn
        ? (isCheckOut ? Color(0xFFF6C951) : Colors.red)
        : Color(0xFFF6C951),
    title: isCheckIn
        ? (isCheckOut ? "Swipe to Check In" : "Swipe to Check Out")
        : "Swipe to Check In",
    onSwipe: () async {
      if (isCheckIn && !isCheckOut) {
        context.read<AttendanceBloc>().add(CheckOutEvent());
      } else if (!isCheckIn && !isCheckOut) {
        context.read<AttendanceBloc>().add(CheckInEvent());
      } else {
        //show toast error
        CherryToast.error(
          description: Text(
            "You have checked in and checked out",
            style: TextStyle(color: Colors.black),
          ),
          animationType: AnimationType.fromTop,
          animationDuration: Duration(milliseconds: 200),
          autoDismiss: true,
        ).show(context);
      }
    },
  );
}
