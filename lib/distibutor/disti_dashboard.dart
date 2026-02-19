import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:safeemilocker/api/Distibutor_Api/dashboard/distributor_dashboard_api.dart';

import '../api/Distibutor_Api/dashboard/dashboard_model.dart';
import '../text_style/colors.dart';
import '../widgets/custom_loader.dart';
import '../widgets/popup.dart';
import 'allocate_key_screen.dart';
import 'buy_key_package.dart';

class DistributorDashboardScreen extends StatefulWidget {
  const DistributorDashboardScreen({super.key});

  @override
  State<DistributorDashboardScreen> createState() =>
      _DistributorDashboardScreenState();
}

class _DistributorDashboardScreenState
    extends State<DistributorDashboardScreen> {
  DashboardModel? dashboardModel;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    appLoader.show(context);
    final rsp = DashboardDistributorApi().getAllDashboard();
    rsp
        .then((value) {
          log(value.toString());
          try {
            setState(() {
              dashboardModel = value;
              print("Data show${dashboardModel.toString()}");
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
      backgroundColor: AppColors.scaffoldBg,
      // bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 16),
              _upgradeCard(),
              const SizedBox(height: 20),
              _section("DISTRIBUTOR TEAM"),
              _twoCards(
                _statCard(
                  "Total Team",
                  "${dashboardModel?.data.team.totalTeamMembers}",
                  Icons.group,
                ),
                _progressCard(
                  "Active",
                  "${dashboardModel?.data.team.activeTeamMembers}",
                  AppColors.primaryOrange,
                ),
              ),
              const SizedBox(height: 20),
              _section("RETAILERS"),
              _twoCards(
                _statCard(
                  "Total Retailers",
                  "${dashboardModel?.data.totalRetailers}",
                  Icons.store,
                ),
                _progressCard(
                  "Active Retailers",
                  "${dashboardModel?.data.activeRetailers}",
                  Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              _section("KEYS"),
              _keysCard(),
              const SizedBox(height: 20),
              _section("QUICK ACTIONS"),
              _actions(context),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Header
  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Welcome Back,", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 4),
              Text(
                "Distributor",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.notifications_none),
            ),
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 🔹 Upgrade Banner
  Widget _upgradeCard() {
    return Container(
      height: 120,

      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: AssetImage("assets/images/upgrade_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Text(
            "Unlock More Keys",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Upgrade to premium plans",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // 🔹 Two Cards Row
  Widget _twoCards(Widget a, Widget b) {
    return Row(
      children: [
        Expanded(child: a),
        const SizedBox(width: 12),
        Expanded(child: b),
      ],
    );
  }

  // 🔹 Normal Stat Card
  Widget _statCard(String title, String value, IconData icon) {
    return _baseCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: Colors.green),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 🔹 Progress Card
  Widget _progressCard(String title, String value, Color color) {
    return _baseCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.flash_on, size: 18, color: color),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.9,
            color: color,
            backgroundColor: color.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  // 🔹 Keys Card
  Widget _keysCard() {
    return _baseCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // ✅ important
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Keys", style: TextStyle(color: Colors.grey)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.key,
                  size: 18,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "${dashboardModel?.data.totalKeysAllocated}",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          /// 🔥 FIX HERE
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _miniStat(
                "${dashboardModel?.data.keyAllocationStatus.sold}",
                "Sold",
              ),
              _miniStat(
                "${dashboardModel?.data.keyAllocationStatus.unusedKeys}",
                "Left",
              ),
              _miniStat(
                "${dashboardModel?.data.keyAllocationStatus.utilizationPercent}%",
                "Utilization",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label) {
    return Container(
      width: 93,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF2F4F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // 🔹 Quick Actions
  Widget _actions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BuyKeyPackageScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: _actionBtn(
              "Request Keys",
              Colors.green.shade100,
              AppColors.BtnGreenBg,
            ),
          ),
        ),

        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AllocateKeyScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),

            child: _actionBtn(
              "Allocate Key",
              Colors.orange.shade100,
              AppColors.primaryOrange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionBtn(String text, Color bg, Color color) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _section(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _baseCard(Widget child) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: AppColors.primaryOrange,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "Team"),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: "Retailers"),
        BottomNavigationBarItem(icon: Icon(Icons.key), label: "Keys"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "My Account"),
      ],
    );
  }
}
