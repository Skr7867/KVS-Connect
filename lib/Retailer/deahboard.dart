import 'package:flutter/material.dart';
import 'package:safeemilocker/Retailer/notifications_screen.dart';
import 'package:safeemilocker/Retailer/pending_emi.dart';
import 'package:safeemilocker/Retailer/support_screen.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';

import '../api/Retailer_Api/dashboard/dashboard_retailer_api.dart';
import '../api/Retailer_Api/dashboard/dashboard_retailer_model.dart';
import '../widgets/popup.dart';
import 'add_customer.dart';
import 'collect_emi.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();

  static Widget _orangeStatCard(String icon, String title, String value) {
    return Expanded(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF255FA2), Color(0xFF102A43)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      title,
                      style: AppTextStyles.text12w500White.copyWith(
                        fontSize: 11,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: AppTextStyles.heading24w700white.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  RetailerDashboardModel? dashboardRetailerModel;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final value = await DashboardRetailerApi().getAllDashboard();

      if (!mounted) return; // ✅ VERY IMPORTANT

      setState(() {
        dashboardRetailerModel = value;
      });
    } catch (error) {
      if (!mounted) return; // ✅ prevent crash

      showTost(error.toString());
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar Sliver
          SliverAppBar(
            expandedHeight: 90,
            pinned: true,
            floating: true,
            snap: true,
            backgroundColor: const Color(0xff102A43),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.only(
                  left: isTablet ? 24 : 16,
                  right: isTablet ? 24 : 16,
                  top: padding.top + 16,
                  bottom: 16,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xff102A43),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 26,
                        backgroundImage: AssetImage(
                          'assets/image/KVSAppLogo.png',
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "KVS Connect",
                            style: AppTextStyles.heading18whiteBold.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Retailer Dashboard",
                            style: AppTextStyles.text12w400White.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content Sliver
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 16,
              vertical: 20,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Greeting Card (Now Scrollable)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF255FA2), Color(0xFF102A43)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF255FA2).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LEFT TEXT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getGreeting(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dashboardRetailerModel?.data?.retailerName ??
                                  'Retailer',
                              style: AppTextStyles.heading20w700white.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Let's grow your business today",
                              style: AppTextStyles.body14w400white.copyWith(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // RIGHT AVATAR
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// SALES CARDS
                Row(
                  children: [
                    DashboardScreen._orangeStatCard(
                      "₹",
                      "Today's Sales",
                      "₹${dashboardRetailerModel?.data?.dailySalesTotal ?? "0"}",
                    ),
                    const SizedBox(width: 16),
                    DashboardScreen._orangeStatCard(
                      "📱",
                      "Today's Activation",
                      "${dashboardRetailerModel?.data?.keysActivatedToday ?? "0"}",
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                /// QUICK ACTIONS
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF255FA2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Quick Actions",
                      style: AppTextStyles.heading16w700blackColor.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Quick Actions Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = isTablet ? 4 : 3;
                    double spacing = isTablet ? 16 : 12;

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: 0.81,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddCustomerScreen(),
                              ),
                            );
                          },
                          child: const _QuickAction(
                            icon: Icons.person_add_rounded,
                            label: "Add Customer",
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddCustomerScreen(),
                              ),
                            );
                          },
                          child: const _QuickAction(
                            icon: Icons.phone_android_rounded,
                            label: "Sell Phone",
                            color: Color(0xFF2196F3),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CollectedEmiScreen(),
                              ),
                            );
                          },
                          child: const _QuickAction(
                            icon: Icons.currency_rupee_rounded,
                            label: "Collected EMI",
                            color: Color(0xFFFF9800),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PendingEmiScreen(),
                              ),
                            );
                          },
                          child: const _QuickAction(
                            icon: Icons.access_time_rounded,
                            label: "Pending EMI",
                            color: Color(0xFFF44336),
                          ),
                        ),
                        const _QuickAction(
                          icon: Icons.bar_chart_rounded,
                          label: "Reports",
                          color: Color(0xFF9C27B0),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SupportScreen(),
                              ),
                            );
                          },
                          child: const _QuickAction(
                            icon: Icons.support_agent_rounded,
                            label: "Support",
                            color: Color(0xFF00BCD4),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),

                /// BUSINESS OVERVIEW
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF255FA2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Business Overview",
                      style: AppTextStyles.heading16w700blackColor.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Business Overview Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = isTablet ? 3 : 2;
                    double spacing = isTablet ? 16 : 12;

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: isTablet ? 1.3 : 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _OverviewCard(
                          Icons.groups_rounded,
                          "Team Members",
                          "${dashboardRetailerModel?.data?.totalTeamMembers ?? "0"}",
                          const Color(0xFF2196F3),
                        ),
                        _OverviewCard(
                          Icons.people_rounded,
                          "Total Customer",
                          "${dashboardRetailerModel?.data?.totalCustomers ?? "0"}",
                          const Color(0xFF4CAF50),
                        ),
                        _OverviewCard(
                          Icons.phone_android_rounded,
                          "EMI Phone Sold",
                          "${dashboardRetailerModel?.data?.totalPhonesSold ?? "0"}",
                          const Color(0xFFFF9800),
                        ),
                        _OverviewCard(
                          Icons.check_circle_rounded,
                          "EMI Completed",
                          "${dashboardRetailerModel?.data?.completedEmiCount ?? "0"}",
                          const Color(0xFF4CAF50),
                        ),
                        _OverviewCard(
                          Icons.sync_rounded,
                          "Active on EMI",
                          "${dashboardRetailerModel?.data?.activeCustomers ?? "0"}",
                          const Color(0xFF00BCD4),
                        ),
                        _OverviewCard(
                          Icons.error_rounded,
                          "EMI Bounced",
                          "${dashboardRetailerModel?.data?.bouncedEmiCount ?? "0"}",
                          const Color(0xFFF44336),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning ☀️';
    } else if (hour < 17) {
      return 'Good Afternoon 🌤️';
    } else {
      return 'Good Evening 🌙';
    }
  }
}

/// QUICK ACTION TILE
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.text12w500color374151.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// OVERVIEW CARD
class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _OverviewCard(this.icon, this.title, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.caption14w500textSecondary.copyWith(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: AppTextStyles.heading20w700blackColor.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
