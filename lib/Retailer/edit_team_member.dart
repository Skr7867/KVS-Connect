import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';

import '../api/Retailer_Api/team_member_api/edit_team_member_api.dart';
import '../api/add_team_member_api.dart';
import '../contants/user_storedata.dart';
import '../widgets/custom_loader.dart';
import '../widgets/file_picker.dart';

class EditTeamMemberScreen extends StatefulWidget {
  const EditTeamMemberScreen({super.key});

  @override
  State<EditTeamMemberScreen> createState() => _EditTeamMemberScreenState();
}

class _EditTeamMemberScreenState extends State<EditTeamMemberScreen> {
  TextEditingController Name = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      // bottomNavigationBar: _bottomNav(),
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Edit Team Member"),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [_formCard(context)]),
            );
          },
        ),
      ),
    );
  }

  // 🔶 Main Form Card
  Widget _formCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(" Edit Team Details", style: AppTextStyles.heading18w700white),

          const SizedBox(height: 16),
          _input(label: "Name *", hint: "Enter full name", controller: Name),
          const SizedBox(height: 14),
          // _input( label:"Mobile Number *",hint:"98765 43210",controller:mobileNo),
          const SizedBox(height: 14),
          _input(
            label: "Email (Optional)",
            hint: "name@example.com",
            controller: email,
          ),

          const SizedBox(height: 14),
          //_input( label:"Shop / Branch *)",hint:"Main Branch",controller:shopName),
          const SizedBox(height: 24),
          _submitButton(),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // 🔶 Widgets
  Widget _label(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w600));
  }

  Widget _input({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onEditTap,
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
              fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
              suffixIcon: readOnly
                  ? IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: onEditTap,
                    )
                  : const Icon(Icons.check, size: 18),
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

  // 🔶 Upload Grid

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          final Future<Map<String, dynamic>> resp = MemberEditApi.editMember(
            email: email.text,
            fullname: Name.text,
          );
          resp.then((Map<String, dynamic> value) {
            appLoader.hide();

            Fluttertoast.showToast(
              msg: value['message']?.toString() ?? "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: value['success']
                  ? AppColors.primaryOrange
                  : Colors.red,
              textColor: Colors.white,
            );
          });
        },
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: Text(
          "Edit Team Member",
          style: AppTextStyles.heading16whitebold,
        ),
      ),
    );
  }

  // 🔶 Bottom Navigation
  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: 3,
      selectedItemColor: AppColors.primaryOrange,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "Customers"),
        BottomNavigationBarItem(icon: Icon(Icons.key), label: "My Key"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "My Team"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
    );
  }
}

// 🔹 Upload Card Widget

Widget _UploadCard(
  String title,
  String subtitle,
  IconData icon, {
  File? imageFile,
}) {
  return imageFile != null
      ? ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        )
      : Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.caption12,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
}
