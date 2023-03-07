import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';

class ButtonTickSecondary extends StatelessWidget {
  const ButtonTickSecondary({
    Key? key,
    required this.onTap,
    this.isChecked,
  }) : super(key: key);
  final Function() onTap;
  final bool? isChecked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20.px,
        width: 20.px,
        decoration: BoxDecoration(
          color: ColorsSuccess.Lv1,
          borderRadius: BorderRadius.circular(6.px),
        ),
        child: Center(
          child: (isChecked ?? true)
              ? SvgPicture.asset(
                  AppAssetsLinks.ic_tick,
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
