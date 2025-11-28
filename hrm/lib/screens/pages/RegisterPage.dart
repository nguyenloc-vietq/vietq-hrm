import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vietq_hrm/services/navigation_services.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/CustomAppBar.widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<dynamic> leaveTypes = [
    {"title": "Annual \nLeave", "balance": "12", "color": "0xFF266CCB"},
    {"title": "Leave \nApproved", "balance": "12", "color": "0xFF94CB2C"},
    {"title": "Leave \nPending", "balance": "12", "color": "0xFF2CB2A7"},
    {"title": "Leave \nRejected", "balance": "12", "color": "0xFFFC6861"},
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomAppBar(
        title: "Register Leaves",
        actions: [
          AppBarAction(
            icon: "assets/icons/add-square.svg",
            action: () {
              print("hello");
              context.push("/register/register-form", extra: "Register Form");
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).appBarTheme.backgroundColor
          : Colors.white,
      body: RefreshIndicator(
        onRefresh: () async{

        },
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // Phần 4 ô tổng quan + TabBar sẽ cuộn lên cùng nội dung
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // 1. 4 ô tổng quan
                  Container(
                    height: 310.h,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.3,
                          ),
                      itemCount: leaveTypes.length,
                      itemBuilder: (context, index) {
                        final item = leaveTypes[index];
                        final color = Color(int.parse(item['color']));
                        return Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            border: Border.all(color: color),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['title'],
                                style: textTheme.titleLarge?.copyWith(
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                item['balance'],
                                style: textTheme.headlineLarge?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // 2. TabBar (cũng cuộn theo)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey.withOpacity(0.2)
                          : const Color(0xFFF4F5F9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: isDarkMode
                          ? Colors.white70
                          : Colors.black87,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: "Personal"),
                        Tab(text: "Professional"),
                        Tab(text: "Team Leave"),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
          // Nội dung các tab – scroll chung với phần trên
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Personal
                // Thay toàn bộ cái Column dài loằng ngoằng kia bằng đoạn này:
                Column(
                  children: [
                    _buildLeaveCard(
                      textTheme,
                      isDarkMode,
                      Theme.of(context).appBarTheme,
                    ),
                  ],
                ),

                // // Tab 2: Professional
                Column(
                  children: [
                    _buildLeaveCard(
                      textTheme,
                      isDarkMode,
                      Theme.of(context).appBarTheme,
                    ),
                  ],
                ),
                // // Tab 3: Documents
                Column(
                  children: [
                    _teamLeaveCard(
                              textTheme,
                              isDarkMode,
                              Theme.of(context).appBarTheme,
                            ),_teamLeaveCard(
                              textTheme,
                              isDarkMode,
                              Theme.of(context).appBarTheme,
                            ),_teamLeaveCard(
                              textTheme,
                              isDarkMode,
                              Theme.of(context).appBarTheme,
                            ),_teamLeaveCard(
                              textTheme,
                              isDarkMode,
                              Theme.of(context).appBarTheme,
                            ),_teamLeaveCard(
                              textTheme,
                              isDarkMode,
                              Theme.of(context).appBarTheme,
                            ),_teamLeaveCard(
                              textTheme,
                              isDarkMode,
                              Theme.of(context).appBarTheme,
                            ),_teamLeaveCard(
                              textTheme,
                              isDarkMode,
                              Theme.of(context).appBarTheme,
                            ),_teamLeaveCard(
                              textTheme,
                              isDarkMode,
                              Theme.of(context).appBarTheme,
                            ),_teamLeaveCard(
                              textTheme,
                              isDarkMode,
                              Theme.of(context).appBarTheme,
                            ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildLeaveCard(TextTheme textTheme, bool isDarkMode, appBarTheme) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 10.h),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDarkMode ? appBarTheme.foregroundColor : Colors.white,
      borderRadius: BorderRadius.circular(20).r,
      border: Border.all(color: Colors.grey.withAlpha(30)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 5),
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      spacing: 10,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text("Date", style: textTheme.bodyMedium),
                Text(
                  "10/10/2025 - 12/10/2025",
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineSmall,
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xFF94CB2C).withAlpha(50),
                borderRadius: BorderRadius.circular(12).r,
              ),
              child: Center(
                child: Text(
                  "Approved",
                  style: textTheme.bodyMedium?.copyWith(
                    color: Color(0xFF94CB2C),
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey.withAlpha(50), thickness: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text("Apply Days", style: textTheme.bodyMedium),
                Text(
                  "2 Days",
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineSmall,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text("Leave Balance", style: textTheme.bodyMedium),
                Text(
                  "19",
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineSmall,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text("Approved By", style: textTheme.bodyMedium),
                Text(
                  "Duy Huu",
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineSmall,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _teamLeaveCard(TextTheme textTheme, bool isDarkMode, appBarTheme) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 10.h),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDarkMode ? appBarTheme.foregroundColor : Colors.white,
      borderRadius: BorderRadius.circular(20).r,
      border: Border.all(color: Colors.grey.withAlpha(30)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 5),
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      spacing: 10,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              child: Image.network("https://avatar.iran.liara.run/public/girl"),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text("Name", style: textTheme.bodyMedium),
                Text(
                  "10/10/2025 - 12/10/2025",
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineSmall,
                ),
              ],
            ),
          ],
        ),
        Divider(color: Colors.grey.withAlpha(50), thickness: 1),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40).r,
              // width: ,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12).r,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  overlayColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {},
                child: Row(
                  spacing: 5.h,
                  children: [
                    Icon(Icons.close, color: Colors.white),
                    Text(
                      "Reject",
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40).r,
              decoration: BoxDecoration(
                color: Color(0xFF2CB2A7),
                borderRadius: BorderRadius.circular(12).r,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  overlayColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {},
                child: Row(
                  spacing: 5.h,
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    Text(
                      "Approve",
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
