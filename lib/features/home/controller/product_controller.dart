
import 'dart:convert';
import 'package:eommerce_test/core/network/remote/dio/dio_client.dart';
import 'package:eommerce_test/features/home/data/model/product_response_model.dart';
import 'package:eommerce_test/features/home/data/repository/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base_response/api_response.dart';
import '../../../utils/helper/share_preference.dart';
import '../data/model/categories_response_model.dart';
import '../data/model/product_response_model.dart' as product_model;



class ProductController extends GetxController {
  final ProductRepo productRepo;
  final DioClient dioClient;
  final SharedPreferencesClass sharedPreferencesClass;

  ProductController({
    required this.productRepo,
    required this.sharedPreferencesClass,
    required this.dioClient
  });



  TextEditingController searchController = TextEditingController();
  RxBool isLoadingProducts = false.obs;
  RxString productsError = ''.obs;

  RxList<product_model.Product> productList = <product_model.Product>[].obs;
  RxList<Map<String, dynamic>> cartList = <Map<String, dynamic>>[].obs;

  ///categories
  RxList<CategoriesResponseModel> categories = <CategoriesResponseModel>[].obs;

  RxInt selectedCategoryIndex = 0.obs;
  RxBool isLoadingCategories = false.obs;
  RxString categoriesError = ''.obs;

  String? selectedCategorySlug;

  /// pagination

  int limit = 10;
  int skip = 0;
  bool hasMore = true;
  ScrollController scrollController = ScrollController();


  @override
  void onInit() {
    super.onInit();

    loadLocalProducts();
    getAllCategoriesInfo();
    getAllProductsInfo();
    scrollController.addListener(_paginationListener);
  }

  void _paginationListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent &&
        hasMore &&
        !isLoadingProducts.value) {
      if (selectedCategorySlug != null) {
        getProductsByCategory(selectedCategorySlug!);
      } else {
        getAllProductsInfo();
      }
    }
  }

  // get all products
  Future<void> getAllProductsInfo() async {
    if (!hasMore) return;

    isLoadingProducts.value = true;
    productsError.value = '';

    try {
      ApiResponse apiResponse =
      await productRepo.getAllProducts(
        limit: limit,
        skip: skip,
      );

      if (apiResponse.response?.statusCode == 200) {
        product_model.ProductResponseModel model =
        product_model.ProductResponseModel.fromJson(
            apiResponse.response!.data);

        if (model.products.isNotEmpty) {
          productList.addAll(model.products);
          skip += limit;
          saveProductsLocal();
        } else {
          hasMore = false;
        }
      } else {
        productsError.value = 'Failed to load products.';
      }
    } catch (e) {
      productsError.value = 'Something went wrong.';
    } finally {
      isLoadingProducts.value = false;
    }
  }


  //get product by category
  Future<void> getProductsByCategory(String category) async {
    if (!hasMore) return;

    isLoadingProducts.value = true;
    productsError.value = '';

    try {
      ApiResponse apiResponse =
      await productRepo.getProductByCategory(
        limit: limit,
        skip: skip,
        category: category,
      );

      if (apiResponse.response?.statusCode == 200) {

        /// 🔥 USE SAME MODEL
        product_model.ProductResponseModel model =
        product_model.ProductResponseModel.fromJson(
            apiResponse.response!.data);

        if (model.products.isNotEmpty) {
          productList.addAll(model.products);
          skip += limit;
        } else {
          hasMore = false;
        }

      } else {
        productsError.value = 'Failed to load products.';
      }
    } catch (e) {
      print("CATEGORY ERROR: $e");
      productsError.value = 'Something went wrong.';
    } finally {
      isLoadingProducts.value = false;
    }
  }


  /// ================= CATEGORIES =================
  Future<void> getAllCategoriesInfo() async {
    isLoadingCategories.value = true;
    categoriesError.value = '';

    try {
      ApiResponse apiResponse =
      await productRepo.getAllCategories();

      final response = apiResponse.response;

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          categories.value = data.map((e) => CategoriesResponseModel.fromJson(e)).toList();
        } else {
          categoriesError.value = 'Invalid data format.';
        }
      } else {
        categoriesError.value = 'Failed to load categories.';
      }
    } catch (e) {
      categoriesError.value = 'Tap to retry';
    } finally {
      isLoadingCategories.value = false;
    }
  }

  /// ================= CATEGORY SELECT =================

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;

    skip = 0;
    hasMore = true;
    productList.clear();

    final categorySlug = categories[index].slug;
    selectedCategorySlug = categorySlug;
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++🔥 🔥 🔥SELECTED SLUG = $categorySlug");

    getProductsByCategory(categorySlug);
  }

  /// ================= RETRY =================
  void retryCategories() => getAllCategoriesInfo();
  void retryProducts() {
    skip = 0;
    hasMore = true;
    productList.clear();

    if (selectedCategorySlug != null) {
      getProductsByCategory(selectedCategorySlug!);
    } else {
      getAllProductsInfo();
    }
  }



  /// ================= LOCAL CACHE =================
  void saveProductsLocal() {
    List data = productList.map((e) => e.toJson()).toList();
    SharedPreferencesClass.setValue("products", jsonEncode(data));
  }

  void loadLocalProducts() async {
    String? data =
    await SharedPreferencesClass.getValue("products");

    if (data != null) {
      List decoded = jsonDecode(data);

      productList.value = decoded
          .map((e) => product_model.Product.fromJson(e))
          .toList();
    }
  }
  /// ================= CART =================

  void toggleCart(Map<String, dynamic> item) {
    int id = item["id"];

    int index =
    cartList.indexWhere((e) => e["id"] == id);

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











