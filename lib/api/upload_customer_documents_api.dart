import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../contants/string_constant.dart';
import '../contants/user_storedata.dart';
Future uploadCustomerDocuments({
  required File aadhaarFront,
  required File aadhaarBack,
  required File pan,
  required File customerPhoto,
  required File mobileBill,
  required File mobileImage,
}) async {
  Dio dio = Dio();

  final customerId = await AppPrefrence.getString('id');
  final token = await AppPrefrence.getString("token");

  final url =
      "${mAPIbaseurl}/api/retailer/customers/$customerId/documents";

  FormData formData = FormData();

  /// 🔹 DOC TYPES (ARRAY)
  formData.fields.addAll([
    const MapEntry("doc_type", "AADHAAR_FRONT"),
    const MapEntry("doc_type", "AADHAAR_BACK"),
    const MapEntry("doc_type", "PAN"),
    const MapEntry("doc_type", "CUSTOMER_PHOTO"),
    const MapEntry("doc_type", "MOBILE_BILL"),
    const MapEntry("doc_type", "MOBILE_IMAGE"),
  ]);

  /// 🔹 FILES (ARRAY)
  formData.files.addAll([
    MapEntry(
      "files",
      await MultipartFile.fromFile(
        aadhaarFront.path,
        filename: aadhaarFront.path.split('/').last,
        contentType: MediaType("image", "jpeg"),
      ),
    ),
    MapEntry(
      "files",
      await MultipartFile.fromFile(
        aadhaarBack.path,
        filename: aadhaarBack.path.split('/').last,
        contentType: MediaType("image", "jpeg"),
      ),
    ),
    MapEntry(
      "files",
      await MultipartFile.fromFile(
        pan.path,
        filename: pan.path.split('/').last,
        contentType: MediaType("image", "jpeg"),
      ),
    ),
    MapEntry(
      "files",
      await MultipartFile.fromFile(
        customerPhoto.path,
        filename: customerPhoto.path.split('/').last,
        contentType: MediaType("image", "jpeg"),
      ),
    ),
    MapEntry(
      "files",
      await MultipartFile.fromFile(
        mobileBill.path,
        filename: mobileBill.path.split('/').last,
        contentType: MediaType("image", "jpeg"),
      ),
    ),
    MapEntry(
      "files",
      await MultipartFile.fromFile(
        mobileImage.path,
        filename: mobileImage.path.split('/').last,
        contentType: MediaType("image", "jpeg"),
      ),
    ),
  ]);

  try {
    final response = await dio.post(
      url,
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    print("✅ Upload Success: ${response.data}");
    return response.data;

  } on DioException catch (e) {
    print("❌ Upload Failed");
    print("Status: ${e.response?.statusCode}");
    print("Response: ${e.response?.data}");
    rethrow;
  }
}
