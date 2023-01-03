import 'package:flutter/material.dart';

extension AppTextStyles on TextStyle {
  /// 32/40
  TextStyle h1() => copyWith(fontSize: 32, height: 40 / 32);

  /// 24/32
  TextStyle h2() => copyWith(fontSize: 24, height: 32 / 24);

  /// 20/28
  TextStyle h3() => copyWith(fontSize: 20, height: 28 / 20);

  /// 16/24
  TextStyle paragraph() => copyWith(fontSize: 16, height: 24 / 16);

  /// 16/20
  TextStyle body() => copyWith(fontSize: 16, height: 20 / 16);

  /// 14/20
  TextStyle paragraphSmall() => copyWith(fontSize: 14, height: 20 / 14);

  /// 14/16
  TextStyle small() => copyWith(fontSize: 14, height: 16 / 14);

  /// 12/16
  TextStyle xSmall() => copyWith(fontSize: 12, height: 16 / 12);

  /// 10/16
  TextStyle tiny() => copyWith(fontSize: 10, height: 16 / 10);

  /// 10/12
  TextStyle mTiny() => copyWith(fontSize: 10, height: 12 / 10);

  // Font Weight
  TextStyle fw400() => copyWith(fontWeight: FontWeight.w400);

  TextStyle fw500() => copyWith(fontWeight: FontWeight.w500);

  TextStyle fw600() => copyWith(fontWeight: FontWeight.w600);

  TextStyle fw700() => copyWith(fontWeight: FontWeight.w700);

  TextStyle fw800() => copyWith(fontWeight: FontWeight.w800);

// Font Color
// TextStyle fcR1() => copyWith(color: AppColors.R1);
//
// TextStyle fcR2() => copyWith(color: AppColors.R2);
//
// TextStyle fcR3() => copyWith(color: AppColors.R3);
}
