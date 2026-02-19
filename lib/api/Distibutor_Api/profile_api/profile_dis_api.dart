import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:safeemilocker/api/Distibutor_Api/profile_api/profile_dis_model.dart';
import 'package:safeemilocker/api/Retailer_Api/profile_api/profile_api_model.dart';

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';



class ProfileDisttApi {
  Future<ProfileResponseModel> getProfile() async {
    final token = await AppPrefrence.getString('token');

    final uri = Uri.parse(
      '$mAPIbaseurl/api/distributor/profile',
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
    return ProfileResponseModel.fromJson(jsonData);
  }
}