import 'package:flutter/material.dart';

import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_background.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../widgets/guide_step.dart';

class EKYCCccdGuideVideo extends StatelessWidget {
  const EKYCCccdGuideVideo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundStack(
      child: Scaffold(
        appBar: MyAppBar(''),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.px),
                    Text(
                      'Quay video giấy tờ',
                      style: AppTextStyle.textStyle.s30().w700().cN5(),
                    ),
                    GuideSteps(
                      steps: [
                        'Vui lòng đặt giấy tờ vào giữa khung hình, không bị mất góc.',
                        'Quay đủ 2 mặt giấy tờ theo thứ tự: mặt trước -> mặt sau trong điều kiện ánh sáng rõ nét.',
                        'Lật qua lại: nghiêng trước, nghiêng sau, nghiêng trái, nghiêng phải.'
                      ],
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                onTap: () {
                  AppNavigator.push(Routes.EKYC_CCCD_VIDEO);
                },
                content: 'Tiếp tục',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
