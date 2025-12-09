import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vietq_hrm/blocs/attendance/attendance_bloc.dart';
import 'package:vietq_hrm/blocs/calendars/calendar_bloc.dart';
import 'package:vietq_hrm/blocs/notifications/notifications_bloc.dart';
import 'package:vietq_hrm/blocs/user/user_bloc.dart';
import 'package:vietq_hrm/services/push_notification/notification.service.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/HomePageAppBar.widget.dart';
import 'package:vietq_hrm/widgets/components/CalendarSlide.widget.dart';
import 'package:vietq_hrm/widgets/components/Notification.widget.dart';
import 'package:vietq_hrm/widgets/components/SalaryInfo.widget.dart';
import 'package:vietq_hrm/widgets/components/TodayAttendance.widget.dart';
import 'package:vietq_hrm/widgets/components/TodayInfomation.widget.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUserEvent());
    NotificationService().requestNotificationPermission();
    NotificationService().getToken();
    NotificationService().subscribeToGroup("user-topic");
    NotificationService().firebaseInit(context);
    NotificationService().setupInteractions(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CustomLoadingOverlay(
      isLoading: false,
      child: Scaffold(
        backgroundColor: isDarkMode ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.r),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                print("#==========> chay vao dayyyy ${state.user}");
                final avatarUrl = state.user.avatar ?? '';
                final name = state.user.fullName ?? '';
                final position = state.user.userProfessionals != null
                    ? state.user.userProfessionals?.position
                    : '';
                return HomePageAppBar(
                  avatar: "${dotenv.env['IMAGE_ENDPOINT']}$avatarUrl" ?? "",
                  name: name,
                  position: position ?? '',
                );
              }
              if(state is UserError) {
                print("#==========> error ${state.message}");
              }
              return Skeletonizer(
                effect: PulseEffect(),
                enabled: true,
                child: HomePageAppBar(
                  avatar: "https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3407.jpg",
                  name: "name",
                  position: "position",
                ),
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0).r,
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
        body: Padding(
          padding: const EdgeInsets.only(top: 16).r,
          child: Column(
            spacing: 20.h,
            children: [
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 16).r,
              //   height: 100.h,
              //   child: CalendarSlideWidget(),
              // ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ).r,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ).r,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<UserBloc>().add(LoadUserEvent());
                        context.read<NotificationBloc>().add(FetchNotificationEvent(isRefresh: false));
                        context.read<AttendanceBloc>().add(LoadAttendanceEvent(today: DateTime.now().toString()));
                        context.read<CalendarBloc>().add(LoadCalendarEvent(isRefresh: true, today: DateTime.now().toString()));
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // children: [TodayAttendance(), YourActivity()],
                          children: [TodayInfoWidget() ,YourActivity(), SalaryInfoWidget(), NotificationHomeWidget()],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
  print("#==========> Check state check in ${isCheckIn}");
  print("#==========> Check state check in ${isCheckOut}");

  if(isCheckOut && isCheckIn){
    return Container();
  }else {
    return SwipeToCheckIn(
      background: Theme.of(context).colorScheme.primary,
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
}
