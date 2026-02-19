import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';

class   AddRetailerApi{
  Future<Map<String, dynamic>> addRetailer({
  required String fullName,
  required String shopName,
  required String mobile,
  String? email,
  String? panNo,
  String? gstNo,
  required String state,
  required String city,
  required String pincode,
  required String shopAddress,
  String? distributorId,
}) async {
  final url = Uri.parse("$mAPIbaseurl/api/distributor/retailers");
  final token = await AppPrefrence.getString('token');

  final Map<String, dynamic> body = {
    "fullName": fullName,
    "shopName": shopName,
    "mobile": mobile,
    "state": state,
    "city": city,
    "pincode": pincode,
    "shopAddress": shopAddress,
  };

  if (email != null && email.isNotEmpty) body["email"] = email;
  if (panNo != null && panNo.isNotEmpty) body["pan_no"] = panNo;
  if (gstNo != null && gstNo.isNotEmpty) body["gst_no"] = gstNo;
  if (distributorId != null && distributorId.isNotEmpty) {
    body["distributorId"] = distributorId;
  }

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception("API Error: ${response.body}");
  }
}}
