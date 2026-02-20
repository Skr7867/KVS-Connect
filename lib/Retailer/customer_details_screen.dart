import 'package:flutter/material.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';

import '../api/Retailer_Api/customer_all_data/Customer_all_get_model.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer? custmerId;
  const CustomerDetailScreen({super.key, required this.custmerId});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen>
    with SingleTickerProviderStateMixin {
  Customer? get customerData => widget.custmerId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String formatDateFromString(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return date.split('T').first;
    }
  }

  late final personalDetails = [
    {
      "icon": Icons.person_outline,
      "label": "Full Name",
      "value": customerData?.fullName ?? "N/A",
    },
    {
      "icon": Icons.phone_outlined,
      "label": "Mobile Number",
      "value": customerData?.mobile ?? "N/A",
    },
    {
      "icon": Icons.email_outlined,
      "label": "Email Address",
      "value": customerData?.email ?? "N/A",
    },
    {
      "icon": Icons.badge_outlined,
      "label": "Customer ID",
      "value": customerData?.id ?? "N/A",
    },
  ];

  late final references = _buildReferences();

  List<Map<String, dynamic>> _buildReferences() {
    final List<Map<String, dynamic>> refs = [];

    if (customerData?.references != null &&
        customerData!.references.isNotEmpty) {
      for (int i = 0; i < customerData!.references.length; i++) {
        final ref = customerData!.references[i];
        refs.add({
          "icon": Icons.person_add_alt_1,
          "label": "Reference ${i + 1}",
          "name": ref.name ?? "N/A",
          "mobile": ref.mobile ?? "N/A",
        });
      }
    } else {
      refs.add({
        "icon": Icons.info_outline,
        "label": "No References",
        "name": "No reference available",
        "mobile": "",
      });
    }

    return refs;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isSmallPhone = size.width < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        title: Text(
          "Customer Profile",
          style: AppTextStyles.heading16whitebold.copyWith(
            fontSize: isTablet ? 22 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              onPressed: () => _showOptionsMenu(context),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Profile Header with Gradient
              _buildProfileHeader(isTablet, isSmallPhone),

              // Stats Cards
              _buildStatsSection(isTablet),

              const SizedBox(height: 20),

              // Control Sections
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      title: "Device Controls",
                      icon: Icons.phonelink_ring_rounded,
                      count: deviceControls.length,
                    ),
                    const SizedBox(height: 12),
                    _buildControlsGrid(deviceControls, isTablet),

                    const SizedBox(height: 24),

                    _buildSectionHeader(
                      title: "App Controls",
                      icon: Icons.apps_rounded,
                      count: appControls.length,
                    ),
                    const SizedBox(height: 12),
                    _buildControlsGrid(appControls, isTablet),

                    const SizedBox(height: 24),

                    _buildSectionHeader(
                      title: "Personal Information",
                      icon: Icons.person_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildPersonalInfoCard(),

                    const SizedBox(height: 24),

                    _buildSectionHeader(
                      title: "References",
                      icon: Icons.people_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildReferencesCard(),

                    const SizedBox(height: 24),

                    _buildLockWarningCard(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isTablet, bool isSmallPhone) {
    return Container(
      margin: EdgeInsets.all(10),
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 32 : 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryOrange,
            Color(0xFFFF8C42),
            Color(0xFFFF6B6B),
          ],
        ),
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(32),
        //   bottomRight: Radius.circular(32),
        // ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Avatar
              Container(
                width: isTablet ? 90 : 70,
                height: isTablet ? 90 : 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF0F0F0)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    customerData?.fullName?.isNotEmpty == true
                        ? customerData!.fullName![0].toUpperCase()
                        : "?",
                    style: TextStyle(
                      fontSize: isTablet ? 40 : 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Name and Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerData?.fullName ?? "Customer Name",
                      style: TextStyle(
                        fontSize: isTablet ? 28 : 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "ID: ${customerData?.id ?? 'N/A'}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Active",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Call Button
              // _buildCallButton(),
            ],
          ),

          const SizedBox(height: 20),

          // Info Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildInfoChip(
                  icon: Icons.phone_android_rounded,
                  label: customerData?.phoneDetails?.displayName ?? "Device",
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  icon: Icons.payment_rounded,
                  label: customerData?.emiSummary?.status ?? "Status",
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  icon: Icons.currency_rupee_rounded,
                  label:
                      "₹${customerData?.emiSummary?.monthlyAmount ?? '0'}/mo",
                  color: Colors.white,
                  isHighlighted: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.white : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isHighlighted ? Colors.white : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isHighlighted ? AppColors.primaryOrange : color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isHighlighted ? AppColors.primaryOrange : color,
              fontSize: 12,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              value: "${customerData?.emiSummary?.paidInstallments ?? '0'}",
              label: "Paid EMIs",
              icon: Icons.check_circle_rounded,
              color: Colors.green,
              gradient: const [Color(0xFF4CAF50), Color(0xFF45A049)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              value: "₹${customerData?.emiSummary?.outstandingAmount ?? '0'}",
              label: "Outstanding",
              icon: Icons.warning_rounded,
              color: Colors.red,
              gradient: const [Color(0xFFF44336), Color(0xFFD32F2F)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              value: formatDateFromString(
                customerData?.emiSummary?.nextDueDate,
              ),
              label: "Next Due",
              icon: Icons.calendar_today_rounded,
              color: AppColors.primaryOrange,
              gradient: const [Color(0xFFFF9800), Color(0xFFF57C00)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    int? count,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryOrange, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildControlsGrid(List<ControlItem> items, bool isTablet) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 4 : 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildControlCard(items[index]);
      },
    );
  }

  Widget _buildControlCard(ControlItem item) {
    final isUnlocked = item.unlocked;
    final color = isUnlocked ? Colors.green : AppColors.primaryOrange;
    final statusColor = isUnlocked ? Colors.green : Colors.red;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (item.label.hashCode % 300)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.9 + (value * 0.1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item.icon, color: color, size: 28),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isUnlocked ? 'Unlocked' : 'Locked',
                        style: TextStyle(
                          fontSize: 9,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: personalDetails.map((detail) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    detail["icon"] as IconData,
                    size: 16,
                    color: AppColors.primaryOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Text(
                    detail["label"] as String,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    detail["value"] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReferencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: references.map((ref) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryOrange, Color(0xFFFF8C42)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    ref["icon"] as IconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref["label"] as String,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ref["name"] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      if (ref["mobile"] != null &&
                          (ref["mobile"] as String).isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: 12,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ref["mobile"] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (ref["mobile"] != null &&
                    (ref["mobile"] as String).isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.phone_in_talk_rounded,
                        color: AppColors.primaryOrange,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLockWarningCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[50]!, Colors.orange[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.lock_clock_rounded,
                  color: Colors.red[700],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Mobile Lock Control",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "If EMI is not paid on time, you can remotely lock the device to ensure payment collection.",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.password_rounded, size: 18),
                  label: const Text("Set OTP"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryOrange,
                    side: BorderSide(color: AppColors.primaryOrange),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.lock_rounded, size: 18),
                  label: const Text("Lock Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: AppColors.primaryOrange,
                  ),
                ),
                title: const Text("Edit Customer"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.history_rounded, color: Colors.blue),
                ),
                title: const Text("Payment History"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.block_rounded, color: Colors.red),
                ),
                title: const Text("Block Customer"),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

// 🔹 Data Models (unchanged)
class ControlItem {
  final IconData icon;
  final String label;
  final bool unlocked;

  ControlItem(this.icon, this.label, this.unlocked);
}

// 🔹 Data
final deviceControls = [
  ControlItem(Icons.lock_rounded, "Mobile Lock", true),
  ControlItem(Icons.call_rounded, "Outgoing", true),
  ControlItem(Icons.camera_alt_rounded, "Camera", true),
  ControlItem(Icons.bluetooth_rounded, "Bluetooth", true),
  ControlItem(Icons.restart_alt_rounded, "Hard Reset", false),
  ControlItem(Icons.code_rounded, "USB Debug", false),
  ControlItem(Icons.download_rounded, "App Install", true),
  ControlItem(Icons.delete_rounded, "App Uninstall", true),
];

final appControls = [
  ControlItem(Icons.phone_iphone_rounded, "WhatsApp", true),
  ControlItem(Icons.photo_camera_rounded, "Instagram", true),
  ControlItem(Icons.camera_rounded, "Snapchat", true),
  ControlItem(Icons.facebook_rounded, "Facebook", true),
  ControlItem(Icons.payment_rounded, "PhonePe", true),
  ControlItem(Icons.account_balance_wallet_rounded, "GPay", true),
  ControlItem(Icons.qr_code_scanner_rounded, "Paytm", true),
  ControlItem(Icons.play_circle_rounded, "YouTube", true),
];
