import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';

class EmiCompetedApi {
  static Future<Map<String, dynamic>> getCompleted({
    required int page,
    required int limit,
    required String status,
  }) async {
    final token = await AppPrefrence.getString("token");

    final url = Uri.parse(
      "$mAPIbaseurl/api/retailer/customers/completed-emis?"
          "?page=$page&limit=$limit&status=$status",
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
