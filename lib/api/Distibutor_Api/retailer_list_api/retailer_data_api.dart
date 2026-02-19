import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:safeemilocker/api/Distibutor_Api/retailer_list_api/retailer_list_model.dart';

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';

class RetailerDataApi {
  Future<RetailerResponseModel> getAllRetailler() async {
    final token = await AppPrefrence.getString('token');

    final uri = Uri.parse(
      '$mAPIbaseurl/api/distributor/retailers',
    );
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print("STATUS CODE => ${response.statusCode}");
    print("RAW RESPONSE => ${response.body}");

    final jsonData = jsonDecode(response.body);
    return RetailerResponseModel.fromJson(jsonData);
  }
}
