import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class S3UploadService {
  static Future<bool> uploadFileToS3({
    required String uploadUrl,
    required File file,
    required String contentType,
  }) async {
    try {
      final bytes = await file.readAsBytes();

      log("Uploading File To S3...");
      log("Upload URL: $uploadUrl");
      log("Content Type: $contentType");
      log("File Size: ${bytes.length}");

      final response = await http
          .put(
            Uri.parse(uploadUrl),
            body: bytes,
            headers: {
              "Content-Type": contentType,
              "Content-Length": bytes.length.toString(),
            },
          )
          .timeout(const Duration(seconds: 60));

      log("S3 Response Code: ${response.statusCode}");
      log("S3 Response Body: ${response.body}");

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        log("✅ S3 Upload Success");
        return true;
      } else {
        log("❌ S3 Upload Failed");
        return false;
      }
    } catch (e, stack) {
      log("❌ S3 Upload Exception: $e");
      log("StackTrace: $stack");

      return false;
    }
  }
}
