import 'package:dating_now/src/core/styles/app_color.dart';
import 'package:flutter/material.dart';

extension AppTextStyles on TextStyle {
  //Line Height = 1
  TextStyle lineHei1() => copyWith(height: 1);

  /// 34/150
  TextStyle h1() => copyWith(fontSize: 34, height: 34 / 150);

  /// 28/150
  TextStyle h2() => copyWith(fontSize: 28, height: 28 / 150);

  /// 24/150
  TextStyle h3() => copyWith(fontSize: 24, height: 24 / 150);

  /// 18/150
  TextStyle h4() => copyWith(fontSize: 18, height: 18 / 150);

  /// 16/150
  TextStyle h5() => copyWith(fontSize: 16, height: 16 / 150);

  /// 14/150
  TextStyle h6() => copyWith(fontSize: 14, height: 14 / 150);

  /// 12/150
  TextStyle h7() => copyWith(fontSize: 12, height: 12 / 150);

  // Font Weight
  TextStyle fw400() => copyWith(fontWeight: FontWeight.w400);

  TextStyle fw500() => copyWith(fontWeight: FontWeight.w500);

  TextStyle fw600() => copyWith(fontWeight: FontWeight.w600);

  TextStyle fw700() => copyWith(fontWeight: FontWeight.w700);

  TextStyle fw800() => copyWith(fontWeight: FontWeight.w800);

  // Font Color
  TextStyle fcW() => copyWith(color: AppColors.white);

  TextStyle fcR() => copyWith(color: AppColors.red);
}
