
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class AppColors {
  static const Color primary = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFF26C6DA);
  static const Color bg = Color(0xFFF4F7FB);

  /// Primary Gradient (Main Brand)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF1E88E5),
      Color(0xFF26C6DA),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Optional alias
  static const LinearGradient gradient = primaryGradient;
}