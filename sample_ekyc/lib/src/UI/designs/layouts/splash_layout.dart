import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';

import '../../../extentions/typedef.dart';
import '../app_themes/app_assets_links.dart';
import '../app_themes/app_colors.dart';
import '../sizer_custom/sizer.dart';

class SplashLayout extends StatelessWidget {
  final Widget body;
  final bool appbarEnable;
  final bool trailingIcon;
  final String appbarTitle;
  final bool plainBackground;
  final String customBackground;
  final Callback customBackButton;
  final Callback customTrailButton;
  final Color customBottomHomeSafeColor;
  final MainAxisAlignment? mainAxisAlignment;

  SplashLayout({
    required this.body,
    this.appbarEnable = true,
    this.trailingIcon = false,
    this.plainBackground = true,
    this.appbarTitle = '',
    this.customBackButton = backDefault,
    this.customTrailButton = trailedDefault,
    this.customBottomHomeSafeColor = ColorsNeutral.Lv1,
    this.customBackground = '',
    this.mainAxisAlignment,
  });

  static backDefault() {
    AppNavigator.pop();
  }

  static trailedDefault() {}

  PreferredSizeWidget? _appBarCommon() {
    if (appbarTitle != '' || appbarEnable) {
      return PreferredSize(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.px, 50.px, 20.px, 0),
          child: Container(
            child: Row(
              mainAxisAlignment:
                  mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  AppAssetsLinks.logo_hdsaison,
                  height: 24,
                  width: 24,
                ),
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(kToolbarHeight),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFFFFF),
              const Color(0xFFFFFFFF),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
          boxShadow: customBackground == '' ? [] : [],
        ),
        child: Scaffold(
          appBar: _appBarCommon(),
          body: AppBackGroundStack(
            plainBackground: plainBackground,
            child: SafeArea(
              bottom: false,
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}

class AppBackGroundStack extends StatelessWidget {
  AppBackGroundStack({
    required this.child,
    this.plainBackground = true,
    this.customBackground = AppAssetsLinks.BACKGROUND,
  });

  final Widget child;
  final bool plainBackground;
  final String customBackground;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (plainBackground)
          Container(color: ColorsWhite.Lv1)
        else
          Image.asset(
            customBackground,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        SafeArea(
          bottom: false,
          child: child,
        )
      ],
    );
  }
}

class CommonTextStyle {
  static TextStyle textStyle = TextStyle(
    fontSize: 14,
  );
}
