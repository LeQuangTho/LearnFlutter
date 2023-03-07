// ignore_for_file: avoid_classes_with_only_static_members, unnecessary_this

import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import 'app_colors.dart';

class AppTextStyle {
  static TextStyle textStyle = const TextStyle();
}

extension ConfigStyle on TextStyle {
  TextStyle s40() {
    return this.copyWith(fontSize: 40.px);
  }

  TextStyle s28() {
    return this.copyWith(fontSize: 28.px);
  }

  TextStyle s30() {
    return this.copyWith(fontSize: 30.px);
  }

  TextStyle s24() {
    return this.copyWith(fontSize: 24.px);
  }

  TextStyle s20() {
    return this.copyWith(fontSize: 20.px);
  }

  TextStyle s16() {
    return this.copyWith(fontSize: 16.px);
  }

  TextStyle s14() {
    return this.copyWith(fontSize: 14.px);
  }

  TextStyle s12() {
    return this.copyWith(fontSize: 12.px);
  }

  TextStyle s10() {
    return this.copyWith(fontSize: 10.px);
  }

  TextStyle s9() {
    return this.copyWith(fontSize: 9.px);
  }

  TextStyle w300() {
    return this.copyWith(fontWeight: FontWeight.w300);
  }

  TextStyle w400() {
    return this.copyWith(fontWeight: FontWeight.w400);
  }

  TextStyle w500() {
    return this.copyWith(fontWeight: FontWeight.w500);
  }

  TextStyle w600() {
    return this.copyWith(fontWeight: FontWeight.w600);
  }

  TextStyle w700() {
    return this.copyWith(fontWeight: FontWeight.w700);
  }

  TextStyle cW0() {
    return this.copyWith(color: ColorsWhite.Lv6);
  }

  TextStyle cW1() {
    return this.copyWith(color: ColorsWhite.Lv5);
  }

  TextStyle cW2() {
    return this.copyWith(color: ColorsWhite.Lv4);
  }

  TextStyle cW3() {
    return this.copyWith(color: ColorsWhite.Lv3);
  }

  TextStyle cW4() {
    return this.copyWith(color: ColorsWhite.Lv2);
  }

  TextStyle cW5() {
    return this.copyWith(color: ColorsWhite.Lv1);
  }

  TextStyle cR5() {
    return this.copyWith(color: ColorsRed.Lv1);
  }

  TextStyle cI1() {
    return this.copyWith(color: ColorsIndigo.Lv5);
  }

  TextStyle cN0() {
    return this.copyWith(color: ColorsNeutral.Lv5);
  }

  TextStyle cN1() {
    return this.copyWith(color: ColorsNeutral.Lv5);
  }

  TextStyle cN2() {
    return this.copyWith(color: ColorsNeutral.Lv4);
  }

  TextStyle cN3() {
    return this.copyWith(color: ColorsNeutral.Lv3);
  }

  TextStyle cN4() {
    return this.copyWith(color: ColorsNeutral.Lv2);
  }

  TextStyle cN5() {
    return this.copyWith(color: ColorsNeutral.Lv1);
  }

  TextStyle cG5() {
    return this.copyWith(color: ColorsSuccess.Lv1);
  }

  TextStyle cP2() {
    return this.copyWith(color: ColorsPrimary.Lv4);
  }

  TextStyle cP3() {
    return this.copyWith(color: ColorsPrimary.Lv3);
  }

  TextStyle cP4() {
    return this.copyWith(color: ColorsPrimary.Lv2);
  }

  TextStyle cP5() {
    return this.copyWith(color: ColorsPrimary.Lv1);
  }

  TextStyle cY5() {
    return this.copyWith(color: ColorsYellow.Y5);
  }

  TextStyle cDisable() {
    return this.copyWith(color: ColorsWhite.Lv1);
  }

  TextStyle inActive() {
    return this
        .copyWith(color: ColorsSupport.resendActivateEmailInDurationColor);
  }

  TextStyle cD1() {
    return this.copyWith(color: ColorsDark.Lv1);
  }

  TextStyle underline() {
    return this.copyWith(decoration: TextDecoration.underline);
  }

  TextStyle cWarn1() {
    return this.copyWith(color: ColorsWarn.Lv1);
  }
}
