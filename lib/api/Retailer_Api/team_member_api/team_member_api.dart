import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:safeemilocker/api/Retailer_Api/team_member_api/team_member_model.dart';

import '../../../contants/string_constant.dart';
import '../../../contants/user_storedata.dart';

class TeamMemberApi {
  Future<GetRetailerTeamMembers> getAllTeamMembers() async {
    final token = await AppPrefrence.getString('token');

    final uri = Uri.parse(
      '$mAPIbaseurl/api/retailer/teams/members',
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print("STATUS CODE => ${response.statusCode}");
    print("RAW RESPONSE => ${response.body}");

    final jsonData = jsonDecode(response.body);
    return GetRetailerTeamMembers.fromJson(jsonData);
  }
}