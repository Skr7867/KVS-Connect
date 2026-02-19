
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';


import '../create_account.dart';


class NetworkExceptions {
  static String messageData = "";

  static getDioException(error) {
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              return messageData = stringRequestCancelled;
            case DioExceptionType.connectionTimeout:
              return messageData = stringConnectionTimeout;
            case DioExceptionType.unknown:
              List<String> dateParts = error.message!.split(":");
              List<String> message = dateParts[2].split(",");

              if (message[0].trim() == stringConnectionRefused) {
                return messageData = stringServerMaintenance;
              } else if (message[0].trim() == stringNetworkUnreachable) {
                return messageData = stringNetworkUnreachable;
              } else if (dateParts[1].trim() == stringFailedToConnect) {
                return messageData = stringInternetConnection;
              } else {
                return messageData = dateParts[1];
              }
            case DioExceptionType.receiveTimeout:
              return messageData = stringTimeOut;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 400:
                  Map<String, dynamic> data = error.response?.data;

                  if (data.values.elementAt(0).runtimeType == String) {
                    return messageData = data.values.elementAt(0);
                  } else {
                    Map<String, dynamic> datas = data.values.elementAt(0);
                    if (data.values.elementAt(0) == null) {
                      var dataValue = ErrorMessageResponseModel.fromJson(
                          error.response?.data)
                          .message;
                      if (dataValue == null) {
                        return messageData = stringUnAuthRequest;
                      } else {
                        return messageData = dataValue;
                      }
                    } else {
                      return messageData = datas.values.first[0];
                    }
                  }
                case 401:
                  Get.offAll(CreateAccountScreen());
                // TODO: remove LocalKey_token
                // storage.remove(LOCALKEY_token);
                  try {
                    return messageData = error.response?.data['message'] ??
                        'Unauthorised Exception';
                  } catch (err) {
                    return messageData = 'Unauthorised Exception';
                  }
                case 403:
                /// manually logout user
                  Get.offAll(CreateAccountScreen());
                  // TODO: remove LocalKey_token
                  // storage.remove(LOCALKEY_token);
                  try {
                    return messageData = error.response?.data['message'] ??
                        'Unauthorised Exception';
                  } catch (err) {
                    return messageData = error.response?.data['message'] ??'Unauthorised Exception';
                  }
                case 404:
                  Get.offAll(CreateAccountScreen());
                  return messageData = error.response?.data['message'] ?? stringNotFound;
                case 408:
                  return messageData = stringRequestTimeOut;
                case 500:
                  return messageData = stringInternalServerError;
                case 503:
                  return messageData = stringInternetServiceUnavailable;
                default:
                  return messageData = stringSomethingsIsWrong;
              }
            case DioExceptionType.sendTimeout:
              return messageData = stringTimeOut;
            case DioExceptionType.badCertificate:
              return error.message;
            case DioExceptionType.badResponse:
              return error.message;
            case DioExceptionType.connectionError:
              return error.message;
          }
        } else if (error is SocketException) {
          return messageData = socketExceptions;
        } else {
          return messageData = stringUnexpectedException;
        }
      } on FormatException catch (_) {
        return messageData = stringFormatException;
      } catch (_) {
        return messageData = stringUnexpectedException;
      }
    } else {
      if (error.toString().contains(stringNotSubType)) {
        return messageData = stringUnableToProcessData;
      } else {
        return messageData = stringUnexpectedException;
      }
    }
  }
}


const String stringRequestCancelled = "Request cancelled";
const String stringNotSubType = 'is not a subtype of';
const String stringUnableToProcessData = 'Unable to process data';
const String stringProcessData = 'process data';
const String stringConnectionTimeout = 'Connection timeout';
const String stringInternetConnection = 'No Internet Connection';
const String stringTimeOut = 'Time out';
const String stringUnAuthRequest = 'Unauthorised Request';
const String stringNotFound = 'Not Found';
const String stringRequestTimeOut = 'Request Time out';
const String stringInternalServerError = 'Internal Server Error';
const String stringInternetServiceUnavailable = 'Service Unavailable';
const String stringSomethingsIsWrong = 'Something is wrong';
const String socketExceptions = 'Socket Exceptions';
const String stringUnexpectedException = 'Unexpected Exceptions';
const String stringFormatException = 'Format Exceptions';
const String stringConnectionRefused = 'Connection refused';
const String stringNetworkUnreachable = 'Network is unreachable';
const String stringServerMaintenance = "Something went wrong. Please try again later";
const String stringPleaseTryAgain = "Please try again later";
const String stringFailedToConnect = "Failed host lookup";

class ErrorMessageResponseModel {
  bool? success;
  String? message;
  String? copyrighths;

  ErrorMessageResponseModel({this.success, this.message, this.copyrighths});

  ErrorMessageResponseModel.fromJson(Map json) {
    success = json['success'];
    message = json['message'];
    copyrighths = json['copyrighths'];
  }

  Map toJson() {
    final Map data = new Map();
    data['success'] = this.success;
    data['message'] = this.message;
    data['copyrighths'] = this.copyrighths;
    return data;
  }
}