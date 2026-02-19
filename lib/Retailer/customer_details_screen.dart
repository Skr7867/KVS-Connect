import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';


import '../api/Retailer_Api/customer_all_data/Customer_all_get_model.dart';
import '../widgets/custom_loader.dart';
import '../widgets/popup.dart';

class CustomerDetailScreen extends StatefulWidget {

  final Customer? custmerId;
  const CustomerDetailScreen({super.key,required this.custmerId});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  Customer? get customerData => widget.custmerId;
  String formatDateFromString(String? date) {
    if (date == null || date.isEmpty) return '';
    return date.split('T').first;
  }
  late final personalDetails = [
  {"label": "Name", "value": "${customerData?.fullName}"},
{"label": "Mobile Number", "value": "${customerData?.mobile}"},
{"label": "Email", "value": "${customerData?.email}"},
/*
{"label": "Address", "value": "A-17, Model Town, Delhi"},
{"label": "Aadhaar", "value": "XXXX-XXXX-1234"},
*/
];

late final references = [
  {"label": "Reference 01 Name", "value": "${customerData?.references.first.name}"},
  {"label": "Reference 01 Number", "value": "${customerData?.references.first.mobile}"},
 /* {"label": "Reference 02 Name", "value": "Neha Verma"},
  {"label": "Reference 02 Number", "value": "+91 98XXX 345 678"},*/
];

/* @override
 void initState() {
   getData();
   super.initState();
 }*/
/*

 getData() async {
   appLoader.show(context);
   final rsp = CustomerDetailsApi().getCustomers(widget.custmerId);
   rsp.then((value) {
     log(value.toString());
     try {
       setState(() {
         customerDetailsResponse = value;
         print("Data show${customerDetailsResponse.toString()}");
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

*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        leading:BackButton(color: Colors.white,onPressed:() {Navigator.pop(context);},) ,
        backgroundColor: AppColors.primaryOrange,
        title: Text("${customerData?.fullName}",style: AppTextStyles.heading16whitebold,),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;
            final gridCount = isTablet ? 6 : 4;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topCard(),
                  const SizedBox(height: 20),
                  _sectionTitle("Device Lock Control"),
                  _gridControls(gridCount, deviceControls),
                  const SizedBox(height: 20),
                  _sectionTitle("App Lock Control"),
                  _gridControls(gridCount, appControls),
                  const SizedBox(height: 20),
                  _sectionTitle("Personal Details"),
                  _infoCard(personalDetails),
                  const SizedBox(height: 20),
                  _sectionTitle("References"),
                  _infoCard(references),
                  const SizedBox(height: 20),
                  _lockWarning(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔶 Top Summary Card
  Widget _topCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryOrange,AppColors.BtnGreenBg],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
               Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${customerData?.fullName}",
                      style: AppTextStyles.heading20whiteBold
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Customer ID:${customerData?.id}",
                      style: AppTextStyles.caption12w400rDCFCE7,
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call),
                label: const Text("Call"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip("${customerData?.phoneDetails!.displayName}"),
              _InfoChip("${customerData?.emiSummary.status}"),
              _InfoChip("₹ ${customerData?.emiSummary.monthlyAmount}\nEMI", highlight: true),
            ],
          ),
          const SizedBox(height: 16),
    Row(
    children: [
    Expanded(
    child: _StatBox(
    "${customerData?.emiSummary.paidInstallments}",
    "Paid",
    Colors.green,
    ),
    ),
    const SizedBox(width: 5),
    Expanded(
    child: _StatBox(
    "₹ ${customerData?.emiSummary.outstandingAmount}",
    "Outstanding",
    Colors.red,
    ),
    ),
    const SizedBox(width: 5),
    Expanded(
    child: _StatBox(
    formatDateFromString(customerData?.emiSummary.nextDueDate),
    "Next Due",
    AppColors.primaryOrange,
    ),
    ),
    ],

    )]));
  }

  // 🔶 Section Title
  Widget _sectionTitle(String title) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: AppTextStyles.heading16textColor374151),


    );
  }

  // 🔶 Grid Controls
  Widget _gridControls(int count, List<ControlItem> items) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.10,
      children: items.map((e) => _controlCard(e)).toList(),
    );
  }

  Widget _controlCard(ControlItem item) {
    final color = item.unlocked ? Colors.green : AppColors.primaryOrange;

    return Container(

     // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
       // borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
          height: 20,
          //  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
            ),
            child: Center(
              child: Text(
                item.unlocked ? "UNLOCKED" : "LOCKED",
                style: const TextStyle(color: Colors.white, fontSize: 8),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Icon(item.icon, size: 30, color: color),
          const SizedBox(height: 6),
          Text(item.label, style: const TextStyle(
    fontSize: 12,) , textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // 🔶 Info Cards
  Widget _infoCard(List<Map<String, String>> data) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: data.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(Icons.circle, size: 8, color: AppColors.primaryOrange),
                const SizedBox(width: 10),
                Expanded(child: Text(e["label"]!)),
                Text(e["value"]!),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 🔶 Lock Warning
  Widget _lockWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mobile Lock",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "If EMI is not paid, you can remotely lock the phone.",
            style: TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("Set 4-digit OTP"),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {},
                icon: const Icon(Icons.lock),
                label: const Text("Lock Device"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// 🔹 Small Widgets & Models

class _InfoChip extends StatelessWidget {
  final String text;
  final bool highlight;

  const _InfoChip(this.text, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primaryOrange : Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value, label;
  final Color color;

  const _StatBox(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}

class ControlItem {
  final IconData icon;
  final String label;
  final bool unlocked;

  ControlItem(this.icon, this.label, this.unlocked);
}

// 🔹 Data
final deviceControls = [
  ControlItem(Icons.lock, "Mobile Lock", true),
  ControlItem(Icons.call, "Outgoing", true),
  ControlItem(Icons.camera_alt, "Camera", true),
  ControlItem(Icons.bluetooth, "Bluetooth", true),
  ControlItem(Icons.restart_alt, "Hard Reset", false),
  ControlItem(Icons.code, "USB Debug", false),
  ControlItem(Icons.download, "App Install", true),
  ControlItem(Icons.delete, "App Uninstall", true),
];

final appControls = [
  ControlItem(Icons.phone, "WhatsApp", true),
  ControlItem(Icons.camera, "Instagram", true),
  ControlItem(Icons.snapchat, "Snapchat", true),
  ControlItem(Icons.facebook, "Facebook", true),
  ControlItem(Icons.currency_rupee, "PhonePe", true),
  ControlItem(Icons.account_balance_wallet, "GPay", true),
  ControlItem(Icons.payment, "Paytm", true),
  ControlItem(Icons.play_circle, "YouTube", true),
];

