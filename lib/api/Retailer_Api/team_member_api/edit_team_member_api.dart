import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';

class MemberEditApi {
  static Future<Map<String, dynamic>> editMember({
    required String  fullname,
    required String  email
  }) async {
    final token = await AppPrefrence.getString("token");
    final memberId = await AppPrefrence.getString('id');

    final url = Uri.parse(
      "$mAPIbaseurl/api/retailer/teams/members/$memberId",
    );

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "fullname": fullname,
          "email": email,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          "success": true,
          "statusCode": response.statusCode,
          "message": "Member edit successfully",
        };
      }

      return {
        "success": false,
        "statusCode": response.statusCode,
        "message": response.body.isNotEmpty
            ? jsonDecode(response.body)
            : "Failed to edit member",
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
