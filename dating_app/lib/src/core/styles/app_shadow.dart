import 'package:dating_now/src/core/styles/app_color.dart';
import 'package:flutter/material.dart';

class AppBoxShadows {
  static final List<BoxShadow> red = [
    BoxShadow(
      color: AppColors.red.withOpacity(0.2),
      offset: const Offset(0, 15),
      blurRadius: 15,
    )
  ];

  static List<BoxShadow> black = [
    BoxShadow(
      color: AppColors.black.withOpacity(0.07),
      offset: const Offset(0, 50),
      blurRadius: 20,
    )
  ];

  static List<BoxShadow> orange = [
    BoxShadow(
      color: AppColors.orange.withOpacity(0.2),
      offset: const Offset(0, 15),
      blurRadius: 15,
    ),
  ];

  static List<BoxShadow> purple = [
    BoxShadow(
      color: AppColors.purple.withOpacity(0.2),
      offset: const Offset(0, 15),
      blurRadius: 15,
    ),
  ];
}
