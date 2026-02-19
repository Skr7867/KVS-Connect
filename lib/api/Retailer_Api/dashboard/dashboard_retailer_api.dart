import 'dart:convert';

import 'package:http/http.dart' as http;


import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';
import 'dashboard_retailer_model.dart';
class DashboardRetailerApi {
  Future<RetailerDashboardModel> getAllDashboard() async {
    final token = await AppPrefrence.getString('token');

    final uri = Uri.parse(
      '$mAPIbaseurl/api/dash/retailer/dashboard',
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
    return RetailerDashboardModel.fromJson(jsonData);
  }
}