import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:safeemilocker/contants/string_constant.dart';

import '../../../contants/user_storedata.dart';

class DistributorTeamApi {
  Future<Map<String, dynamic>> createTeam({
    required String name,
    required String mobile,
    required String email,
    String? role,
    String? city,

    String? commissionType,
    String? commissionValue,

    bool canCreateRetailer = false,
    bool canAssignKey = false,
    bool canViewReports = false,

    required File aadhaarFront,
    required File aadhaarBack,
    required File panCard,
    required File addressProof,
  }) async {
    try {
      final token = await AppPrefrence.getString("token");
      var uri = Uri.parse("$mAPIbaseurl/api/distributor/teams");

      var request = http.MultipartRequest("POST", uri);

      /// Text fields
      request.fields['name'] = name;
      request.fields['mobile'] = mobile;
      request.fields['email'] = email;
      request.fields['role'] = role!;
      request.fields['city'] = city!;
      request.fields['can_view_reports'] = canViewReports.toString();
      request.fields['can_create_retailer'] = canCreateRetailer.toString();
      request.fields['can_assign_key'] = canAssignKey.toString();
      if (commissionType != null) {
        request.fields["commission_type"] = commissionType;
      }

      if (commissionValue != null) {
        request.fields["commission_value"] = commissionValue;
      }

      /// File fields
      request.files.add(
        await http.MultipartFile.fromPath(
          'aadhaar_front',
          aadhaarFront.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'aadhaar_back',
          aadhaarBack.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'pan_card',
          panCard.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'address_proof',
          addressProof.path,
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
      return {"success": false, "message": "Server error"};
    }
  }
}
