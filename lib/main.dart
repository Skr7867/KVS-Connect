import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:safeemilocker/splash_screen.dart';

import 'Retailer/home.dart';
import 'contants/user_storedata.dart';
import 'distibutor/home.dart';

var isLoggedIn = false;
var isRetailer = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var token = await AppPrefrence.getToken();
  log("token value $token");
  isLoggedIn = token != null;
  final role = await AppPrefrence.getString("role");
  isRetailer = role == "RETAILER";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: !isLoggedIn
          ? SplashScreen()
          : (isRetailer ? Home() : HomeDistibuter()),
    );
  }
}
