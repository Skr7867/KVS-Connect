import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../contants/string_constant.dart';
import '../../contants/user_storedata.dart';
import 'customer_all_data/Customer_all_get_model.dart';

class SearchApi {
  Future<Map<String, dynamic>> get({
    int page = 1,
    int limit = 20,
    String search = "",
    String accountStatus = "",
    String emiStatus = "",
  }) async {
    final uri = Uri.parse("$mAPIbaseurl/api/retailer/customers").replace(
      queryParameters: {
        "page": page.toString(),
        "limit": limit.toString(),
        if (search.isNotEmpty) "search": search,
        if (accountStatus.isNotEmpty)
          "account_status": accountStatus,
        if (emiStatus.isNotEmpty) "emi_status": emiStatus,
      },
    );

    print("SEARCH API URL => $uri");

    final token = await AppPrefrence.getString('token');
    print("TOKEN => $token");

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Failed to load customers (${response.statusCode})");
    }
  }
}