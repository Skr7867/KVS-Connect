import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:safeemilocker/contants/string_constant.dart';

import '../../../contants/user_storedata.dart';

class PanDocumentsApi {
  Future<Map<String, dynamic>> uploadBusinessDocuments({
    required Map panDetails,
  }) async {
    final token = await AppPrefrence.getString("token");

    final url = Uri.parse("$mAPIbaseurl/api/kyc/kyc/business-documents");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"panDetails": panDetails}),
    );

    return jsonDecode(response.body);
  }
}

class GstDocumentsApi {
  Future<Map<String, dynamic>> uploadBusinessDocuments({
    required Map gstDetails,
  }) async {
    final token = await AppPrefrence.getString("token");

    final url = Uri.parse("$mAPIbaseurl/api/kyc/kyc/business-documents");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"gstDetails": gstDetails}),
    );

    log("GST Submit Body: ${jsonEncode({"gstDetails": gstDetails})}");
    log("GST Submit Response: ${response.body}");

    return jsonDecode(response.body);
  }
}
