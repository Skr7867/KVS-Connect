import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:safeemilocker/api/Retailer_Api/customer_all_data/Customer_all_get_model.dart' hide Customer;


import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';
import 'emi_details_model.dart';
class EmiDetailsApi {
  Future<EmiDetailsModel> getEmiDetails({required String customerId,
      required String emiId}) async {
    final token = await AppPrefrence.getString('token');
    final EmiId = await AppPrefrence.getString('emi_id');
    //final customerId = await AppPrefrence.getString('id');
    final uri = Uri.parse(
      '$mAPIbaseurl/api/retailer/customers/$customerId/emi/$emiId/schedule',
    );
print(uri);
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print("STATUS CODE vcs=> ${response.statusCode}");
    print("RAW RESPONSE => ${response.body}");

    final jsonData = jsonDecode(response.body);
    return EmiDetailsModel.fromJson(jsonData);
  }
}