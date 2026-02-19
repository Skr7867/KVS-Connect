import 'dart:convert';
import 'package:safeemilocker/network/client.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../contants/string_constant.dart';



class RegsiterUserApi {

  Future<Map<String, dynamic>> sendOtp({
    required String mobileNumber,
    required String role,
  }) async {

    final url = Uri.parse(
      "${mAPIbaseurl}/api/auth/login/send-otp",
    );

    final body = jsonEncode({
      "mobile": mobileNumber,
      "role": role,
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );


    // Raw response print
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Decoded Response: $data"); // decoded response
      return data;
    } else {
      final error = jsonDecode(response.body);
      print("Error Response: $error");
      throw error['message'] ?? "Failed to send OTP";
    }
  }
}
