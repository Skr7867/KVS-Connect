import 'dart:convert';
import 'dart:io';

import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../contants/string_constant.dart';
import '../contants/user_storedata.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddTeamMemberApi {
  static Future<Map<String, dynamic>> get({
    required String name,
    required String mobile,
    required String email,
    required String shopBranchName,
    required File photo,
    required File aadhar,
    required File pan,
    required File bankPassbook,
  }) async {
    try {
      final token = await AppPrefrence.getString("token");
      var uri = Uri.parse("$mAPIbaseurl/api/retailer/teams");

      var request = http.MultipartRequest("POST", uri);

      /// Text fields
      request.fields['name'] = name;
      request.fields['mobile'] = mobile;
      request.fields['email'] = email;
      request.fields['shop_branch_name'] = shopBranchName;

      /// File fields
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          photo.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'aadhar',
          aadhar.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'pan',
          pan.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'bank_passbook',
          bankPassbook.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      /// Headers
      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("Status Code: ${response.statusCode}");
      print("Response: $responseBody");

      final decoded = jsonDecode(responseBody);

      return {
        "success": response.statusCode == 200 || response.statusCode == 201,
        "message": decoded['message'] ?? "Something went wrong",
      };
    } catch (e) {
      print("API Error: $e");
      return {
        "success": false,
        "message": "Server error",
      };
    }
  }
}
