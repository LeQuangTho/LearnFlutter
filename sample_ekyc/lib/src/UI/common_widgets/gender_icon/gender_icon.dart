import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/sizer_custom/sizer.dart';

class GenderIcon extends StatelessWidget {
  const GenderIcon({
    Key? key,
    required this.active,
  }) : super(key: key);
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16.px,
      width: 16.px,
      child: SvgPicture.asset(
        active
            ? AppAssetsLinks.ic_gender_active
            : AppAssetsLinks.ic_gender_none,
        color: active ? ColorsPrimary.Lv1 : null,
      ),
    );
  }
}
