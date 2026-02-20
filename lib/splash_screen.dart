import 'dart:async';

import 'package:flutter/material.dart';

import 'Retailer/home.dart';
import 'contants/user_storedata.dart';
import 'create_account.dart';
import 'distibutor/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await AppPrefrence.getToken();
    final role = await AppPrefrence.getString("role");

    if (!mounted) return;

    // ✅ Proper token validation
    if (token == null || token.isEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => CreateAccountScreen()),
        (route) => false,
      );
    } else if (role == "RETAILER") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => Home()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeDistibuter()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset('assets/image/KVSAppLogo.png', height: 150),
        ),
      ),
    );
  }
}
