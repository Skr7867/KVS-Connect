import 'package:flutter/material.dart';
import 'package:safeemilocker/Retailer/customer_details_screen.dart';
import 'package:safeemilocker/text_style/colors.dart';

import '../api/Retailer_Api/customer_all_data/Customer_all_get_model.dart';
import '../api/Retailer_Api/emi_sehdule_api/emi_details_model.dart'
    hide Customer;
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

class _EmiDetailsPageState extends State<EmiDetailsPage> {
  Customer? get customerData => widget.custmerId;

  EmiDetailsModel? emiDetailsModel;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    // appLoader.show(context);

    final customerId = widget.custmerId?.user?.id;
    final emiId = widget.custmerId?.emiSummary?.emiId;

    if (customerId == null || emiId == null) {
      // appLoader.hide();
      debugPrint("❌ customerId / emiId null");
      return;
    }

    final value = await EmiDetailsApi().getEmiDetails(
      customerId: customerId,
      emiId: emiId,
    );

    if (!mounted) return;

    setState(() {
      emiDetailsModel = value;
      print("hello $value");
    });

    appLoader.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        title: Text("EMI Details", style: AppTextStyles.heading16whitebold),
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _EmiSummary(emiDetailsModel),
                  const SizedBox(height: 20),
                  _PaymentHistory(emiDetailsModel, customerData),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          /// Bottom Button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
                child: Text(
                  "View Controls",
                  style: AppTextStyles.heading16whitebold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= EMI SUMMARY =================
class _EmiSummary extends StatelessWidget {
  final EmiDetailsModel? emiDetailsModel;

  _EmiSummary(this.emiDetailsModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart, size: 20),
              SizedBox(width: 8),
              Text(
                "EMI Summary",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _SummaryCard(
                "Total Tenure",
                "${emiDetailsModel?.data?.emi?.totalTenure}",
              ),
              _SummaryCard(
                "Monthly EMI",
                "₹ ${emiDetailsModel?.data?.emi?.monthlyAmount}",
              ),
              _SummaryCard(
                "EMIs Paid",
                "${emiDetailsModel?.data?.summary?.paidInstallments}",
                bg: Color(0xffEAF7EF),
                valueColor: Colors.green,
              ),
              _SummaryCard(
                "EMIs Pending",
                "${emiDetailsModel?.data?.summary?.pendingInstallments}",
                bg: Color(0xffFDEEEE),
                valueColor: Colors.red,
              ),
              _SummaryCard(
                "Total Paid",
                "₹ ${emiDetailsModel?.data?.summary?.paidInstallments}",
                bg: Color(0xffEAF7EF),
                valueColor: Colors.green,
              ),
              _SummaryCard(
                "Outstanding",
                "₹ ${emiDetailsModel?.data?.summary?.nextDueAmount}",
                bg: Color(0xffFDEEEE),
                valueColor: Colors.red,
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
  final Color bg;
  final Color valueColor;

  const _SummaryCard(
    this.title,
    this.value, {
    this.bg = const Color(0xffF8F8F8),
    this.valueColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
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
  _PaymentHistory(this.emiDetailsModel, this.customer);
  @override
  Widget build(BuildContext context) {
    final installments = emiDetailsModel?.data?.installments ?? [];
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Payment History",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            /*Row(
              children: [
                Text("Filter"),
                SizedBox(width: 4),
                Icon(Icons.filter_list, size: 18),
              ],
            ),*/
          ],
        ),
        const SizedBox(height: 14),

        // final installments = emiDetailsModel?.data?.installments ?? [];
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: installments.length,
          itemBuilder: (context, index) {
            final user = installments[index];

            return _EmiTile(
              emi: "EMI ${user.installmentNumber}",
              due: "${user.dueDate}",
              paidOn: user.paidDate ?? "",
              payment: (user.amount ?? 0).toString(),
              status: getEmiStatus(user.status),
              custmerId: customer,
              installmentNumber: user.installmentNumber ?? 1,
            );
          },
        ),

        /// PAID
        /* _EmiTile(
          emi: "EMI 1 of 12",
          due: "25 Jan 2025",
          paidOn: "23 Jan 2025",
          payment: "18,999",
          status: EmiStatus.paid,
        ),*/
      ],
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
      return EmiStatus.paid;
  }
}

enum EmiStatus { paid, overdue, pending }

class _EmiTile extends StatefulWidget {
  final String emi;
  final String due;
  final String? paidOn;
  final EmiStatus status;
  final String payment;
  final Customer? custmerId;
  final int installmentNumber;

  const _EmiTile({
    required this.emi,
    required this.due,
    this.paidOn,
    required this.status,
    required this.payment,
    required this.custmerId,
    required this.installmentNumber,
  });

  @override
  State<_EmiTile> createState() => _EmiTileState();
}

class _EmiTileState extends State<_EmiTile> {
  Customer? get customerData => widget.custmerId;
  String formatDateFromString(String? date) {
    if (date == null || date.isEmpty) return '';
    return date.split('T').first;
  }

  Future<void> makePayment() async {
    final customerId = widget.custmerId?.user?.id;
    final emiId = widget.custmerId?.emiSummary?.emiId;

    if (customerId == null || emiId == null) {
      print("CustomerId or EmiId null");
      return;
    }

    try {
      final response = await InstallmentPaymentApi().payInstallment(
        customerId: customerId,
        emiId: emiId,
        installmentNo: widget.installmentNumber,
      );

      print("Payment Response: $response");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Color stripColor;
    Color badgeColor;
    String badgeText;
    void _showMarkPaidDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              "Please Confirm",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Do you want to make this EMI Paid?",
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange, // 🟠 primary orange
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  makePayment();
                  Navigator.pop(context);

                  /// 👉 Yahan API call / logic lagana
                  print("EMI marked as paid");
                },
                child: const Text("Yes", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    }

    switch (widget.status) {
      case EmiStatus.paid:
        stripColor = Colors.green;
        badgeColor = const Color(0xffEAF7EF);
        badgeText = "PAID";
        break;
      case EmiStatus.overdue:
        stripColor = Colors.red;
        badgeColor = const Color(0xffFDEEEE);
        badgeText = "OVERDUE";
        break;
      default:
        stripColor = Colors.orange;
        badgeColor = const Color(0xffFFF4E5);
        badgeText = "PENDING";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 100,
            decoration: BoxDecoration(
              color: stripColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.emi,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 12,
                            color: stripColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Due: ${formatDateFromString(widget.due)}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  const Text("Amount", style: TextStyle(color: Colors.grey)),
                  Text(
                    "₹ ${widget.payment}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (widget.status == EmiStatus.paid && widget.paidOn != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Paid On\n${widget.paidOn}",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (widget.status != EmiStatus.paid)
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showMarkPaidDialog(context);
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text("Mark as Paid"),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
