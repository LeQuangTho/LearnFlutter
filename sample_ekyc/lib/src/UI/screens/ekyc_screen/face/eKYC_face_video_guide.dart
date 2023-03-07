import 'package:flutter/material.dart';

import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_background.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../widgets/guide_step.dart';

class EKYCFaceVideoGuide extends StatelessWidget {
  const EKYCFaceVideoGuide({
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
                      'Quay video khuôn mặt',
                      style: AppTextStyle.textStyle.s30().w700().cN5(),
                    ),
                    GuideSteps(
                      steps: [
                        'Giữ điện thoại ổn định và thẳng khuôn mặt.',
                        'Thực hiện quay qua trái/phải, nháy mắt, ngước lên/xuống.',
                        'Đảm bảo hình ảnh được quay trong điều kiện đầy đủ ánh sáng, rõ nét.'
                      ],
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                onTap: () {
                  AppNavigator.push(Routes.FACE_VALIDATION_VIEW);
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
