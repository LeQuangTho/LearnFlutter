import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';

import '../../../../BLOC/ekyc/ekyc_bloc.dart';
import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../designs/app_background.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../../home_screen/widgets/button_home.dart';

class VerifyOcrMethod extends StatelessWidget {
  const VerifyOcrMethod({Key? key}) : super(key: key);

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
                      'Xác thực giấy tờ',
                      style: AppTextStyle.textStyle.s30().w700().cN5(),
                    ),
                    SizedBox(height: 4.px),
                    Text(
                      'Bạn vui lòng chọn 1 hình thức sử dụng thông tin giấy tờ để xác thực.',
                      style: AppTextStyle.textStyle.s16().w400().cN4(),
                    ),
                    SizedBox(height: 32.px),
                    ButtonHome.shadow(
                      title: 'Sử dụng giấy tờ đã xác thực',
                      icon: AppAssetsLinks.identity_doc,
                      onTap: () {
                        AppBlocs.ekycBloc.add(EkycGetOcrInfo());
                      },
                    ),
                    SizedBox(height: 8.px),
                    ButtonHome.shadow(
                      title: 'Xác thực giấy tờ mới',
                      icon: AppAssetsLinks.identity_doc,
                      onTap: () {
                        AppNavigator.push(Routes.EKYC_VERIFY_PICTURE);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
