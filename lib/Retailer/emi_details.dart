import 'package:flutter/material.dart';
import 'package:safeemilocker/Retailer/customer_details_screen.dart';
import 'package:safeemilocker/text_style/colors.dart';

import '../api/Retailer_Api/customer_all_data/Customer_all_get_model.dart';
import '../api/Retailer_Api/emi_sehdule_api/emi_details_model.dart';
import '../api/Retailer_Api/emi_sehdule_api/emi_sehdule_api.dart';
import '../api/Retailer_Api/mark_as_paid/mark_as_paid_api.dart';
import '../text_style/app_text_styles.dart';
import '../widgets/custom_loader.dart';

class EmiDetailsPage extends StatefulWidget {
  final Customer? custmerId;

  const EmiDetailsPage({super.key, required this.custmerId});

  @override
  State<EmiDetailsPage> createState() => _EmiDetailsPageState();
}

class _EmiDetailsPageState extends State<EmiDetailsPage>
    with SingleTickerProviderStateMixin {
  Customer? get customerData => widget.custmerId;
  EmiDetailsModel? emiDetailsModel;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    getData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    setState(() => _isLoading = true);

    final customerId = widget.custmerId?.user?.id;
    final emiId = widget.custmerId?.emiSummary.emiId;

    if (customerId == null || emiId == null) {
      debugPrint("❌ customerId / emiId null");
      setState(() => _isLoading = false);
      return;
    }

    final value = await EmiDetailsApi().getEmiDetails(
      customerId: customerId,
      emiId: emiId,
    );

    if (!mounted) return;

    setState(() {
      emiDetailsModel = value;
      _isLoading = false;
    });

    _animationController.forward();
    appLoader.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        title: Text(
          "EMI Details",
          style: AppTextStyles.heading16whitebold.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),

        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CustomLoader(message: "Loading EMI details..."))
          : FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildCustomerInfo(),
                          const SizedBox(height: 20),
                          _EmiSummary(emiDetailsModel),
                          const SizedBox(height: 20),
                          _PaymentHistory(emiDetailsModel, customerData),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildCustomerInfo() {
    final customer = widget.custmerId?.user;
    if (customer == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryOrange.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryOrange.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: AppColors.primaryOrange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name ?? "Customer Name",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID: ${customer.id ?? 'N/A'}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              "Active",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CustomerDetailScreen(custmerId: customerData),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "View Controls",
                style: AppTextStyles.heading16whitebold.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= EMI SUMMARY =================
class _EmiSummary extends StatelessWidget {
  final EmiDetailsModel? emiDetailsModel;

  const _EmiSummary(this.emiDetailsModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.insert_chart_rounded,
                  color: AppColors.primaryOrange,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "EMI Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _SummaryCard(
                title: "Total Tenure",
                value:
                    "${emiDetailsModel?.data?.emi?.totalTenure ?? "0"} months",
                icon: Icons.calendar_today_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
              ),
              _SummaryCard(
                title: "Monthly EMI",
                value:
                    "₹ ${emiDetailsModel?.data?.emi?.monthlyAmount.toStringAsFixed(2) ?? "0"}",
                icon: Icons.currency_rupee_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF97316), Color(0xFFFF6B6B)],
                ),
              ),
              _SummaryCard(
                title: "EMIs Paid",
                value:
                    "${emiDetailsModel?.data?.summary?.paidInstallments ?? "0"}",
                icon: Icons.check_circle_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
              ),
              _SummaryCard(
                title: "EMIs Pending",
                value:
                    "${emiDetailsModel?.data?.summary?.pendingInstallments ?? "0"}",
                icon: Icons.pending_actions_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                ),
              ),
              _SummaryCard(
                title: "Total Paid",
                value:
                    "₹ ${emiDetailsModel?.data?.summary?.paidInstallments ?? "0"}",
                icon: Icons.account_balance_wallet_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                ),
              ),
              _SummaryCard(
                title: "Outstanding",
                value:
                    "₹ ${emiDetailsModel?.data?.summary?.nextDueAmount.toStringAsFixed(2) ?? "0"}",
                icon: Icons.warning_amber_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, size: 14, color: (gradient.colors.first)),
              ),
              const Spacer(),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: gradient.colors.first,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= PAYMENT HISTORY =================
class _PaymentHistory extends StatelessWidget {
  final EmiDetailsModel? emiDetailsModel;
  final Customer? customer;

  const _PaymentHistory(this.emiDetailsModel, this.customer);

  @override
  Widget build(BuildContext context) {
    final installments = emiDetailsModel?.data?.installments ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: AppColors.primaryOrange,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Payment History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (installments.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Icon(
                    Icons.history_toggle_off_rounded,
                    size: 48,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No payment history",
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: installments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = installments[index];
                return _EmiTile(
                  emi: "EMI ${user.installmentNumber}",
                  due: user.dueDate,
                  paidOn: user.paidDate ?? "",
                  payment: user.amount.toString(),
                  status: getEmiStatus(user.status),
                  custmerId: customer,
                  installmentNumber: user.installmentNumber,
                );
              },
            ),
        ],
      ),
    );
  }
}

EmiStatus getEmiStatus(String? status) {
  switch (status?.toLowerCase()) {
    case "paid":
      return EmiStatus.paid;
    case "overdue":
      return EmiStatus.overdue;
    case "pending":
      return EmiStatus.pending;
    default:
      return EmiStatus.pending;
  }
}

enum EmiStatus { paid, overdue, pending }

class _EmiTile extends StatefulWidget {
  final String emi;
  final String due;
  final String paidOn;
  final EmiStatus status;
  final String payment;
  final Customer? custmerId;
  final int installmentNumber;

