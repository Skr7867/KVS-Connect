import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeemilocker/contants/string_constant.dart';

import '../../../contants/user_storedata.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class EnrollmentApiService {

  Future<Map<String, dynamic>> generateQr({
    required String enterpriseId,
    required String policyId,
    required String customerId,
  }) async {

    final token = await AppPrefrence.getString("token");
    final uri = Uri.parse("$mAPIbaseurl/api/enrollment/qr-code");

    final body = {
      "enterpriseId": enterpriseId,
      "policyId": policyId,
      "customerId": customerId,
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("QR Generated ✅");
        print(response.body);
        return data; // ✅ always Map
      } else {
        print("QR API Error ${response.statusCode}");
        print(response.body);
        return {}; // ✅ empty map instead of null
      }
    } catch (e) {
      print("QR Exception $e");
      return {}; // ✅ no null
    }
  }
}
