import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';
class RequestKeysApi {
  Future<Map<String, dynamic>> requestKeys({
    required int quantity,
    String? requestReason,
  }) async {
    final uri = Uri.parse(
      "$mAPIbaseurl/api/distributor/keys/request",
    );

    final body = {
      "quantity": quantity,
      "request_reason": requestReason,
    };

    try {
      final token = await AppPrefrence.getString("token");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Success: $data");
        return data; // ✅ MUST RETURN
      } else {
        print("❌ Error ${response.statusCode}: $data");
        return {
          "success": false,
          "message": data["message"] ?? "Something went wrong",
        };
      }
    } catch (e) {
      print("⚠️ Exception: $e");
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}
