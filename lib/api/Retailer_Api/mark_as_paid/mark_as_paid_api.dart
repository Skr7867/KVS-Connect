import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeemilocker/contants/string_constant.dart';

import '../../../contants/user_storedata.dart';

class InstallmentPaymentApi {
  Future<Map<String, dynamic>> payInstallment({
    required String customerId,
    required String emiId,
    required int installmentNo,
  }) async {
    final url = Uri.parse(
        "$mAPIbaseurl/api/retailer/customers/$customerId/emi/$emiId/installments/$installmentNo/payment");
    print("url one=====$url");
    final token = await AppPrefrence.getString('token');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed: ${response.body}");
    }
  }
}
