
import 'package:dio/dio.dart';
import 'package:eommerce_test/utils/helper/share_preference.dart';

import '../../../../core/base_response/api_response.dart';
import '../../../../core/network/remote/dio/dio_client.dart';
import '../../../../core/network/remote/exception/api_error_handler.dart';
import '../../../../utils/app_constans/app_constans.dart';

class ProductRepo {
  DioClient dioClient;
  SharedPreferencesClass sharedPreferencesClass;

  ProductRepo({required this.dioClient,required this.sharedPreferencesClass});

  /// get product Repo

  Future<ApiResponse> getAllProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      Response response = await dioClient.get(
        "${AppConstants.baseUrl}${AppConstants.allProducts}?limit=$limit&skip=$skip",
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(
        ApiErrorHandler.getErrorResponse(error: e),
      );
    }
  }



  Future<ApiResponse> getAllCategories() async {
    try {
      Response response = await dioClient.get(
        AppConstants.baseUrl + AppConstants.allCategories,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(
        ApiErrorHandler.getErrorResponse(error: e),
      );
    }
  }










}
