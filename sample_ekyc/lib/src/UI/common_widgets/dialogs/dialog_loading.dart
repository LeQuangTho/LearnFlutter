import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/loading/cover_loading.dart';

import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

class DialogLoading extends StatelessWidget {
  const DialogLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 100.w,
      color: ColorsDark.Lv1.withOpacity(0.4),
      child: CoverLoading(),
    );
  }
}
