import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vietq_hrm/configs/apiConfig/permission.api.dart';
import 'package:vietq_hrm/configs/apiConfig/registration.api.dart';
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
    with TickerProviderStateMixin {
  TabController? _tabController; // Chuyển thành nullable để khởi tạo động
  late ScrollController _scrollController;
  final RegistrationApi _registrationApi = RegistrationApi();
  final PremissionApi _permissionApi = PremissionApi();

  List<dynamic> _items = [];
  Map<String, dynamic> _summary = {};
  bool _isLoading = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Khởi tạo mặc định 3 tab cho User
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    _initData();
  }

  Future<void> _initData() async {
    await _checkPermission();
    await _fetchData();
  }

  Future<void> _checkPermission() async {
    try {
      final res = await _permissionApi.getPermissions();
      final roles = res['data']?['roles'] as List<dynamic>? ?? [];

      if (roles.contains('ADMIN')) {
        if (mounted) {
          setState(() {
            _isAdmin = true;
            // Giải phóng controller cũ và tạo mới với 4 tab cho Admin
            _tabController?.removeListener(_handleTabSelection);
            _tabController?.dispose();
            _tabController = TabController(length: 4, vsync: this);
            _tabController!.addListener(_handleTabSelection);
          });
        }
      }
    } catch (e) {
      debugPrint("Permission error: $e");
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController != null && _tabController!.indexIsChanging) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (!mounted || _tabController == null) return;
    setState(() => _isLoading = true);

    try {
      if (_tabController!.index == 3 && _isAdmin) {
        // API list-approvals trả về: { "data": [...] }
        final res = await _registrationApi.listApprovals();

        setState(() {
          // Lấy trực tiếp từ res['data'] vì nó là một List
          _items = res['data']['items'] is List ? res['data']['items'] : [];
          _summary = res['data']['summary'] ?? {}; // Team leave thường không hiển thị card thống kê cá nhân
          print(_summary);
        });
      } else {
        // API listRegistrations trả về: { "data": { "items": [...], "summary": {...} } }
        String? status;
        if (_tabController!.index == 1) status = "APPROVED";
        if (_tabController!.index == 2) status = "REJECTED";

        final res = await _registrationApi.listRegistrations(status: status);
        final responseData = res['data'];

        setState(() {
          _items = responseData['items'] ?? [];
          _summary = responseData['summary'] ?? {};
        });
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  // Hàm xử lý chung cho Approve và Reject
  Future<void> _handleApprove(String code) async {
    setState(() => _isLoading = true);
    try {
      // Giả sử API của bạn có method updateStatus(id, action)
      // action có thể là 'APPROVED' hoặc 'REJECTED'
      final response = await _registrationApi.approveRegistration({
        "registrationCode": code,
        "status": "APPROVED"
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  Future<void> _handleReject(String code) async {
    setState(() => _isLoading = true);
    try {
      // Giả sử API của bạn có method updateStatus(id, action)
      // action có thể là 'APPROVED' hoặc 'REJECTED'
      final response = await _registrationApi.rejectRegistration({
        "registrationCode": code,
        "status": "REJECTED"
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Register Leaves",
        actions: [
          AppBarAction(
            icon: "assets/icons/add-square.svg",
            action: () => context.push("/register/register-form"),
          ),
        ],
      ),
      backgroundColor: isDarkMode
          ? Theme.of(context).appBarTheme.backgroundColor
          : Colors.white,
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: RegistCardLeaveWidget(summary: _summary),
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
                        isScrollable: false, // Để các Tab tự động giãn đều
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
                          if (_isAdmin) const Tab(text: "Team"),
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
            children: [
              _buildListTab(false), // All
              _buildListTab(false), // Approved
              _buildListTab(false), // Rejected
              if (_isAdmin) _buildListTab(true), // Team Leave
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTab(bool isTeamLeave) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_items.isEmpty) return const Center(child: Text("No records found"));

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _items.length,
      itemBuilder: (ctx, i) {
        final item = _items[i];
        return isTeamLeave
            ? TeamLeaveWidget(data: item, onApprove: (code) => _handleApprove(code),
                      onReject: (code) => _handleReject(code),)
            : CardLeaveWidget(data: item);
      },
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
  bool shouldRebuild(oldDelegate) => true; // Cho phép rebuild khi đổi Controller
}
