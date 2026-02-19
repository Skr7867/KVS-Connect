import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:safeemilocker/text_style/colors.dart';

import '../contants/string_constant.dart';
import '../contants/user_storedata.dart';

class AddCustomerApi {

  Future<Map<String, dynamic>> get({
    required String FullName,
    required String email,
    required String mobile,
    required String bankName,
    required String accountNo,
    required String ifsc,
    required String accountHolderName,
    required String amount,
    required String frequency,
    required String intallmentduration,
    required String startDate,
    required String notes,
    required String refName1,
    required String refmobile1,
    required String refName2,
    required String refmobile2,
    required String ram,
    required String color,
    required String model,
    required String imeino1,
    required String imeino2,
    required String phoneType,
  }) async {

    final body = {
      "fullName": FullName,
      "email": email,
      "mobile": mobile,
      "bank_name": bankName,
      "account_no": accountNo,
      "ifsc_code": ifsc,
      "account_holder_name": accountHolderName,
      "amount": amount,
      "frequency":frequency,
      "installment_duration": intallmentduration,
      "start_date": startDate,
      "notes": notes,
      "references": [
        {
          "reference_name": refName1,
          "reference_mobile": refmobile1,
        },
        {
          "reference_name": refName2,
          "reference_mobile": refmobile2,
        }
      ],
      "mobile_details": {
        "RAM": ram,
        "color": color,
        "model": model,
        "IMEI_no_1": imeino1,
        "IMEI_no_2": imeino2
      }, "phone_type":phoneType,
    };

    final token = await AppPrefrence.getString("token");

    final Uri url = Uri.parse(
      "${mAPIbaseurl}/api/retailer/customers",
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

      Fluttertoast.showToast(
        msg: response.body.toString(),   // pura error body
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 50,
        backgroundColor: AppColors.primaryOrange,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }

    /// ✅ RETURN MAP
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
