import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';



class MyBankApi {
  Future<Map<String, dynamic>> get({

    required String bankName,
    required String accountNo,
    required String ifsc,
    required String accountHolderName,
    required String branchName,
  }) async {
    final body = {
      "accountNumber": accountNo,
      "ifscCode": ifsc,
      "accountHolderName": accountHolderName,
      "bankName": bankName,
      "branchName": branchName,
    };

    final token = await AppPrefrence.getString("token");

    final Uri url = Uri.parse(
      "${mAPIbaseurl}/api/kyc/kyc/bank-details",
    );
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    /// 🔍 DEBUG PRINT
    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    /// ❌ API ERROR
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("API Error: ${response.body}");
    }

    /// ✅ RETURN MAP
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

}