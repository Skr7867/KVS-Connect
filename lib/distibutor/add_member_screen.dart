import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api/Distibutor_Api/add_team_member_api/add_team_member_api.dart';
import '../text_style/app_text_styles.dart';
import '../text_style/colors.dart';
import '../widgets/custom_loader.dart';
import '../widgets/file_picker.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {

  File? aadhaarFront;
  File? aadhaarBack;
  File? panCard;
  File? addressProof;



  TextEditingController Name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController commission =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "Add Member",
           style: AppTextStyles.heading18whiteBold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _memberDetailsCard(),
            const SizedBox(height: 20),
            _bottomButtons(),
          ],
        ),
      ),
    );
  }

  // 🔹 Member Details Card
  Widget _memberDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.badge, color: AppColors.primaryOrange),
              SizedBox(width: 8),
              Text(
                "Member Details",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _label("Full Name"),
          _input("e.g. Aditya Gupta",Name),
          const SizedBox(height: 12),



                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Mobile Number"),
                    _input("10-digit mobile",mobileNo),
                    const SizedBox(height: 4),
                    const Text(
                      "No +91 needed",
                      style:
                      TextStyle(fontSize: 11, color: Colors.grey),
                    )
                  ],
                ),

              const SizedBox(width: 12),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Email (Optional)"),
                    _input("name@gmail.com",email),
                  ],
                ),


          const SizedBox(height: 16),

          _label("Commission / Price per Key"),
          _toggleTabs(),
          const SizedBox(height: 12),

          _label("Commission (%)"),
          _input("e.g. 5.0",commission),
          const SizedBox(height: 20),

          _label("KYC DOCUMENTS"),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children:  [
    InkWell(
    onTap: () async {
    File? pickedFile = await openFilePicker(context);
    if (pickedFile != null) {
    setState(() => aadhaarFront = pickedFile);
    }},
    child: _UploadBox( "Aadhaar (Front)",imageFile: aadhaarFront,)),
    InkWell(
    onTap: () async {
    File? pickedFile = await openFilePicker(context);
    if (pickedFile != null) {
    setState(() => aadhaarBack = pickedFile);
    }},
    child: _UploadBox( "Aadhaar (Back)",imageFile: aadhaarBack,)),
    InkWell(
    onTap: () async {
    File? pickedFile = await openFilePicker(context);
    if (pickedFile != null) {
    setState(() => panCard = pickedFile);
    }},
    child:_UploadBox( "PAN Card",imageFile: panCard)),

    InkWell(
    onTap: () async {
    File? pickedFile = await openFilePicker(context);
    if (pickedFile != null) {
    setState(() => addressProof = pickedFile);
    }},
    child:_UploadBox( "Address Proof (Any)",imageFile: addressProof)),
            ],
          )
    ]));}

  // 🔹 Bottom Buttons
  Widget _bottomButtons() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            "Save Draft",
            Icons.save,
            const Color(0xffDCE9FF),
            AppColors.primaryOrange,(){}
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionButton(
            "Add Member",
            Icons.person_add,
            AppColors.primaryOrange,
            Colors.white,
            () {
    final  Future<Map<String, dynamic>> resp =  DistributorTeamApi().createTeam(
    email: email.text,
    mobile: mobileNo.text,
    name: Name.text,
    aadhaarFront: aadhaarFront!,
    panCard: panCard!,
    addressProof: addressProof!,
    role: '', city:'', aadhaarBack:aadhaarBack! ,

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
          ),
        ),
      ],
    );
  }

  // 🔹 Widgets
  Widget _input(String hint,TextEditingController controller) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller,
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
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  Widget _toggleTabs() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Percent (%)",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Price per Key",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
      String text,
      IconData icon,
      Color bg,
      Color textColor,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        )
      ],
    );
  }
}

// 🔹 Upload Box


  Widget _UploadBox( String title,
       {
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
    ): Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey.shade300, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upload, color: AppColors.primaryOrange),
          const SizedBox(height: 6),
          const Text(
            "Upload",
            style: TextStyle(
                color: AppColors.primaryOrange, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style:
            const TextStyle(fontSize: 12, color: Colors.grey),
          )
        ],
      ),
    );
  }

