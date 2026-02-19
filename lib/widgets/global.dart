import 'package:get/get.dart';

import 'package:safeemilocker/widgets/popup.dart';

import '../contants/user_storedata.dart';
import '../create_account.dart';

class _GlobalData {
 // GetUserDataModel? activeUser;
  bool hasCheckVersion = false;

/*  String getImageUrl(image) =>
     // "https://matrimoney-app-backend.onrender.com/uploads/${image}";
  "https://hisahi.s3.ap-south-1.amazonaws.com/photos/${image}";*/
  logOutUser({String? message}) async {
    await AppPrefrence.removeToken();
    Get.offAll(CreateAccountScreen());
    showTost(message??"Logout Successfull");
  }

}

var globalData = _GlobalData();
