import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api/Distibutor_Api/requestkeys_api/request_keys_api.dart';
import '../text_style/colors.dart';

class BuyKeyPackageScreen extends StatefulWidget {
  const BuyKeyPackageScreen({super.key});

  @override
  State<BuyKeyPackageScreen> createState() => _BuyKeyPackageScreenState();
}

class _BuyKeyPackageScreenState extends State<BuyKeyPackageScreen> {
  TextEditingController keys = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "REQUEST KEYS",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
              SizedBox(height: 200,),
            Center(
              child: Column(
                children: [
                  _input(label: "No. of Keys *",hint: "Enter number of keys",controller:keys),
                  const SizedBox(height: 16),
                  _buyButton(onTap: () async{
                    final response = await RequestKeysApi().requestKeys(
                      quantity: int.parse(keys.text.trim()),
                      requestReason: '',
                    ); if (response["success"] == true) {
                    Fluttertoast.showToast(
                      msg: response['message']?.toString() ?? "Success",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor:
                      response['success'] ? AppColors.primaryOrange : Colors.red,
                      textColor: Colors.white,
                    );


                    } else {
                      print("Error: ${response["message"]}");
                    }
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🔹 Plan Card
  Widget _input({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Buy Button
  Widget _buyButton({required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.shopping_cart, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Request Keys",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // 🔹 Custom Plan Card
  Widget _customPlan() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Custom Plan",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(Icons.key, "Custom Allocation"),
              _chip(Icons.sell, "Tailored Pricing"),
              _chip(Icons.flash_on, "Priority Onboarding"),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _actionButton(
                    "Call", Icons.call, AppColors.primaryOrange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionButton(
                    "WhatsApp", Icons.phone, Colors.green),
              ),
            ],
          )
        ],
      ),
    );
  }

  // 🔹 Action Button
  Widget _actionButton(String text, IconData icon, Color color) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // 🔹 Chip
  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffF1F4F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
