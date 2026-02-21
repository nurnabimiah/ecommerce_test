
import 'dart:convert';
import 'package:eommerce_test/core/network/remote/dio/dio_client.dart';
import 'package:eommerce_test/features/home/data/model/product_response_model.dart';
import 'package:eommerce_test/features/home/data/repository/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base_response/api_response.dart';
import '../../../utils/helper/share_preference.dart';



class ProductController extends GetxController {
  final DioClient dioClient;
  final ProductRepo productRepo;
  SharedPreferencesClass sharedPreferencesClass;

  ProductController({
    required this.productRepo,
    required this.sharedPreferencesClass,
    required this.dioClient
  });


  // product
  TextEditingController searchController = TextEditingController();
  RxBool isLoadingProducts = false.obs;
  RxList<Product> productList = <Product>[].obs;
  RxList<Map<String, dynamic>> cartList = <Map<String, dynamic>>[].obs;


  // Pagination
  int limit = 10;
  int skip = 0;
  bool hasMore = true;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    loadLocalProducts();
    getAllProductsInfo();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          hasMore &&
          !isLoadingProducts.value) {
        getAllProductsInfo();
      }
    });
  }

  /// ==========================================================================
  /// GET ALL PRODUCT API CALL WITH PAGINATION
  /// ==========================================================================
  Future<void> getAllProductsInfo() async {
    if (!hasMore) return;

    isLoadingProducts.value = true;

    try {
      ApiResponse apiResponse =
      await productRepo.getAllProducts(limit: limit, skip: skip);

      if (apiResponse.response?.statusCode == 200) {
        ProductResponseModel model =
        ProductResponseModel.fromJson(apiResponse.response!.data);

        if (model.products.isNotEmpty) {
          productList.addAll(model.products);
          skip += limit;

          saveProductsLocal();
        } else {
          hasMore = false;
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoadingProducts.value = false;
    }
  }

  /// ==========================================================================
  /// LOCAL SAVE
  /// ============================================================================
  void saveProductsLocal() {
    List data = productList.map((e) => e.toJson()).toList();
    SharedPreferencesClass.setValue("products", jsonEncode(data));
  }

  void loadLocalProducts() async {
    String? data = await SharedPreferencesClass.getValue("products");

    if (data != null) {
      List decoded = jsonDecode(data);

      productList.value =
          decoded.map((e) => Product.fromJson(e)).toList();
    }
  }




  void toggleCart(Map<String, dynamic> item) {
    int id = item["id"];
    int index = cartList.indexWhere((e) => e["id"] == id);

    if (index != -1) {
      cartList.removeAt(index);
    } else {
      cartList.add(item);
    }
  }

  bool isInCart(dynamic id) {
    return cartList.any((e) => e["id"] == id);
  }

  int get cartCount => cartList.length;




}








