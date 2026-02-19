import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';
import 'Customer_all_get_model.dart';

class CustomerDataApi {
  Future<GetAllCustomers> getAllCustomers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final token = await AppPrefrence.getString('token');

    /// ⭐ QUERY PARAMS
    final queryParams = {
      "page": page.toString(),
      "limit": limit.toString(),
      if (search != null && search.isNotEmpty) "search": search,
    };

    final uri = Uri.parse(
      '$mAPIbaseurl/api/retailer/customers',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return GetAllCustomers.fromJson(jsonData);
    } else {
      throw Exception("Customer API Failed: ${response.statusCode}");
    }
  }
}
