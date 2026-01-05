import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vietq_hrm/blocs/register/register_bloc.dart';
import 'package:vietq_hrm/configs/apiConfig/permission.api.dart';
import 'package:vietq_hrm/configs/apiConfig/registration.api.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/CustomAppBar.widget.dart';
import 'package:vietq_hrm/widgets/components/CardLeave.widget.dart';
import 'package:vietq_hrm/widgets/components/RegistCardLeave.widget.dart';
import 'package:vietq_hrm/widgets/components/TeamLeaveCard.widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(RegistrationApi(), PremissionApi())
        ..add(RegisterInitialFetch()),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize with a default length. It will be rebuilt by BlocListener.
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      context.read<RegisterBloc>().add(RegisterTabChanged(_tabController!.index));
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _rebuildTabController(int length) {
    _tabController?.removeListener(_handleTabSelection);
    // Keep the old index to set it in the new controller
    final oldIndex = context.read<RegisterBloc>().state.tabIndex;
    _tabController?.dispose();
    setState(() {
      _tabController = TabController(
          length: length,
          vsync: this,
          initialIndex: (oldIndex < length) ? oldIndex : 0);
      _tabController!.addListener(_handleTabSelection);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        final requiredTabs = state.isAdmin ? 4 : 3;
        if (_tabController?.length != requiredTabs) {
          _rebuildTabController(requiredTabs);
        }

        if (state.status == RegisterStatus.actionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Error: ${state.errorMessage}")),
            );
        }
        if (state.status == RegisterStatus.actionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Action successful!")),
            );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Register Leaves",
          actions: [
            AppBarAction(
              icon: "assets/icons/add-square.svg",
              action: () {
                context.push("/register/register-form").then((_) {
                  // After returning from the form, refresh the list to show any new entries.
                  context.read<RegisterBloc>().add(RegisterRefreshed());
                });
              },
            ),
          ],
        ),
        backgroundColor: isDarkMode
            ? Theme.of(context).appBarTheme.backgroundColor
            : Colors.white,
        body: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<RegisterBloc>().add(RegisterRefreshed());
              },
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: RegistCardLeaveWidget(summary: state.summary),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        Container(
                          color: isDarkMode
                              ? Theme.of(context).appBarTheme.backgroundColor
                              : Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          child: Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white10
                                  : const Color(0xFFF4F5F9),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.tab,
                              isScrollable: false,
                              indicator: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              dividerColor: Colors.transparent,
                              labelColor: Colors.white,
                              unselectedLabelColor: isDarkMode
                                  ? Colors.white70
                                  : Colors.black,
                              tabs: [
                                const Tab(text: "All"),
                                const Tab(text: "Approved"),
                                const Tab(text: "Rejected"),
                                if (state.isAdmin) const Tab(text: "Team"),
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
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(state.isAdmin ? 4 : 3, (index) {
                     return _buildListTab(context, state,
                        isTeamLeave: state.isAdmin && index == 3);
                  })
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListTab(BuildContext context, RegisterState state,
      {required bool isTeamLeave}) {
    final isLoading = state.status == RegisterStatus.loading ||
        state.status == RegisterStatus.actionInProgress;

    if (isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == RegisterStatus.failure && state.items.isEmpty) {
      return Center(child: Text("Error: ${state.errorMessage}"));
    }
    if (state.items.isEmpty) {
      return const Center(child: Text("No records found"));
    }

    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: state.items.length,
          itemBuilder: (ctx, i) {
            final item = state.items[i];
            return isTeamLeave
                ? TeamLeaveWidget(
                    data: item,
                    onApprove: (code) =>
                        context.read<RegisterBloc>().add(RegisterApproved(code)),
                    onReject: (code) =>
                        context.read<RegisterBloc>().add(RegisterRejected(code)),
                  )
                : CardLeaveWidget(data: item);
          },
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.1),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget _tabBar;
  _SliverAppBarDelegate(this._tabBar);
  @override
  double get minExtent => 64.h;
  @override
  double get maxExtent => 64.h;
  @override
  Widget build(context, offset, overlaps) => _tabBar;
  @override
  bool shouldRebuild(oldDelegate) => true;
}
