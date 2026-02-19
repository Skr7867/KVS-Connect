import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';

class KeysApi {
  static Future<Map<String, dynamic>> getKeys() async {
    final token = await AppPrefrence.getString("token");

    final url = Uri.parse(
      "$mAPIbaseurl/api/retailer/keys",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": jsonDecode(response.body),

        };
      }

      return {
        "success": false,
        "statusCode": response.statusCode,
        "message": response.body.isNotEmpty
            ? jsonDecode(response.body)
            : "Failed to fetch keys",
      };
    } catch (e) {
      return {
        "success": false,
        "statusCode": 500,
        "message": e.toString(),
      };
    }
  }
}
