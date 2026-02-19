import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeemilocker/text_style/colors.dart';

showTost( message){
Fluttertoast.showToast(
msg: '${message}',backgroundColor: AppColors.primaryOrange,
toastLength: Toast.LENGTH_SHORT,
gravity: ToastGravity.CENTER,
textColor: Colors.white,
    fontSize: 16.0);
}