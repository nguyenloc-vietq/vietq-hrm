import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vietq_hrm/blocs/calendars/calendar_bloc.dart';
import 'package:vietq_hrm/configs/apiConfig/schedule.api.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/CustomAppBar.widget.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/CustomDetailAppBar.widget.dart';
import 'package:vietq_hrm/widgets/components/CalendarView.widget.dart';
import 'package:vietq_hrm/widgets/components/TimeSheetList.widget.dart';
import 'package:vietq_hrm/widgets/components/WorkScheuleList.widget.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<CalendarBloc>().add(LoadCalendarEvent(isRefresh: true));
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
      appBar: CustomAppBar(title: 'Calendar'),
      body: Column(
        children: [
          // TabBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8).r,
            height: 48.h,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFFA1A1A1).withAlpha(600) : const Color(0xFFF4F5F9),
              borderRadius: BorderRadius.circular(12).r,
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              // indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // xanh dương
                borderRadius: BorderRadius.circular(10).r,
              ),
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: const [
                Tab(text: "Calendar"),
                Tab(text: "Work Schedule"),
                Tab(text: "Time Sheet"),
              ],
            ),
          ),

          // TabBarView nội dung
          Expanded(
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                if (state is CalendarLoading) {
                  return Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 3.r,
                      ),
                    ),
                  );
                }
                return TabBarView(
                  controller: _tabController,
                  children: [
                    CalendarView(),
                    // Tab 2: Professional
                    WorkScheduleList(),
                    TimeSheet(),
                    // Tab 1: Personal

                    // Tab 3: Documents
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