  const _EmiTile({
    required this.emi,
    required this.due,
    required this.paidOn,
    required this.status,
    required this.payment,
    required this.custmerId,
    required this.installmentNumber,
  });

  @override
  State<_EmiTile> createState() => _EmiTileState();
}

class _EmiTileState extends State<_EmiTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Customer? get customerData => widget.custmerId;

  String formatDateFromString(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return '${parsedDate.day} ${_getMonth(parsedDate.month)} ${parsedDate.year}';
    } catch (e) {
      return date.split('T').first;
    }
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> makePayment() async {
    final customerId = widget.custmerId?.user?.id;
    final emiId = widget.custmerId?.emiSummary?.emiId;

    print("🔍 Debug Information:");
    print("Customer ID: $customerId");
    print("EMI ID: $emiId");
    print("Installment Number: ${widget.installmentNumber}");
    print("Amount: ${widget.payment}");

    if (customerId == null || emiId == null) {
      print("❌ Error: CustomerId or EmiId is null");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Customer or EMI information missing'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Parse amount from string to double
    double? amount;
    try {
      // Remove '₹' and commas, then parse
      String cleanAmount = widget.payment
          .replaceAll('₹', '')
          .replaceAll(',', '')
          .trim();
      amount = double.parse(cleanAmount);
    } catch (e) {
      print("❌ Error parsing amount: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid amount format'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Show payment mode selection dialog
    _showPaymentModeDialog(context, customerId, emiId, amount);
  }

  void _showPaymentModeDialog(
    BuildContext context,
    String customerId,
    String emiId,
    double amount,
  ) {
    String selectedPaymentMode = 'cash'; // Default value

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.payment_rounded,
                      color: AppColors.primaryOrange,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Payment Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Amount:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "₹ ${amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryOrange,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Select Payment Mode:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  // Payment Mode Options
                  _buildPaymentOption(
                    value: 'cash',
                    groupValue: selectedPaymentMode,
                    label: 'Cash',
                    icon: Icons.money_rounded,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMode = value!;
                      });
                    },
                  ),
                  _buildPaymentOption(
                    value: 'bank_transfer',
                    groupValue: selectedPaymentMode,
                    label: 'Bank Transfer',
                    icon: Icons.account_balance_rounded,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMode = value!;
                      });
                    },
                  ),
                  _buildPaymentOption(
                    value: 'upi',
                    groupValue: selectedPaymentMode,
                    label: 'UPI',
                    icon: Icons.qr_code_scanner_rounded,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMode = value!;
                      });
                    },
                  ),
                  _buildPaymentOption(
                    value: 'cheque',
                    groupValue: selectedPaymentMode,
                    label: 'Cheque',
                    icon: Icons.receipt_rounded,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMode = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _processPayment(
                      context,
                      customerId,
                      emiId,
                      amount,
                      selectedPaymentMode,
                    );
                  },
                  child: const Text("Confirm Payment"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String groupValue,
    required String label,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
      activeColor: AppColors.primaryOrange,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Future<void> _processPayment(
    BuildContext context,
    String customerId,
    String emiId,
    double amount,
    String paymentMode,
  ) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await InstallmentPaymentApi().payInstallment(
        customerId: customerId,
        emiId: emiId,
        installmentNo: widget.installmentNumber,
        amount: amount,
        paymentMode: paymentMode,
      );

      Navigator.pop(context); // Close loading dialog

      print("✅ Payment Response: $response");

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Payment marked as paid successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Refresh the data (you might want to call getData() from parent)
        // You can use a callback or refresh the page
        Navigator.pop(context); // Close any open dialogs
        // Optionally refresh the page
        setState(() {
          // Update local state if needed
        });
      } else {
        throw Exception(response['message'] ?? 'Payment failed');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog

      print("❌ Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () =>
                _showPaymentModeDialog(context, customerId, emiId, amount),
          ),
        ),
      );
    }
  }

  void _showMarkPaidDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.payment_rounded,
                  color: AppColors.primaryOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Confirm Payment",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Do you want to mark this EMI as paid?",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.emi,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "₹ ${widget.payment}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                makePayment();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;
    String statusText;
    IconData statusIcon;

    switch (widget.status) {
      case EmiStatus.paid:
        statusColor = const Color(0xFF10B981);
        statusBgColor = const Color(0xFFD1FAE5);
        statusText = "PAID";
        statusIcon = Icons.check_circle_rounded;
        break;
      case EmiStatus.overdue:
        statusColor = const Color(0xFFEF4444);
        statusBgColor = const Color(0xFFFEE2E2);
        statusText = "OVERDUE";
        statusIcon = Icons.warning_rounded;
        break;
      default:
        statusColor = const Color(0xFFF59E0B);
        statusBgColor = const Color(0xFFFEF3C7);
        statusText = "PENDING";
        statusIcon = Icons.pending_rounded;
    }

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(statusIcon, color: statusColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.emi,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Due: ${formatDateFromString(widget.due)}",
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey[600],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 11,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Amount",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "₹ ${double.tryParse(widget.payment)?.toStringAsFixed(2) ?? "0.00"}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    if (widget.status == EmiStatus.paid &&
                        widget.paidOn.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Paid: ${formatDateFromString(widget.paidOn)}",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (widget.status != EmiStatus.paid)
                      ElevatedButton.icon(
                        onPressed: () => _showMarkPaidDialog(context),
                        icon: const Icon(Icons.payment_rounded, size: 16),
                        label: const Text("Mark Paid"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Loader Widget
class CustomLoader extends StatelessWidget {
  final String message;

  const CustomLoader({super.key, this.message = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryOrange,
              ),
              strokeWidth: 3,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(message, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }
}
