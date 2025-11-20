import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vietq_hrm/blocs/user/user_bloc.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          SizedBox(height: 6.h),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
           Divider(height: 1.h, thickness: 1.r, color: Color(0xFFECECEC)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(
            child: SizedBox(
              width: 30.w,
              height: 30.h,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is UserLoaded) {
          return Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
            body: Column(
              children: [
                // TabBar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8).r,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFFA1A1A1).withAlpha(600) : const Color(0xFFF4F5F9),
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
                      Tab(text: "Personal"),
                      Tab(text: "Professional"),
                    ],
                  ),
                ),

                // TabBarView nội dung
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Personal
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24).r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Full Name", state.user.fullName ?? ''),
                            _buildInfoRow(
                              "Email Address",
                              state.user.email ?? '',
                            ),
                            _buildInfoRow("Phone Number", state.user.phone ?? ''),
                            _buildInfoRow(
                              "Address",
                              state.user.address ?? '',
                            ),
                          ],
                        ),
                      ),

                      // Tab 2: Professional
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24).r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Position", state.user.userProfessionals?.first.position ?? ''),
                            _buildInfoRow(
                              "Company Email Address",
                              state.user.email ?? '',
                            ),
                            _buildInfoRow("Employee Type", state.user.userProfessionals?.first.employeeType ?? ''),
                            _buildInfoRow(
                              "Address Office",
                              state.user.company?.address ?? 'Address is not found',
                            ),
                          ],
                        ),
                      ),
                      // Tab 3: Documents
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('User not found...!'));
      },
    );
  }
}
