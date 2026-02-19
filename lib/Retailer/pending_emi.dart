import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:safeemilocker/api/Retailer_Api/emi_pending/emi_pending_api.dart';
import 'package:safeemilocker/api/Retailer_Api/emi_pending/pending_emi_model.dart';

import '../text_style/app_text_styles.dart';
import '../text_style/colors.dart';

import 'package:flutter/material.dart';

import '../widgets/custom_loader.dart';
import '../widgets/popup.dart';

class PendingEmiScreen extends StatefulWidget {
  const PendingEmiScreen({super.key});

  @override
  State<PendingEmiScreen> createState() => _PendingEmiScreenState();
}

class _PendingEmiScreenState extends State<PendingEmiScreen> {


    EmiPendingModel? emiPendingModel;
  @override
  void initState() {
    getData();
  }



    Future<void> getData() async {
        appLoader.show(context);
        final rsp = EmiPendingApi.getCompleted(  page: 1,
          limit: 10,
          search: "",
        );
        rsp.then((value) {
          log(value.toString());

          try {
            setState(() {
              emiPendingModel = value;
              print("Data show${emiPendingModel.toString()}");
              // print("data show opposite gender${oppositegenderMataches}");
            });
            appLoader.hide();
          } catch (e) {
            setState(() {
              // loadingData = false;
            });
          }
        }).onError((error, stackTrace) {
          showTost(error);
          print(error);
          appLoader.hide();
        }).whenComplete(() {
          appLoader.hide();
        });
      }
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        title: Text(
          'Pending EMI',
          style: AppTextStyles.heading18w700white,
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildTabs(w),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: emiPendingModel?.data.customers.length ?? 0,
              itemBuilder: (context, index) {
                final user = emiPendingModel!.data.customers[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: EmiCard(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(double w) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: const [
          TabChip(title: 'All (24)', active: true),
          TabChip(title: 'Active (18)'),
          TabChip(title: 'Pending EMI (6)'),
          TabChip(title: 'Locked'),
        ],
      ),
    );
  }
}

/* ================= TAB CHIP ================= */

class TabChip extends StatelessWidget {
  final String title;
  final bool active;

  const TabChip({super.key, required this.title, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFF6A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF6A1A)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: active ? Colors.white : const Color(0xFFFF6A1A),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/* ================= EMI CARD ================= */



  Widget EmiCard(Customer? user) {
    String formatDateFromString(String? date) {
      if (date == null || date.isEmpty) return '';
      return date.split('T').first;
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 160,
            decoration: const BoxDecoration(
              color: Color(0xFFFF6A1A),
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
                    '${user?.fullName}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                   Text(
                    '${user?.mobile}',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ID: ${user?.user.id}',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children:  [
                      Icon(Icons.phone_android, size: 18),
                      SizedBox(width: 6),
                      Text(
                        '${user?.phoneDetails.displayName}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: Text(
                      'IMEI: ****-****-4321',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoColumn(label: 'Date', value: formatDateFromString(user?.emiSummary.nextDueDate)),
                      _InfoColumn(
                        label: 'Amount Received',
                        value: '${user?.emiSummary.totalPaid} INR',
                        valueColor: Colors.red,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


/* ================= INFO COLUMN ================= */

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoColumn({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
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
