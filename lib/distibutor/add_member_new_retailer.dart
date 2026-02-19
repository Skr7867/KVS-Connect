import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';

import '../api/Distibutor_Api/addRetailer_Api/add_new_retailer_api.dart';
import '../contants/user_storedata.dart';
import '../widgets/custom_loader.dart';

class AddNewRetailerScreen extends StatefulWidget {
  const AddNewRetailerScreen({super.key});

  @override
  State<AddNewRetailerScreen> createState() => _AddNewRetailerScreenState();
}

class _AddNewRetailerScreenState extends State<AddNewRetailerScreen> {

  TextEditingController shopName = TextEditingController();
  TextEditingController ownerName = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController shopAddress = TextEditingController();
  TextEditingController cityName = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController stateName = TextEditingController();
  TextEditingController gstNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Add New Retailer",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _sectionCard(
              icon: Icons.person_add,
              iconColor: AppColors.primaryOrange,
              title: "Retailer Information",
              subtitle: "Fill in the basic details",
              child: Column(
                children: [
                  _input("Shop Name", "Enter shop name", Icons.store,shopName),
                  _input("Owner Name", "Enter owner name", Icons.person,ownerName),
                  _mobileField(mobileNumber),
                  _input("Email Address (Optional)",
                      "Enter email address", Icons.email,emailId),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              icon: Icons.location_on,
              iconColor: AppColors.BtnGreenBg,
              title: "Shop Address",
              subtitle: "Enter complete address",
              child: Column(
                children: [
                  _input("Address Line",
                      "Shop no., Building, Street", Icons.location_on,shopAddress),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _input("City", "City",null, cityName),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _input("Pincode", "Pincode", null,pinCode),
                      ),
                    ],
                  ),

              _input("State", "State Name",null, stateName),

                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              icon: Icons.business_center,
              iconColor: AppColors.colorBlue,
              title: "Business Details",
              subtitle: "Additional information",
              child: Column(
                children: [
                  _input("GST Number (Optional)",
                      "Enter GST number", Icons.confirmation_number,gstNumber),
                  //_dropdown("Business Category", "Select Category"),
                ],
              ),
            ),
            const SizedBox(height: 24),

          _primaryButton("Add Retailer", onTap: () async {
            try {
              appLoader.show(context);

              final Map<String, dynamic> value =
              await AddRetailerApi().addRetailer(
                fullName: ownerName.text.trim(),
                shopName: shopName.text.trim(),
                mobile: mobileNumber.text.trim(),
                email: emailId.text.trim(),
                panNo: '',
                gstNo: gstNumber.text.trim(),
                state: stateName.text.trim(),
                city: cityName.text.trim(),
                pincode: pinCode.text.trim(),
                shopAddress: shopAddress.text.trim(),
                distributorId: '',
              );

              appLoader.hide();

             // final customerId = value['data']['user']['id'];
              //print("customer id: $customerId");

              /// ✅ MESSAGE
              Fluttertoast.showToast(
                msg: value['message'].toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );

              /// ✅ SUCCESS CHECK
              if (value['success'] == true) {
                Navigator.pop(context);
              }

            } catch (error) {
              appLoader.hide();
              Fluttertoast.showToast(msg: error.toString());
            }
          },
          ),const SizedBox(height: 12),
            _outlineButton("Cancel"),
      ],
        ),
    ));
  }

  // 🔹 Section Card
  Widget _sectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption12,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // 🔹 Input Field
  Widget _input(String label, String hint, IconData? icon,TextEditingController controller,) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon != null ? Icon(icon, size: 18) : null,
              filled: true,
              fillColor: const Color(0xffF9FAFB),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Mobile Field
  Widget _mobileField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Mobile Number",
              style:
              TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 60,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text("+91"),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter 10 digit mobile",
                    filled: true,
                    fillColor: const Color(0xffF9FAFB),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
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

  // 🔹 Dropdown
  Widget _dropdown(String label, String hint,TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xffF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "State name",
                      filled: true,
                      fillColor: const Color(0xffF9FAFB),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Buttons
  Widget _primaryButton(String text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.heading16w600white,
          ),
        ),
      ),
    );
  }
  Widget _outlineButton(String text) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black54, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}
