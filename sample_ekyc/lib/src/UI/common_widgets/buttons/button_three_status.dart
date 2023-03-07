import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../designs/app_themes/app_assets_links.dart';

enum ThreeStatus {
  emptySelected,
  slected,
  slectedAll,
}

class ButtonThreeStatusPrimary extends StatelessWidget {
  const ButtonThreeStatusPrimary({
    Key? key,
    required this.onTap,
    required this.status,
  }) : super(key: key);
  final Function() onTap;
  final ThreeStatus status;

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
          color: (status != ThreeStatus.emptySelected)
              ? ColorsSuccess.Lv1
              : Colors.transparent,
          border: Border.all(
            color: (status != ThreeStatus.emptySelected)
                ? ColorsSuccess.Lv1
                : ColorsNeutral.Lv4,
            width: 1.5.px,
          ),
        ),
        child: Center(
          child: _buildIcon(status),
        ),
      ),
    );
  }

  Widget _buildIcon(ThreeStatus status) {
    switch (status) {
      case ThreeStatus.emptySelected:
        return SizedBox();
      case ThreeStatus.slected:
        return SvgPicture.asset(
          AppAssetsLinks.ic_tick_subtract,
          width: 10.px,
          height: 10.px,
          fit: BoxFit.scaleDown,
        );
      case ThreeStatus.slectedAll:
        return SvgPicture.asset(
          AppAssetsLinks.ic_tick,
          width: 10.px,
          height: 10.px,
          fit: BoxFit.scaleDown,
        );
    }
  }
}
