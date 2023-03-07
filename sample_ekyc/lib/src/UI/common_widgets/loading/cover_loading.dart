import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../designs/app_themes/app_colors.dart';

class CoverLoading extends StatelessWidget {
  const CoverLoading({Key? key, this.size = 40}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingFour(
        size: size,
        color: ColorsPrimary.Lv1,
      ),
    );
  }
}
