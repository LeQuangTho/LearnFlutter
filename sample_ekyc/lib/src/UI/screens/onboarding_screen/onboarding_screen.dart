import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';
import 'package:hdsaison_signing/src/BLOC/authentication/authentication_bloc.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/buttons/button_primary.dart';

import 'package:hdsaison_signing/src/UI/designs/app_themes/app_assets_links.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';

import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/UI/screens/onboarding_screen/onboarding_page.dart';
import 'package:hdsaison_signing/src/configs/languages/localization.dart';

import '../../../navigations/app_pages.dart';
import '../../../navigations/app_routes.dart';
import '../../designs/layouts/splash_layout.dart';
import 'package:hdsaison_signing/src/constants/hard_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  int _currentPageNum = 0;

  Widget _indicator(bool isActive) {
    return Container(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 8),
        height: isActive ? 10 : 8.0,
        width: isActive ? 10 : 8.0,
        decoration: BoxDecoration(
          border: Border.all(color: ColorsGray.Lv2),
          shape: BoxShape.circle,
          color: isActive ? ColorsNeutral.Lv1 : Colors.transparent,
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 4; i++) {
      list.add(i == _currentPageNum ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    AppBlocs.authenticationBloc.add(FirstOpenAppEvent(isOpenedApp: true));
  }

  @override
  Widget build(BuildContext context) {
    return SplashLayout(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (num) {
                setState(() {
                  _currentPageNum = num;
                });
              },
              children: [
                OnboardingPage(
                  image: AppAssetsLinks.onboarding_welcome,
                  title: 'Chào mừng',
                  desc:
                      'Chào mừng bạn đến với $UNIT_NAME_CAP eSign\nỨng dụng ký Hợp đồng điện tử nhanh chóng và tiện lợi.',
                ),
                OnboardingPage(
                  image: AppAssetsLinks.onboarding_easy,
                  title: StringKey.titleSplash1.tr,
                  desc:
                      'Thao tác trực tuyến.\nThủ tục nhanh chóng, dễ dàng và minh bạch.',
                ),
                OnboardingPage(
                  image: AppAssetsLinks.onboarding_safe,
                  title: StringKey.titleSplash2.tr,
                  desc:
                      'Bảo mật dữ liệu và đảm bảo quyền riêng tư của khách hàng là ưu tiên hàng đầu.',
                ),
                OnboardingPage(
                  image: AppAssetsLinks.onboarding_effective,
                  title: StringKey.titleSplash3.tr,
                  desc:
                      'Nhận thông báo qua số điện thoại\nDuyệt vay nhanh trong vòng 30 phút.',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 38.px,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicator(),
          ),
          _buildButton(_currentPageNum == 3),
        ],
      ),
    );
  }

  Widget _buildButton(bool isLastPage) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 24.px),
      child: isLastPage
          ? ButtonPrimary(
              padding: EdgeInsets.zero,
              onTap: () {
                AppNavigator.pushNamedAndRemoveUntil(Routes.PRELOGIN);
              },
              content: StringKey.joinNow.tr,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 56.px,
                  width: 85.px,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.px),
                      border: Border.all(color: ColorsGray.Lv2)),
                  child: TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(ColorsNeutral.Lv1)),
                    child: Text(StringKey.skipButton.tr),
                    onPressed: () {
                      AppNavigator.pushNamedAndRemoveUntil(Routes.PRELOGIN);
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentPageNum++;
                    });
                    _controller.animateToPage(
                      _currentPageNum,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Container(
                    height: 56.px,
                    width: 56.px,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.px),
                      border: Border.all(color: ColorsGray.Lv2),
                      color: ColorsPrimary.Lv1,
                    ),
                    child: Icon(
                      Icons.navigate_next,
                      color: ColorsLight.Lv1,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
