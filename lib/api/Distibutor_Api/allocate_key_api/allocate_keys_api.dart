import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeemilocker/contants/string_constant.dart';

import '../../../contants/user_storedata.dart';

class AllocateKeyApi {
  // 🔼 replace with your real base url

  Future<Map<String, dynamic>> allocateKey({
    required int quantity,
    required String validTo,
    required String notes,
    required String retailerId,
  }) async {
    final token = await AppPrefrence.getString('token');
    final uri = Uri.parse("$mAPIbaseurl/api/distributor/retailers/$retailerId/keys");
print("helloo one =====$uri");
    final body = {
      "quantity": quantity,
      "valid_to": validTo,
      "notes": notes,
    };

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // if needed
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Allocate Key Failed: ${response.statusCode} ${response.body}",
      );
    }
  }
}
