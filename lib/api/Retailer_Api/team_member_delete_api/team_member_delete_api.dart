import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeemilocker/contants/string_constant.dart';



import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../contants/user_storedata.dart';

class MemberDeleteApi {
  static Future<Map<String, dynamic>> deleteMember({
    required String deletionReason,
  }) async {
    final token = await AppPrefrence.getString("token");
    final memberId = await AppPrefrence.getString('id');

    final url = Uri.parse(
      "$mAPIbaseurl/api/retailer/teams/members/$memberId",
    );

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "deletion_reason": deletionReason, // ✅ VERY IMPORTANT
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          "success": true,
          "statusCode": response.statusCode,
          "message": "Member deleted successfully",
        };
      }

      return {
        "success": false,
        "statusCode": response.statusCode,
        "message": response.body.isNotEmpty
            ? jsonDecode(response.body)
            : "Failed to delete member",
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
