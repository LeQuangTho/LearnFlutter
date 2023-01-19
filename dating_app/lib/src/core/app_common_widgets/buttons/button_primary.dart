import 'dart:async';

import 'package:dating_now/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TypeButtonPrimary { none, light, border }

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({
    Key? key,
    this.content,
    this.onTap,
    this.type = TypeButtonPrimary.none,
    this.contentStyle,
    this.shape,
  }) : super(key: key);

  final String? content;
  final FutureOr<void> Function()? onTap;
  final TypeButtonPrimary type;
  final TextStyle? contentStyle;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: RawMaterialButton(
        padding: EdgeInsets.all(18.w),
        onPressed: onTap,
        fillColor: _getFillColor(),
        elevation: _getElevation(),
        hoverElevation: _getHoverElevation(),
        highlightColor: AppColors.red.withOpacity(0.1),
        highlightElevation: _getElevationHighlight(),
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
              side: _getBorderSide(),
            ),
        child: Center(
          child: Text(
            content ?? '',
            style: contentStyle ?? _getTextStyle(),
          ),
        ),
      ),
    );
  }

  Color _getFillColor() {
    switch (type) {
      case TypeButtonPrimary.none:
        return AppColors.red;
      case TypeButtonPrimary.light:
        return AppColors.red.withOpacity(0.1);
      case TypeButtonPrimary.border:
        return AppColors.white;
    }
  }

  TextStyle _getTextStyle() {
    switch (type) {
      case TypeButtonPrimary.none:
        return TextStyle().h5().fw700().fcW().lineHei1();
      case TypeButtonPrimary.border:
      case TypeButtonPrimary.light:
        return TextStyle().h5().fw700().fcR().lineHei1();
    }
  }

  BorderSide _getBorderSide() {
    switch (type) {
      case TypeButtonPrimary.none:
      case TypeButtonPrimary.light:
        return BorderSide.none;
      case TypeButtonPrimary.border:
        return BorderSide(
          color: AppColors.border,
        );
    }
  }

  double _getElevation() {
    switch (type) {
      case TypeButtonPrimary.border:
      case TypeButtonPrimary.light:
        return 0;
      case TypeButtonPrimary.none:
        return 2;
    }
  }

  double _getHoverElevation() {
    switch (type) {
      case TypeButtonPrimary.border:
      case TypeButtonPrimary.light:
        return 0;
      case TypeButtonPrimary.none:
        return 4;
    }
  }

  double _getElevationHighlight() {
    switch (type) {
      case TypeButtonPrimary.border:
      case TypeButtonPrimary.light:
        return 0;
      case TypeButtonPrimary.none:
        return 8;
    }
  }
}
