

import 'package:dio/dio.dart';


class ApiResponse {
  final Response? response;
  final dynamic message;

  static String titleInternetWidget = "Something went wrong";
  static String description = "Unknown error occurred, Try later";

  ApiResponse({this.response, this.message});

  ApiResponse.withError(String errorMessage)
      : response = null,
        message = errorMessage;

  ApiResponse.withSuccess(Response responseValue)
      : response = responseValue,
        message = null;
}