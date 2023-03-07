import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../designs/app_themes/app_assets_links.dart';

class ButtonTickPrimary extends StatelessWidget {
  const ButtonTickPrimary({
    Key? key,
    required this.onTap,
    required this.isChecked,
    this.secondaryIcon,
  }) : super(key: key);
  final Function() onTap;
  final bool isChecked;
  final String? secondaryIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 24.px,
        width: 24.px,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            8.px,
          ),
          color: isChecked ? ColorsSuccess.Lv1 : Colors.transparent,
          border: Border.all(
            color: isChecked ? ColorsSuccess.Lv1 : ColorsNeutral.Lv4,
            width: 1.5.px,
          ),
        ),
        child: Center(
          child: (isChecked)
              ? SvgPicture.asset(
                  secondaryIcon ?? AppAssetsLinks.ic_tick,
                  width: 10.px,
                  height: 10.px,
                  fit: BoxFit.scaleDown,
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
