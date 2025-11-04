import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> with SingleTickerProviderStateMixin {
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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              )),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          const Divider(height: 1, thickness: 1, color: Color(0xFFECECEC)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          // TabBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: const Color(0xFFF6C951), // xanh dương
                borderRadius: BorderRadius.circular(10),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("Full Name", "Ho Nguyen Loc"),
                      _buildInfoRow("Email Address", "nguyenloc@viet-q.com"),
                      _buildInfoRow("Phone Number", "(037) 266-3903"),
                      _buildInfoRow("Address",
                          "155b Xa An Phu Tay Binh Chan h HCMC"),
                    ],
                  ),
                ),

                // Tab 2: Professional
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("Position", "Software Engineer"),
                      _buildInfoRow("Company Email Address", "nguyenloc@viet-q.com"),
                      _buildInfoRow("Employee Type", "Full time"),
                      _buildInfoRow("Address Office",
                          "11TH Floor, Miss Ao Dai Building, 21 Nguyen Trung Ngan, Sai Gon Ward, HCMC, Viet Nam"),
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
}
