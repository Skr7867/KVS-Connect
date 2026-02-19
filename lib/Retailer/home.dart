import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safeemilocker/text_style/colors.dart';

import 'Shop/shop_screen.dart';
import 'customer_screen.dart';
import 'deahboard.dart';
import 'my_account_screen.dart';
import 'support_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    CustomersScreen(),
    // MyKeysScreen(),
    SupportScreen(),
    // MyTeamScreen(),
    ShopScreen(),
    MyAccountScreen(),
  ];

  @override
  void initState() {
    super.initState();

    /// ✅ STATUS BAR FIX (REMOVES WHITE STRIP)
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
      /// ⭐ Must match status bar color
      backgroundColor: AppColors.primaryOrange,

      body: Container(
        color: Colors.grey.shade100, // Actual page background
        child: SafeArea(
          top: false, // ⭐ Prevents white top gap
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
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Customers"),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: "Support",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_2_outlined),
            label: "Shop",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
