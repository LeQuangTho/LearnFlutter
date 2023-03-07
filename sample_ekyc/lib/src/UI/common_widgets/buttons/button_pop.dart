import 'package:flutter/material.dart';

import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';

import '../../../extentions/typedef.dart';

class ButtonPop extends StatelessWidget {
  const ButtonPop({
    Key? key,
    required this.buttonTitle,
    this.routeName,
  }) : super(key: key);
  final String buttonTitle;
  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        routeName != null ? AppNavigator.push(routeName!) : AppNavigator.pop();
      },
      child: Container(
        height: 48.px,
        decoration: BoxDecoration(
          color: ColorsPrimary.Lv2,
          borderRadius: BorderRadius.circular(24.px),
        ),
        child: Center(
          child: Text(
            buttonTitle,
            style: AppTextStyle.textStyle.s16().w500().cW5(),
          ),
        ),
      ),
    );
  }
}

class ButtonPop2 extends StatelessWidget {
  const ButtonPop2({
    Key? key,
    required this.buttonTitle,
    this.routeName,
    this.onTap,
    this.colorButton,
    this.colorText,
    this.height,
  }) : super(key: key);
  final String buttonTitle;
  final String? routeName;
  final Callback? onTap;
  final double? height;
  final Color? colorButton;
  final Color? colorText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            routeName != null
                ? AppNavigator.push(routeName!)
                : AppNavigator.pop();
          },
      child: Container(
        height: height ?? 56.px,
        decoration: BoxDecoration(
            color: colorButton ?? ColorsLight.Lv1,
            borderRadius: BorderRadius.circular(10.px),
            border: Border.all(color: colorButton ?? ColorsGray.Lv2)),
        child: Center(
          child: Text(
            buttonTitle,
            style: AppTextStyle.textStyle
                .s16()
                .w700()
                .cN5()
                .copyWith(color: colorText ?? null),
          ),
        ),
      ),
    );
  }
}
