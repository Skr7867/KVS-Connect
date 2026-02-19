import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:safeemilocker/contants/string_constant.dart';

import '../../../contants/user_storedata.dart';

class KycUrlApi {
  Future<Map<String, dynamic>> getUploadUrl({
    required String docType,
    required String fileName,
    required String contentType,
    required String fileSize,
  }) async {
    final token = await AppPrefrence.getString("token");
    final url = Uri.parse("$mAPIbaseurl/api/kyc/kyc/upload-url");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "docType": docType,
        "fileName": fileName,
        "contentType": contentType,
      }),
    );
    log(response.body);
    return jsonDecode(response.body);
  }
}
