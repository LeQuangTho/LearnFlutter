import 'package:flutter/material.dart';

import '../../designs/app_themes/app_colors.dart';
import '../../designs/sizer_custom/sizer.dart';

class ObscursingWidget extends StatelessWidget {
  const ObscursingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 10.px,
        width: 10.px,
        decoration: BoxDecoration(color: ColorsNeutral.Lv1),
      ),
    );
  }
}
