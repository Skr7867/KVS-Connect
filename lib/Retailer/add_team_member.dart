import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';

import '../api/add_team_member_api.dart';
import '../contants/user_storedata.dart';
import '../widgets/custom_loader.dart';
import '../widgets/file_picker.dart';

class AddTeamMemberScreen extends StatefulWidget {
  const AddTeamMemberScreen({super.key});

  @override
  State<AddTeamMemberScreen> createState() => _AddTeamMemberScreenState();
}

class _AddTeamMemberScreenState extends State<AddTeamMemberScreen> {

  File? photo;
  File? aadhaarFront;
  File? panCard;
  File? passbook;



  TextEditingController Name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController shopName =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
     // bottomNavigationBar: _bottomNav(),
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        leading:  BackButton(color: Colors.white,onPressed:() {Navigator.pop(context);},),
        title: Text("Add Team Member",style: AppTextStyles.heading16whitebold,),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _formCard(context),
                ],
              ),
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
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Team Details",
            style: AppTextStyles.heading18w700blackColor,
          ),
          const SizedBox(height: 4),
           Text(
            "Basic info & optional KYC documents.",
            style: AppTextStyles.body14w400textColorgrey,
          ),
          const SizedBox(height: 16),
          _input( label:"Name *",hint:"Enter full name",controller:Name),
          const SizedBox(height: 14),
          _input( label:"Mobile Number *",hint:"98765 43210",controller:mobileNo),
          const SizedBox(height: 14),
          _input( label:"Email (Optional)",hint:"name@example.com",controller:email),

          const SizedBox(height: 14),
          _input( label:"Shop / Branch *)",hint:"Main Branch",controller:shopName),
          const SizedBox(height: 24),
          Text(
            "Upload Documents",
            style: AppTextStyles.heading18w700blackColor,
          ),
          const SizedBox(height: 4),
          Text(
            "All documents are optional.",
            style: AppTextStyles.caption12,
          ),
          const SizedBox(height: 16),

          _uploadGrid(),

          const SizedBox(height: 24),
          _submitButton(),

          const SizedBox(height: 12),
          Text(
            "You can share login details with the team member separately. "
                "You can always edit/deactivate them from the Team list.",
            textAlign: TextAlign.center,
            style: AppTextStyles.caption12,
          ),
        ],
      ),
    );
  }

  // 🔶 Widgets
  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

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
            hintText: hint,hintStyle: TextStyle(color:  AppColors.textHint),
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



  // 🔶 Upload Grid
  Widget _uploadGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
      InkWell(
        onTap: () async {
          File? pickedFile = await openFilePicker(context);
          if (pickedFile != null) {
            setState(() => photo = pickedFile);
          }},
        child: _UploadCard( "Photo", "Upload photo",Icons.image,
          imageFile: photo,
        ),
    ),
        InkWell(
        onTap: () async {
    File? pickedFile = await openFilePicker(context);
    if (pickedFile != null) {
    setState(() => aadhaarFront = pickedFile);
    }},
    child:_UploadCard("Aadhaar Card", "Front / Back",Icons.credit_card,imageFile: aadhaarFront)),
    InkWell(
    onTap: () async {
    File? pickedFile = await openFilePicker(context);
    if (pickedFile != null) {
    setState(() => panCard = pickedFile);
    }},
    child:  _UploadCard( "PAN Card", "Photo or scan",Icons.badge,imageFile: panCard,)),
    InkWell(
    onTap: () async {
    File? pickedFile = await openFilePicker(context);
    if (pickedFile != null) {
    setState(() => passbook = pickedFile);
    }},
    child:  _UploadCard( "Bank Passbook", "First page",Icons.account_balance,imageFile: passbook,)),
      ],
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
        final  Future<Map<String, dynamic>> resp =  AddTeamMemberApi.get(
              email: email.text,
              mobile: mobileNo.text,
              name: Name.text,
              shopBranchName: shopName.text,
              aadhar: aadhaarFront!,
              pan: panCard!,
              bankPassbook: passbook!,
              photo: photo!,

            );
            resp.then((Map<String, dynamic> value) {


              appLoader.hide();

              Fluttertoast.showToast(
                msg: value['message']?.toString() ?? "Success",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor:
                value['success'] ? AppColors.primaryOrange : Colors.red,
                textColor: Colors.white,
              );
              });},
        icon: const Icon(Icons.person_add,color: Colors.white,),
        label: Text(
          "Create Team Member",
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
    return   imageFile != null
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

