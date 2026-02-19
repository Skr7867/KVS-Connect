import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';

class BankDetailsApi {
  Future<Map<String, dynamic>> submitBankDetails({
    required String accountNumber,
    required String ifscCode,
    required String accountHolderName,
    required String bankName,
    required String branchName,
  }) async {
    try {
      final token = await AppPrefrence.getToken();

      final url = Uri.parse("$mAPIbaseurl/api/kyc/kyc/bank-details");

      final body = {
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "accountHolderName": accountHolderName,
        "bankName": bankName,
        "branchName": branchName,
      };

      log("📤 BANK API REQUEST:");
      log(jsonEncode(body));

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      log("📥 BANK API RESPONSE CODE: ${response.statusCode}");
      log("📥 BANK API RESPONSE BODY: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      log("❌ Bank API Error: $e");
      rethrow;
    }
  }
}
