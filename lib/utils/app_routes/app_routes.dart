

import 'package:eommerce_test/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../features/splash/screens/splash_screen.dart';

class AppRoutes {
  static int duration = 300;

  static final appRoutes = [

    defaultTransitionPage(name: SplashScreen.routeName, page: () => SplashScreen()),
    defaultTransitionPage(name: HomeScreen.routeName, page: () => HomeScreen()),






  ];
}




//
GetPage defaultTransitionPage({
  required String name,
  required GetPageBuilder page,
}) {
  return GetPage(
    name: name,
    page: page,
    transition: Transition.noTransition,
    transitionDuration: Duration(milliseconds: AppRoutes.duration),
  );
}

// for argument pass route
GetPage dynamicArgumentPage({
  required String name,
  required Widget Function(dynamic args) pageBuilder,
}) {
  return GetPage(
    name: name,
    page: () => pageBuilder(Get.arguments),
    transition: Transition.noTransition,
    transitionDuration: Duration(milliseconds: AppRoutes.duration),
  );
}