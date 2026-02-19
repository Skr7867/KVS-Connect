
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../contants/user_storedata.dart';
import 'exceptions.dart';
import 'log_interceptor.dart'as LogInterceptor;

const _defaultConnectTimeout = Duration(seconds: 45);
const _defaultReceiveTimeout = Duration(seconds: 45);

setContentType() {
  return "application/json";
}

class _DioClient {
  String baseUrl = "https://sel-backend-01o4.onrender.com"; //"https://matrimoney-app-backend.onrender.com";//"https://admin.hisathi.com";

  static late Dio _dio;

  final List<Interceptor>? interceptors;

  _DioClient( {
        this.interceptors,
      }) {
    _dio = Dio();
    _dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..httpClientAdapter
      ..options.contentType = setContentType()
      ..options.headers = {
        'Content-Type': setContentType(),
      };

    if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors!);
    }
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor.LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: false,
          requestBody: true,
        ),
      );
    }
  }

  Future<dynamic> get(String uri,
      {Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        bool skipAuth =false}) async {
    try {
      if (skipAuth == false) {
        String? token = await AppPrefrence.getToken();
        debugPrint("Token - $token");
        if (token != null) {
          options = Options(headers: {"Authorization": "Bearer $token"});
        }
      }
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  Future<dynamic> delete(String uri,
      {Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        bool skipAuth =false}) async {
    try {
      if (skipAuth == false) {
        String? token = await AppPrefrence.getToken();
        debugPrint("Token - $token");
        if (token != null) {
          options = Options(headers: {"Authorization": "Bearer $token"});
        }
      }
      var response = await _dio.delete(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  Future<dynamic> post(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool? skipAuth = false,
        String? authToken,
      }) async {
    try {
      if (skipAuth == false) {
        String? token = authToken ?? await AppPrefrence.getToken();
        if (token != null) {
          options ??= Options();
          options.headers ??= {};
          options.headers!["Authorization"] = "Bearer $token";
        }
      }

      final response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      /// ✅ ACCEPT ALL 2xx AS SUCCESS
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return response.data;
      }

      /// ❌ Only non-2xx is error
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

    } on DioException catch (e) {
      /// ❗ Backend success but Dio marked badResponse
      if (e.response?.data != null &&
          e.response?.data is Map &&
          e.response?.data['success'] == true) {
        return e.response!.data;
      }

      throw NetworkExceptions.getDioException(e);

    } catch (e) {
      rethrow;
    }
  }


  static Future<dynamic> put(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      var response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {

      throw NetworkExceptions.getDioException(e);
    }
  }
}

var apiRequest = _DioClient();

class SuccessMessage{
  String message;
  String copyrights;
  SuccessMessage(this.message,this.copyrights);
  SuccessMessage.fromJson(Map<String,dynamic> json):
        this.message = json['message']??'',
        this.copyrights = json['copyrights']??"";

}