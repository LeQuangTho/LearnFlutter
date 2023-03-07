import 'package:flutter/material.dart';

import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_background.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';
import 'guide_step.dart';

class EKYCVerifyInfoGuide extends StatelessWidget {
  const EKYCVerifyInfoGuide({
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
                      'Quay video xác thực thông tin',
                      style: AppTextStyle.textStyle.s30().w700().cN5(),
                    ),
                    GuideSteps(
                      textSpan:
                          '\"Tôi xác nhận thông tin trên Chứng thư số là chính xác.\"',
                      steps: [
                        'Khách hàng quay video nói câu: textSpan',
                        'Đảm bảo video được quay trong điều kiện đầy đủ ánh sáng, rõ nét.',
                        'Đặt điện thoại ổn định và thẳng khuôn mặt.',
                      ],
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                onTap: () {
                  AppNavigator.push(Routes.EKYC_VERIFY_INFO_VIDEO);
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
