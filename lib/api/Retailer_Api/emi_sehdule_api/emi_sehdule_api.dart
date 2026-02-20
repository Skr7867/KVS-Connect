import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';
import 'emi_details_model.dart';

class EmiDetailsApi {
  Future<EmiDetailsModel> getEmiDetails({
    required String customerId,
    required String emiId,
  }) async {
    final token = await AppPrefrence.getString('token');

    log("CustomerId => $customerId");
    log("EmiId => $emiId");

    final uri = Uri.parse(
      '$mAPIbaseurl/api/retailer/customers/$customerId/emi/$emiId/schedule',
    );

    log("URL => ${uri.toString()}");

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("STATUS CODE => ${response.statusCode}");
    print("RAW RESPONSE => ${response.body}");

    final jsonData = jsonDecode(response.body);
    return EmiDetailsModel.fromJson(jsonData);
  }
}
