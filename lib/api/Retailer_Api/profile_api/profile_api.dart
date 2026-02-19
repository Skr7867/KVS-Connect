import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:safeemilocker/api/Retailer_Api/profile_api/profile_api_model.dart';

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';



class ProfileApi {
  Future<RetailerProfileModel> getProfile() async {
    final token = await AppPrefrence.getString('token');

    final uri = Uri.parse(
      '$mAPIbaseurl/api/retailer/profile',
    );

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
    return RetailerProfileModel.fromJson(jsonData);
  }
}