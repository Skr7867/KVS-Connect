import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:safeemilocker/Retailer/add_customer.dart';

import '../api/Retailer_Api/customer_all_data/Customer_all_get_model.dart';
import '../api/Retailer_Api/customer_all_data/customer_all_get_api.dart';
import '../api/Retailer_Api/search_api.dart';
import '../text_style/app_text_styles.dart';
import '../text_style/colors.dart';
import 'Shop/round_button.dart';
import 'emi_details.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen>
    with TickerProviderStateMixin {
  TextEditingController customerController = TextEditingController();

  GetAllCustomers? customerData;
  List<Customer> filteredCustomers = [];

  int currentPage = 1;
  int totalPages = 1;
  int itemsPerPage = 6; // Show 6 items per page for better pagination
  bool isLoading = false;
  bool isFirstLoading = true;

  final ScrollController scrollController = ScrollController();
  bool showSearchWidgets = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    getData(page: 1);
  }

  /// 🔹 DEFAULT CUSTOMER LIST
  Future<void> getData({int page = 1}) async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final resp = await CustomerDataApi().getAllCustomers(
        page: page,
        limit: itemsPerPage,
      );

      if (!mounted) return; // 🔥 important

      setState(() {
        customerData = resp;
        currentPage = page;
        totalPages = resp.data?.totalPages ?? 1;
        isLoading = false;
        isFirstLoading = false;
      });

      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        isFirstLoading = false;
      });
    }
  }

  /// 🔹 SEARCH API
  Future<void> fetchCustomers() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    try {
      final value = await SearchApi().get(
        page: 1,
        limit: itemsPerPage,
        search: customerController.text.trim(),
        accountStatus: "ACTIVE",
        emiStatus: "ACTIVE",
      );

      if (!mounted) return; // 🔥 critical

      final List customersJson = value["data"]["customers"] ?? [];

      setState(() {
        showSearchWidgets = true;
        filteredCustomers = customersJson
            .map((e) => Customer.fromJson(e))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);
    }
  }

  Future<void> scanImei(TextEditingController controller) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text("Scan IMEI"),
            backgroundColor: AppColors.blueColor,
            foregroundColor: Colors.white,
          ),
          body: MobileScanner(
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                if (code != null) {
                  controller.text = code;
                  Navigator.pop(context);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            _buildSliverHeader(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStatsCards(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildSectionHeader(),
                  const SizedBox(height: 12),
                ]),
              ),
            ),
            _buildCustomerList(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(child: _buildPagination()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.blueColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.blueColor,
                AppColors.blueColor.withOpacity(0.8),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Customers",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Manage customers & mandates",
                        style: AppTextStyles.body14w400white,
                      ),
                    ],
                  ),
                ),

                RoundButton(
                  width: 120,
                  height: 40,
                  title: 'Add Customers ',
                  fontSize: 12,
                  buttonColor: AppColors.buttonColor,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddCustomerScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    final summary = customerData?.data?.summary;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: "Total Customers",
            count: "${summary?.totalCustomers ?? 0}",
            icon: Icons.people,
            color: AppColors.secondaryOrange,
            gradientColors: [const Color(0xFFFF8A5C), const Color(0xFFFF6B3D)],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: "Active EMI",
            count: "${summary?.activeOnEmi ?? 0}",
            icon: Icons.flash_on,
            color: Colors.green,
            gradientColors: [const Color(0xFF4CAF50), const Color(0xFF45A049)],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: "Completed",
            count: "${summary?.completed ?? 0}",
            icon: Icons.check_circle,
            color: Colors.teal,
            gradientColors: [const Color(0xFF26A69A), const Color(0xFF00897B)],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required List<Color> gradientColors,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: customerController,
        decoration: InputDecoration(
          hintText: "Search by name, phone or customer ID...",
          prefixIcon: Icon(Icons.search, color: AppColors.blueColor),
          suffixIcon: customerController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    customerController.clear();
                    setState(() {
                      showSearchWidgets = false;
                      filteredCustomers.clear();
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.blueColor, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.trim().isEmpty) {
            setState(() {
              showSearchWidgets = false;
              filteredCustomers.clear();
            });
          } else {
            fetchCustomers();
          }
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          showSearchWidgets ? "Search Results" : "Customer List",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        if (!showSearchWidgets)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.blueColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Page $currentPage of $totalPages",
              style: TextStyle(
                color: AppColors.blueColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCustomerList() {
    if (isLoading && isFirstLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primaryOrange),
          ),
        ),
      );
    }

    List<Customer> displayList = showSearchWidgets
        ? filteredCustomers
        : (customerData?.data?.customers ?? []);

    if (displayList.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 80,
                color: Colors.grey.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                showSearchWidgets
                    ? "No customers found"
                    : "No customers available",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == displayList.length) {
            return null;
          }

          final user = displayList[index];
          return _buildCustomerCard(user);
        }, childCount: displayList.length),
      ),
    );
  }

  Widget _buildCustomerCard(Customer user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EmiDetailsPage(custmerId: user),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildCustomerAvatar(user),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.fullName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          _buildStatusChip(user),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.mobile,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.devices,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              user.phoneDetails.displayName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.badge, size: 14, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          // FIXED: Added null check and proper length handling
                          Text(
                            _formatCustomerId(user.customerId),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.blueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.blueColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to safely format customer ID
  String _formatCustomerId(String? customerId) {
    if (customerId == null || customerId.isEmpty) {
      return "ID: N/A";
    }

    if (customerId.length >= 8) {
      return "ID: ${customerId.substring(0, 8)}...";
    } else {
      return "ID: $customerId";
    }
  }

  Widget _buildCustomerAvatar(Customer user) {
    final status = getCustomerStatus(user.user?.accountStatus);
    Color avatarColor;

    switch (status) {
      case CustomerStatus.completed:
        avatarColor = Colors.grey;
        break;
      case CustomerStatus.overdue:
        avatarColor = Colors.red;
        break;
      default:
        avatarColor = Colors.green;
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [avatarColor, avatarColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: avatarColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : "?",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(Customer user) {
    final status = getCustomerStatus(user.user?.accountStatus);

    Color color;
    String label;
    IconData icon;

    switch (status) {
      case CustomerStatus.completed:
        color = Colors.grey;
        label = "Completed";
        icon = Icons.check_circle;
        break;
      case CustomerStatus.overdue:
        color = Colors.red;
        label = "Overdue";
        icon = Icons.warning;
        break;
      default:
        color = Colors.green;
        label = "Active";
        icon = Icons.flash_on;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    if (totalPages <= 1 || showSearchWidgets) return const SizedBox();

    const int visiblePages = 5;

    int startPage = currentPage - (visiblePages ~/ 2);
    int endPage = currentPage + (visiblePages ~/ 2);

    if (startPage < 1) {
      startPage = 1;
      endPage = visiblePages;
    }

    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = totalPages - visiblePages + 1;
      if (startPage < 1) startPage = 1;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// PREVIOUS
          if (currentPage > 1)
            _buildPageButton(
              icon: Icons.chevron_left,
              onTap: () => getData(page: currentPage - 1),
            ),

          const SizedBox(width: 4),

          /// PAGE NUMBERS WINDOW
          for (int page = startPage; page <= endPage; page++)
            _buildPageNumber(page),

          const SizedBox(width: 4),

          /// NEXT
          if (currentPage < totalPages)
            _buildPageButton(
              icon: Icons.chevron_right,
              onTap: () => getData(page: currentPage + 1),
            ),
        ],
      ),
    );
  }

  Widget _buildPageNumber(int page) {
    final isSelected = page == currentPage;

    return GestureDetector(
      onTap: () => getData(page: page),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryOrange,
                    AppColors.primaryOrange.withOpacity(0.8),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            page.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.blueColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.blueColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          color: onTap != null ? AppColors.blueColor : Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  CustomerStatus getCustomerStatus(String? status) {
    switch (status?.toLowerCase()) {
      case "completed":
        return CustomerStatus.completed;
      case "overdue":
        return CustomerStatus.overdue;
      default:
        return CustomerStatus.active;
    }
  }

  @override
  void dispose() {
    customerController.dispose();
    scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

enum CustomerStatus { completed, active, overdue }
