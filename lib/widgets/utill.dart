import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

Image displayNetworkImage(String path) {
  return Image.network(path, fit: BoxFit.cover);
}

String timeAgo(String dateTimeString) {
  // Parse the input date string
  DateTime dateTime = DateTime.parse(dateTimeString);
  print(dateTimeString);
  // Convert to local timezone
  DateTime localDateTime = dateTime.toLocal();
  print(localDateTime.toString());

  // Get the current time in the local timezone
  DateTime now = DateTime.now().toLocal();

  // Calculate the difference between now and the input date
  Duration difference = now.difference(localDateTime);

  if (difference.inMinutes <= 5) {
    print(difference.inMinutes);
    print("============================");
    return "just now";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
  } else if (difference.inDays == 1) {
    return "a day ago";
  } else if (difference.inDays > 1 && difference.inDays < 30) {
    return "${difference.inDays} days ago";
  } else if (difference.inDays >= 30 && now.month != localDateTime.month) {
    return "last month";
  } else if (difference.inDays >= 30 && now.month == localDateTime.month) {
    return DateFormat('MMMM d').format(localDateTime);
  } else if (difference.inDays >= 365 || now.year != localDateTime.year) {
    return "last year";
  } else {
    return DateFormat('MMMM d, yyyy').format(localDateTime);
  }
}

removeFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}

Future<MultipartFile> fileToMultipart(File file, String fileName) async {
  // String fileName = path.basename(file.path);
  return MultipartFile.fromFile(file.path, filename: fileName);
}

FormData jsonToFormData(Map<String, dynamic> json) {
  return FormData.fromMap(json);
}

Future<void> sendWhatsAppMessage({
  required String title,
  required String subtitle,
}) async {
  final message = '$title\n$subtitle';
  final url = 'https://wa.me/8267851405?text=${Uri.encodeComponent(message)}';
  var uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

bool checkIfExpired(DateTime date, int expirationDays) {
  // Get the current date and time
  DateTime currentDate = DateTime.now();

  // Calculate the expiration date by adding expirationDays to the given date
  DateTime expirationDate = date.add(Duration(days: expirationDays));

  // Check if the current date is after the expiration date
  return currentDate.isAfter(expirationDate);
}

String mapToString(Map<String, dynamic> map) {
  return jsonEncode(map);
}

Map stringToMap(String value) {
  String trimmedString = value.substring(1, value.length - 1).trim();

  Map<String, String> result = {};
  List<String> keyValuePairs = trimmedString.split(', ');
  for (String pair in keyValuePairs) {
    List<String> parts = pair.split(': ');
    if (parts.length == 2) {
      result[parts[0]] = parts[1];
    }
  }
  return result;
}

Future<String> getAppVersion() async {
  return "";
  /*PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;*/
}

Future<bool> isAppVersionDifferent(String compareVersion) async {
  String currentVersion = await getAppVersion();

  var versionMatched = currentVersion.trim() == compareVersion.trim();

  return false;
}
