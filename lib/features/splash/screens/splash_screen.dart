
import 'package:eommerce_test/utils/app_constans/app_constans.dart';
import 'package:eommerce_test/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash_screen';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: controller.animationController,
          builder: (_, child) {
            return FadeTransition(
              opacity: controller.fadeAnimation,
              child: SlideTransition(
                position: controller.slideAnimation,
                child: ScaleTransition(
                  scale: controller.scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.splashImage,
                height: 180.h,
                width: 180.w,
              ),
              Text(AppConstants.appName,style: TextStyle(fontSize: 24.sp,fontWeight: FontWeight.w600),)
            ],
          ),
        ),
      ),
    );
  }
}