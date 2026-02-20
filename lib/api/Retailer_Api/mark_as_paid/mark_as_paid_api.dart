import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:safeemilocker/contants/string_constant.dart';

import '../../../contants/user_storedata.dart';

class InstallmentPaymentApi {
  Future<Map<String, dynamic>> payInstallment({
    required String customerId,
    required String emiId,
    required int installmentNo,
    required double amount, // Add amount parameter
    required String paymentMode, // Add payment mode parameter
  }) async {
    final url = Uri.parse(
      "$mAPIbaseurl/api/retailer/customers/$customerId/emi/$emiId/installments/$installmentNo/payment",
    );

    log("🔗 URL: $url");
    log('📌 EMI ID: $emiId');
    log('👤 Customer ID: $customerId');
    log('🔢 Installment No: $installmentNo');
    log('💰 Amount: $amount');
    log('💳 Payment Mode: $paymentMode');

    final token = await AppPrefrence.getString('token');

    // Prepare request body with required fields
    final Map<String, dynamic> requestBody = {
      "amount": amount,
      "payment_mode": paymentMode,
      // You can add optional fields if needed
      "installment_number": installmentNo,
      "payment_date": DateTime.now().toIso8601String(),
    };

    log('📦 Request Body: ${jsonEncode(requestBody)}');

    try {
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      log('📥 Response Status: ${response.statusCode}');
      log('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed (${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      log('❌ Error: $e');
      rethrow;
    }
  }
}
