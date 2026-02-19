import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:safeemilocker/Retailer/kyc_doc.dart';
import 'package:safeemilocker/Retailer/my_key_screen.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';

import '../api/Retailer_Api/profile_api/profile_api.dart';
import '../api/Retailer_Api/profile_api/profile_api_model.dart';
import '../create_account.dart';
import '../widgets/custom_loader.dart';
import '../widgets/popup.dart';
import 'my_bank_details.dart';
import 'my_profile.dart';
import 'my_team_screen.dart';
import 'notifications_screen.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  RetailerProfileModel? profiledata;
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    // appLoader.show(context);
    final rsp = ProfileApi().getProfile();
    rsp
        .then((value) {
          log(value.toString());
          try {
            setState(() {
              profiledata = value;
              print("Data show${profiledata.toString()}");
              // print("data show opposite gender${oppositegenderMataches}");
            });
            appLoader.hide();
          } catch (e) {
            setState(() {
              // loadingData = false;
            });
          }
        })
        .onError((error, stackTrace) {
          showTost(error);
          print(error);
          appLoader.hide();
        })
        .whenComplete(() {
          appLoader.hide();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Account', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF255FA2), Color(0xFF102A43)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileHeader(),
              const SizedBox(height: 16),
              _statsCards(),
              const SizedBox(height: 20),
              _sectionTitle("Account Controls"),
              _controlsGrid(),
              const SizedBox(height: 20),
              /*_sectionTitle("Personal & Shop Details"),
              _detailsCard(),*/
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Profile Header
  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF255FA2), Color(0xFF102A43)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
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
                      profiledata?.data.profile.name ?? 'Devolyt Retailer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Retailer • ID:${profiledata?.data.profile.retailerId ?? '....'}\nMobile EMI Locker Partner",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAccountScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.logout, size: 16, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            children: [
              _statusChip("KYC Verified", Icons.verified, Colors.green),
              _statusChip("Notifications On", Icons.notifications, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Status Cards
  Widget _statsCards() {
    return Row(
      children: [
        _statCard(
          "AVAILABLE\nKEYS",
          "${profiledata?.data.keyMetrics.availableKeys ?? '0'}",
          const Color(0xFF4F5DFF),
        ),
        const SizedBox(width: 12),
        _statCard(
          "WALLET\nBALANCE",
          "₹ ${profiledata?.data.keyMetrics.walletBalance ?? '0'}",
          const Color(0xFF0C7A43),
        ),
        const SizedBox(width: 12),
        _statCard(
          "PENDING\nDUES",
          "₹ ${profiledata?.data.keyMetrics.pendingDues ?? '0'}",
          const Color(0xFFFF4D5A),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.text12w600White),
            const Spacer(),
            Text(value, style: AppTextStyles.heading21w700white),
          ],
        ),
      ),
    );
  }

  // 🔹 Controls Grid
  Widget _controlsGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.80,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyProfile()),
            );
          },
          child: _ControlTile(Icons.person, "My Profile", Colors.indigo),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KycDoc()),
            );
          },
          child: _ControlTile(Icons.badge, "KYC & Docs", Colors.purple),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyBankDetails()),
            );
          },
          child: _ControlTile(
            Icons.account_balance,
            "Bank Details",
            Colors.green,
          ),
        ),
        //const _ControlTile(Icons.lock, "Change Pass", Colors.pink),
        Builder(
          builder: (context) => InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
            child: const _ControlTile(
              Icons.notifications,
              "Notifications",
              Colors.teal,
            ),
          ),
        ),
        Builder(
          builder: (context) => InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyKeysScreen()),
              );
            },
            child: const _ControlTile(
              Icons.key,
              "My Key",
              AppColors.primaryOrange,
            ),
          ),
        ),
        Builder(
          builder: (context) => InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyTeamScreen()),
              );
            },
            child: const _ControlTile(
              Icons.people,
              "My Team",
              AppColors.textColorFF671F,
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Details Card
  Widget _detailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _detailRow("Name", "${profiledata?.data.personalDetails.name}"),
          _detailRow("Phone", "${profiledata?.data.personalDetails.phone}"),
          _detailRow("Email", "${profiledata?.data.personalDetails.email}"),
          _detailRow("Address", "${profiledata?.data.personalDetails.address}"),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _statusChip(String label, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: 4,
      selectedItemColor: AppColors.primaryOrange,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: "Customersvvv",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.key), label: "My Key"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "My Team"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "My Account"),
      ],
    );
  }
}

// 🔹 Reusable Widgets
class _ControlTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _ControlTile(this.icon, this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppTextStyles.text13w600White,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _detailRow extends StatelessWidget {
  final String label;
  final String value;

  const _detailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
