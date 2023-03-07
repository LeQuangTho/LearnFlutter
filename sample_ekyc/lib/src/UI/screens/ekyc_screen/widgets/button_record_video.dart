import 'package:flutter/material.dart';

import '../../../../extentions/typedef.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/sizer_custom/sizer.dart';

class ButtonRecordVideo extends StatelessWidget {
  const ButtonRecordVideo({Key? key, required this.step, required this.onTap})
      : super(key: key);
  final int step;
  final Callback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 66.px,
        height: 66.px,
        decoration: BoxDecoration(
          color: ColorsPrimary.Lv5,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: step == 2
              ? Container(
                  width: 60.px,
                  height: 60.px,
                  decoration: BoxDecoration(
                    color: ColorsLight.Lv1,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 36.px,
                      height: 36.px,
                      decoration: BoxDecoration(
                        color: ColorsPrimary.Lv1,
                        borderRadius: BorderRadius.circular(8.px),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 60.px,
                  height: 60.px,
                  decoration: BoxDecoration(
                    color: ColorsPrimary.Lv1,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4.px,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
