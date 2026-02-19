import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';
import '../customer_all_data/Customer_all_get_model.dart';

class CustomerDetailsApi {
  Future<GetAllCustomers> getCustomers(String customerId) async {
    final customerId = await AppPrefrence.getString('id');
    final token = await AppPrefrence.getString('token');

    final uri = Uri.parse('$mAPIbaseurl/api/retailer/customers/$customerId');

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
    return GetAllCustomers.fromJson(jsonData);
  }
}
