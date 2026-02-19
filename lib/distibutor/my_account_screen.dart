import 'dart:developer';

import 'package:flutter/material.dart';

import '../api/Distibutor_Api/profile_api/profile_dis_api.dart';
import '../api/Distibutor_Api/profile_api/profile_dis_model.dart';
import '../text_style/colors.dart';
import '../widgets/custom_loader.dart';
import '../widgets/popup.dart';
import 'notification_screen.dart';

class MyAccountScreenDistibutor extends StatefulWidget {
  const MyAccountScreenDistibutor({super.key});

  @override
  State<MyAccountScreenDistibutor> createState() => _MyAccountScreenDistibutorState();
}

class _MyAccountScreenDistibutorState extends State<MyAccountScreenDistibutor> {

  ProfileResponseModel? profiledisttdata;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    appLoader.show(context);
    final rsp = ProfileDisttApi().getProfile();
    rsp.then((value) {
      log(value.toString());
      try {
        setState(() {
          profiledisttdata = value;
          print("Data show${profiledisttdata.toString()}");
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
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "My Account",
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _profileCard(),
            const SizedBox(height: 16),
            _contactInfo(),
            const SizedBox(height: 16),
            _accountSettings(context),
            const SizedBox(height: 16),
            _businessInfo(),
            const SizedBox(height: 16),
            _supportHelp(),
            const SizedBox(height: 24),
            _logoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _profileCard() {
    return _card(
      Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage("assets/user.jpg"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${profiledisttdata?.data?.profile.name}",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  "Distributor ID: ${profiledisttdata?.data?.profile.distributorId}",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 2),
                Text(
                  "Active since: Jan 2023",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ),
          _iconButton(Icons.edit),
        ],
      ),
    );
  }

  Widget _contactInfo() {
    return _section(
      "Contact Information",
      Column(
        children: [
          _infoRow(Icons.phone, "Phone Number", "${profiledisttdata?.data?.contactInformation.phone}"),
          _infoRow(Icons.email, "Email Address", "${profiledisttdata?.data?.contactInformation.email}"),
          _infoRow(Icons.location_on, "Address",
              "${profiledisttdata?.data?.contactInformation.address}"),
        ],
      ),
    );
  }

  Widget _accountSettings(BuildContext context) {
    return _section(
      "Account Settings",
      Column(
        children: [
          _menuRow(Icons.security, "Privacy & Security"),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => NotificationsScreenDistibutor(),),);
            },


            child: _menuRow(Icons.notifications, "Notifications"),),
          _menuRow(Icons.lock, "Change Password"),
        ],
      ),
    );
  }

  Widget _businessInfo() {
    return _section(
      "Business Information",
      Row(
        children: [
          Expanded(
            child: _gradientCard(
              "Business Type",
              "Distributor",
              [Colors.green.shade800, AppColors.primaryOrange],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _gradientCard(
              "Current Plan",
              "Premium",
              [AppColors.primaryOrange, Colors.deepOrange],
            ),
          ),
        ],
      ),
    );
  }

  Widget _supportHelp() {
    return _section(
      "Support & Help",
      Column(
        children: [
          _menuRow(Icons.support_agent, "Customer Support"),
          _menuRow(Icons.help_outline, "FAQ"),
          _menuRow(Icons.star_rate, "Rate Our App"),
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.logout, color: Colors.red),
          SizedBox(width: 8),
          Text(
            "Logout",
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.orange.withOpacity(0.15),
            child: Icon(icon, color: AppColors.primaryOrange, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          _iconButton(Icons.edit),
        ],
      ),
    );
  }

  Widget _menuRow(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade100,
            child: Icon(icon, size: 18, color: Colors.deepOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style:
                const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _gradientCard(String title, String value, List<Color> colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: colors),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: AppColors.primaryOrange),
    );
  }

}