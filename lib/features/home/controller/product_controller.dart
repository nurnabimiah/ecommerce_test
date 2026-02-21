
import 'dart:convert';
import 'package:eommerce_test/core/network/remote/dio/dio_client.dart';
import 'package:eommerce_test/features/home/data/model/product_response_model.dart';
import 'package:eommerce_test/features/home/data/repository/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base_response/api_response.dart';
import '../../../utils/helper/share_preference.dart';
import '../data/model/categories_response_model.dart';



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
  RxString productsError = ''.obs;
  RxList<Product> productList = <Product>[].obs;
  RxList<Map<String, dynamic>> cartList = <Map<String, dynamic>>[].obs;


  // categories
  RxList<CategoriesResponseModel> categories = <CategoriesResponseModel>[].obs;
  RxInt selectedCategoryIndex = 0.obs;
  RxBool isLoadingCategories = false.obs;
  RxString categoriesError = ''.obs;

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
    getAllCategoriesInfo();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          hasMore &&
          !isLoadingProducts.value) {
        getAllProductsInfo();
      }
    });
  }


  /// GET ALL PRODUCT API CALL WITH PAGINATION
  Future<void> getAllProductsInfo() async {
    if (!hasMore) return;

    isLoadingProducts.value = true;
    productsError.value = '';

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
      } else {
        productsError.value = 'Failed to load products. Pull to retry.';
      }
    } catch (e) {
      debugPrint("Error: $e");
      productsError.value = 'Something went wrong. Tap to retry.';
    } finally {
      isLoadingProducts.value = false;
    }
  }


  /// GET ALL CATEGORIES
  Future<void> getAllCategoriesInfo() async {
    isLoadingCategories.value = true;
    categoriesError.value = '';

    try {
      ApiResponse apiResponse = await productRepo.getAllCategories();

      if (apiResponse.response?.statusCode == 200) {
        List data = apiResponse.response!.data;
        categories.value = data
            .map((e) => CategoriesResponseModel.fromJson(e))
            .toList();
        debugPrint("Categories Loaded: ${categories.length}");
      } else {
        categoriesError.value = 'Failed to load categories.';
      }
    } catch (e) {
      debugPrint("Category Error: $e");
      categoriesError.value = 'Tap to retry';
    } finally {
      isLoadingCategories.value = false;
    }
  }

  void retryCategories() => getAllCategoriesInfo();
  void retryProducts() {
    if (productList.isEmpty) {
      skip = 0;
      hasMore = true;
      productList.clear();
      getAllProductsInfo();
    }
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }



  /// LOCAL SAVE
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








