import 'dart:async';

import 'package:dating_now/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonPrimaryIcon extends StatelessWidget {
  const ButtonPrimaryIcon({
    Key? key,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  final Widget icon;
  final FutureOr<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.w,
      width: 64.w,
      child: RawMaterialButton(
        onPressed: onTap,
        highlightColor: AppColors.red.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
          side: BorderSide(color: AppColors.border),
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
