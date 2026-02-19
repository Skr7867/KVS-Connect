import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeemilocker/api/Retailer_Api/emi_pending/pending_emi_model.dart';

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';

class EmiPendingApi {
  static Future<EmiPendingModel> getCompleted({
    int page = 1,
    int limit = 10,
    String search = "",
  }) async {
    final token = await AppPrefrence.getString("token");

    final url = Uri.parse(
      "$mAPIbaseurl/api/retailer/customers/pending-emis"
    ).replace(queryParameters: {
      "page": page.toString(),
      "limit": limit.toString(),
      "search": search,
    });
 print(url);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print("STATUS CODE vcs=> ${response.statusCode}");
    print("RAW RESPONSE => ${response.body}");

    final jsonData = jsonDecode(response.body);
    return EmiPendingModel.fromJson(jsonData);
  }
}