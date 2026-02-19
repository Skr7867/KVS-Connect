import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safeemilocker/distibutor/team_screen.dart';
import 'package:safeemilocker/text_style/colors.dart';

import 'disti_dashboard.dart';
import 'key_screen.dart';
import 'myRetailer_screen.dart';
import 'my_account_screen.dart';

class HomeDistibuter extends StatefulWidget {
  const HomeDistibuter({super.key});

  @override
  State<HomeDistibuter> createState() => _HomeDistibuterState();
}

class _HomeDistibuterState extends State<HomeDistibuter> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DistributorDashboardScreen(),
    TeamScreen(),
    MyRetailersScreen(),
    KeysScreen(),
    MyAccountScreenDistibutor(),
  ];

  @override
  void initState() {
    super.initState();

    /// ✅ STATUS BAR COLOR FIX (NO WHITE STRIP)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryOrange,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // iOS support
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ⭐ IMPORTANT (Match Status Bar Color)
      backgroundColor: AppColors.primaryOrange,

      body: Container(
        color: Colors.grey.shade100, // Real screen background
        child: SafeArea(
          top: false, // ⭐ Important (Removes white strip risk)
          child: _pages[_currentIndex],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primaryOrange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Team"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Retailers"),
          BottomNavigationBarItem(icon: Icon(Icons.key), label: "Keys"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "My Account",
          ),
        ],
      ),
    );
  }
}
