import 'package:flutter/material.dart';
import 'package:safeemilocker/api/Retailer_Api/emi_completed/emi_competed_api.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';

import '../api/Retailer_Api/emi_completed/emi_completed_model.dart';
import '../widgets/popup.dart';

class CollectedEmiScreen extends StatefulWidget {
  const CollectedEmiScreen({super.key});

  @override
  State<CollectedEmiScreen> createState() => _CollectedEmiScreenState();
}

class _CollectedEmiScreenState extends State<CollectedEmiScreen> {
  EmiCompeletedModel? emiCompeletedModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final rsp = await EmiCompetedApi.getCompleted(
        page: 1,
        limit: 20,
        status: "AVAILABLE",
      );

      if (rsp["success"] == true) {
        setState(() {
          emiCompeletedModel = EmiCompeletedModel.fromJson(rsp["data"]);
        });
      } else {
        showTost(rsp["message"].toString());
      }
    } catch (error) {
      showTost(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F9),
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        title: Text("Collected EMI", style: AppTextStyles.heading18whiteBold),
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          // _filterTabs(),
          const SizedBox(height: 8),
          Expanded(child: _emiList()),
        ],
      ),
    );
  }

  // ================= EMI LIST =================
  Widget _emiList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final customers = emiCompeletedModel?.data.customers ?? [];

    if (customers.isEmpty) {
      return const Center(
        child: Text("No EMI Found", style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];

        return _emiCard(customer: customer, collectionType: "Cash");
      },
    );
  }

  // ================= EMI CARD =================
  Widget _emiCard({required dynamic customer, required String collectionType}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 180,
            decoration: const BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name ?? "No Name",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: ${customer.id ?? "--"}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Divider(height: 24),
                  const Row(
                    children: [
                      Icon(Icons.phone_android, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Samsung Galaxy A14",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "IMEI: ****-****-4321",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _LabelValue(label: "Date", value: "12 Jan 2025"),
                      _LabelValue(
                        label: "Amount Received",
                        value: "5000 INR",
                        valueColor: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _LabelValue(label: "Collection Type", value: collectionType),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILTER TABS =================
  // Widget _filterTabs() {
  //   final tabs = [
  //     {"title": "All", "active": true},
  //     {"title": "Active", "active": true},
  //     {"title": "Pending EMI", "active": false},
  //     {"title": "Locked", "active": false},
  //   ];

  //   return Container(
  //     height: 56,
  //     color: Colors.white,
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: tabs.length,
  //       itemBuilder: (context, index) {
  //         final tab = tabs[index];
  //         return Padding(
  //           padding: const EdgeInsets.only(right: 8),
  //           child: Chip(
  //             label: Text(tab['title'] as String),
  //             backgroundColor: tab['active'] as bool
  //                 ? AppColors.primaryOrange
  //                 : Colors.grey.shade200,
  //             labelStyle: TextStyle(
  //               color: tab['active'] as bool ? Colors.white : Colors.black87,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}

// ================= LABEL VALUE =================
class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _LabelValue({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
