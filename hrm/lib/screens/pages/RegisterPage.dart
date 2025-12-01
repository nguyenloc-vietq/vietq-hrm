import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/CustomAppBar.widget.dart';
import 'package:vietq_hrm/widgets/components/CardLeave.widget.dart';
import 'package:vietq_hrm/widgets/components/RegistCardLeave.widget.dart';
import 'package:vietq_hrm/widgets/components/TeamLeaveCard.widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
    }
  }


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
        onRefresh: () async {},
        child: NestedScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: RegistCardLeaveWidget(),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  Container(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).appBarTheme.backgroundColor
                        : Colors.white,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFA1A1A1).withAlpha(600)
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
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          Tab(text: "Leave"),
                          Tab(text: "Late"),
                          Tab(text: "Team Leave"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Leave
              RefreshIndicator(
                onRefresh: () async {
                  print("test");
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(20.w),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: 15,
                  itemBuilder: (ctx, i) => CardLeaveWidget(),
                ),
              ),

              // Tab 2: Late
              RefreshIndicator(
                onRefresh: () async {
                  print("test");
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(20.w),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: 15,
                  itemBuilder: (ctx, i) => CardLeaveWidget()
                ),
              ),

              // Tab 3: Team Leave
              RefreshIndicator.adaptive(
                onRefresh: () async {
                  print("test");
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(20.w),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (ctx, i) => TeamLeaveWidget()
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Widget _tabBar;

  @override
  double get minExtent => 64.h;

  @override
  double get maxExtent => 64.h;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
