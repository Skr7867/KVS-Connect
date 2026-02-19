import 'dart:convert';

import 'package:safeemilocker/network/client.dart';



class RegisterOtp  {

  Future<dynamic> get ({required String code, String? token ,required String mobileNumber , required  String role }) async {

    var body = {
      "otp": code,
     "mobile": mobileNumber,
     "role": role,
    };

     var response = await apiRequest.post('/api/auth/login/verify-otp',data: body, authToken: token);
     return response;

  }
}
