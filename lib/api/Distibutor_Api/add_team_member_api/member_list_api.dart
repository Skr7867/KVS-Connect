import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:safeemilocker/api/Distibutor_Api/retailer_list_api/retailer_list_model.dart';

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';
class MemberListApi {
  Future<Map<String, dynamic>> get({
    int page = 1,
    int limit = 20,
    String search = "",
    String accountStatus = "",
  }) async {
    final uri = Uri.parse("$mAPIbaseurl/api/distributor/teams/members").replace(
      queryParameters: {
        "page": page.toString(),
        "limit": limit.toString(),
        if (search.trim().isNotEmpty) "search": search.trim(),
        if (accountStatus.trim().isNotEmpty)
          "account_status": accountStatus.trim(),
      },
    );

    print("API URL => $uri");

    final token = await AppPrefrence.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception("Token missing");
    }

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("STATUS => ${response.statusCode}");
    print("BODY => ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load retailer (${response.statusCode})");
    }
  }
}
