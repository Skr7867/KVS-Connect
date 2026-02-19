import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:safeemilocker/Retailer/deahboard.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';

import '../api/Retailer_Api/qr_code_api/qr_api.dart';

class MandateStatusScreen extends StatefulWidget {
  final String enterpriseId;
  final String policyId;
  final String customerId;

  const MandateStatusScreen({
    super.key,
    required this.enterpriseId,
    required this.policyId,
    required this.customerId,
  });

  @override
  State<MandateStatusScreen> createState() => _MandateStatusScreenState();
}

class _MandateStatusScreenState extends State<MandateStatusScreen> {
  bool isLoading = true;
  String? qrCode; // base64 or url
  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    _generateQr();
  }
  String? customerName;
  String? frequency;
  int? mandateAmount;
  int? numberofEmi;
  Future<void> _generateQr() async {
    try {
      final response = await EnrollmentApiService().generateQr(
        enterpriseId: widget.enterpriseId,
        policyId: widget.policyId,
        customerId: widget.customerId,
      );

      final qr = response['qrCodeUrl'];
      customerName = response['customer']['name'];
      frequency =  response['customer']['mandateFrequency'];
      numberofEmi =  response['customer']['numberOfEmi'];
      mandateAmount =  response['customer']['mandateAmount'];
      if (qr != null && qr.toString().isNotEmpty) {
        setState(() {
          qrCode = qr.toString();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMsg = "QR not available";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = "Something went wrong";
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "Mandate Status",
          style: AppTextStyles.heading18whiteBold,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final horizontalPadding = isTablet ? 32.0 : 16.0;
          final qrSize = isTablet ? 280.0 : width * 0.7;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _statusHeader(isTablet),
                const SizedBox(height: 16),
                _planInfo(),
                const SizedBox(height: 24),
                _qrCard(qrSize),
                //const SizedBox(height: 20),
               // _linkCard(),
                const SizedBox(height: 40),
                _homeButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= HEADER =================
  Widget _statusHeader(bool isTablet) {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: AppColors.colorBlue, size: 36),
        const SizedBox(height: 8),
        Text(
          "Mandate Created",
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Customer: ${customerName ?? ""}",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ================= PLAN INFO =================
  Widget _planInfo() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _chip(Icons.calendar_month, "${frequency}"),
        _chip(Icons.layers, "${numberofEmi ?? 0} EMI"),
        Chip(
          backgroundColor: Colors.green.shade100,
          label: Text(
            "₹ ${mandateAmount ?? 0}/ EMI",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
    );
  }

  // ================= QR CARD =================
  Widget _qrCard(double size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMsg.isNotEmpty
                ? Center(
              child: Text(
                errorMsg,
                style: const TextStyle(color: Colors.red),
              ),
            )
                : _buildQrImage(size),
          ),
          const SizedBox(height: 12),
         /* Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "QR expires in 09:31",
              style: TextStyle(color: Colors.blue),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildQrImage(double size) {
    if (qrCode == null || qrCode!.isEmpty) {
      return const SizedBox();
    }

    // If QR is direct URL
    if (qrCode!.startsWith("http")) {
      return Image.network(qrCode!, fit: BoxFit.contain);
    }

    try {
      String base64String = qrCode!;

      // Remove data:image/png;base64, prefix
      if (base64String.startsWith("data:image")) {
        base64String = base64String.split(",").last;
      }

      Uint8List bytes = base64Decode(base64String);

      return Image.memory(
        bytes,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    } catch (e) {
      print("QR decode error: $e");
      return const Text(
        "Invalid QR data",
        style: TextStyle(color: Colors.red),
      );
    }
  }


  // ================= LINK CARD =================
 /* Widget _linkCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.link, color: Colors.blue),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "https://emi.devoylt.com/mandate",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(onPressed: () {}, child: const Text("Copy")),
        ],
      ),
    );
  }
*/
  // ================= HOME BUTTON =================
  Widget _homeButton(context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DashboardScreen()),
          );
        },
        child: Text(
          "Back to Home",
          style: AppTextStyles.heading16whitebold,
        ),
      ),
    );
  }
}
