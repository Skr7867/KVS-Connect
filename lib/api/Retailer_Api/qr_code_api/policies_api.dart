import 'dart:convert';
import 'package:http/http.dart' as http;


import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';

class PolicyApiService {

   Future<dynamic> createPolicy() async {
    final uri = Uri.parse("$mAPIbaseurl/api/policies");

    final body = {
      "enterpriseId": "LC00ynkd6x",
      "policyId": "policy51",
      "name": "androidnew",
      "description": "new",
    };
    final token = await AppPrefrence.getString('token');
    //final policyId = ['data']['policyId'];
    //  final policyid = await AppPrefrence.putString('policyId', policyId);
    try {
      final response = await http.post(
        uri,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body);
      /// ✅ RESPONSE PRINT
      print("Status Code: ${response.statusCode}");
      print("Response Body: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Policy Created ✅");
        return data; // ← actual response return
      } else {
        print("API Error ❌");
        return data; // return error response also
      }
    } catch (e) {
      print("Exception ❌ $e");
      return {
        "success": false,
        "message": e.toString(),
      };
    }
   }
}
