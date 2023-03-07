import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../sizer_custom/sizer.dart';
import 'app_colors.dart';

class AppThemes {
  static PinTheme pinThemeValid({required bool isError}) => PinTheme(
        fieldWidth: 48.px,
        fieldHeight: 48.px,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10.px),
        borderWidth: 1,
        activeFillColor: isError ? ColorsWarn.Lv5 : ColorsGray.Lv3,
        disabledColor: ColorsGray.Lv3,
        inactiveFillColor: ColorsGray.Lv3,
        selectedColor: ColorsSuccess.Lv1,
        inactiveColor: ColorsGray.Lv2,
        selectedFillColor: ColorsGray.Lv3,
        activeColor: isError ? ColorsWarn.Lv2 : ColorsGray.Lv2,
      );

  static PinTheme pinThemeNotValid({bool readOnly = false}) => PinTheme(
        fieldWidth: 48.px,
        fieldHeight: 48.px,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10.px),
        borderWidth: 1,
        activeFillColor: ColorsGray.Lv3,
        disabledColor: ColorsGray.Lv3,
        inactiveFillColor: ColorsGray.Lv3,
        selectedColor: readOnly ? ColorsGray.Lv2 : ColorsSuccess.Lv1,
        inactiveColor: ColorsGray.Lv2,
        selectedFillColor: ColorsGray.Lv3,
        activeColor: ColorsGray.Lv2,
      );

  static PinTheme dotPinTheme({required TextEditingController controller}) =>
      PinTheme(
        fieldWidth: 16.px,
        fieldHeight: 16.px,
        shape: PinCodeFieldShape.circle,
        borderRadius: BorderRadius.circular(4.px),
        borderWidth: 0,
        activeFillColor: ColorsSuccess.Lv1,
        disabledColor: ColorsGray.Lv2,
        inactiveFillColor: ColorsGray.Lv3,
        selectedColor: ColorsGray.Lv2,
        inactiveColor: ColorsGray.Lv2,
        selectedFillColor:
            controller.text.isEmpty ? ColorsGray.Lv3 : ColorsSuccess.Lv1,
        activeColor: ColorsSuccess.Lv1,
      );
}
