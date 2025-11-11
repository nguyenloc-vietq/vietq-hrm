import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  int num = 0;
  bool isCheckIn = false;

  @override
  void initState() {
    super.initState();
    NotificationService().requestNotificationPermission();
    NotificationService().getToken();
    NotificationService().firebaseInit(context);
    NotificationService().setupInteractions(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return CustomLoadingOverlay(
      isLoading: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: HomePageAppBar(
            avatar:
                "${dotenv.env['IMAGE_ENDPOINT']}avatar/avatar-1762761355725-290262777.png",
            name: "Ho Nguyen Loc",
            position: "Software Engineer",
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SwipeToCheckIn(
            background: isCheckIn ? Colors.red : Color(0xFFF6C951),
            title: isCheckIn ? "Swipe to Check Out" : "Swipe to Check In",
            onSwipe: () async {
              setState(() {
                isCheckIn = !isCheckIn;
              });
              CherryToast.success(
                description: Text(
                  isCheckIn
                      ? "Check out successfully"
                      : "Check in successfully",
                  style: TextStyle(color: Colors.black),
                ),
                animationType: AnimationType.fromTop,
                animationDuration: Duration(milliseconds: 200),
                autoDismiss: true,
              ).show(context);
            },
          ),
        ),
        body: Column(
          spacing: 20,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: CalendarSlideWidget(),
              ),
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
