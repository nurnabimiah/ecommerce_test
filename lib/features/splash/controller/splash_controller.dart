


import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';



class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;



  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    scaleAnimation = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutBack));

    fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn));

    slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    animationController.forward();

    Future.delayed(const Duration(seconds: 3), () async {
      bool done = await onboardingController.isOnboardingCompleted();

      if (done) {
        Get.offAllNamed(LandingScreen.routeName);
      } else {
        Get.offAllNamed(OnboardingScreen.routeName);
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
