import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeemilocker/contants/string_constant.dart';

import '../../../contants/user_storedata.dart';

class DistributorAddKeysApi {


  Future<Map<String, dynamic>> addKeys({
    required String retailerId,
    required int quantity,
    required String validTo, // yyyy-MM-dd
    String? notes,
  }) async {
    final token = await AppPrefrence.getString('token');
    final uri = Uri.parse(
      "$mAPIbaseurl/distributor/retailers/$retailerId/keys",
    );

    final body = {
      "quantity": quantity,
      "valid_to": validTo,
      if (notes != null && notes.isNotEmpty) "notes": notes,
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      /// ✅ Decode response safely
      final Map<String, dynamic> data =
      jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "Something went wrong",
          "statusCode": response.statusCode,
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}
