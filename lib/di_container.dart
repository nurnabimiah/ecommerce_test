
import 'package:dio/dio.dart';
import 'package:eommerce_test/features/home/controller/product_controller.dart';
import 'package:eommerce_test/features/home/data/repository/product_repo.dart';
import 'package:eommerce_test/utils/app_constans/app_constans.dart';
import 'package:eommerce_test/utils/helper/share_preference.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/remote/dio/dio_client.dart';
import 'core/network/remote/dio/logging_interceptor.dart';
import 'features/splash/controller/splash_controller.dart';

final sl = GetIt.instance;

Future<void> init() async {

  /// Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  /// Repository
  sl.registerLazySingleton(() => ProductRepo(dioClient: sl(), sharedPreferencesClass: sl()));




  /// Controller

  Get.lazyPut(() => SplashController(),fenix: true);
   Get.lazyPut(() => ProductController(dioClient: sl(),productRepo: sl(),sharedPreferencesClass: sl()),fenix: true);






  /// External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());

  //register
  sl.registerLazySingleton(() => SharedPreferencesClass());


}