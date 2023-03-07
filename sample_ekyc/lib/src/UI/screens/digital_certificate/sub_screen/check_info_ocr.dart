import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/BLOC/ekyc/models/ekyc_eform_response/data.dart';

import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../../user_profile/sub_screens/user_info_screen.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';

class CheckInfoOCR extends StatelessWidget {
  final EkycEformCTSData? data;
  CheckInfoOCR({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssetsLinks.background_otp_sc,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: kToolbarHeight.px),
                      SvgPicture.asset(AppAssetsLinks.success),
                      SizedBox(height: 8.px),
                      Text(
                        'Xác nhận thông tin',
                        style: AppTextStyle.textStyle.s24().w700().cN5(),
                      ),
                      SizedBox(height: 8.px),
                      Text(
                        'Các thông tin này được sử dụng làm thông tin chứng thư số của bạn',
                        style: AppTextStyle.textStyle.s16().w400().cN4(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.px),
                      ContainerInfo(
                        list: [
                          Text(
                            'THÔNG TIN CHỨNG THƯ SỐ',
                            style: AppTextStyle.textStyle.s16().w700().cN5(),
                          ),
                          InfoField(
                            title: 'HỌ VÀ TÊN',
                            content: data?.name ?? '',
                          ),
                          InfoField(
                            title: 'SỐ CMND/CCCD/HỘ CHIẾU',
                            content: data?.identityNumber ?? '',
                          ),
                          InfoField(
                            title: 'TỈNH/THÀNH PHỐ',
                            content: AppConfig()
                                .eKycSessionInfor
                                .placeOfResidence
                                .split(',')
                                .last
                                .trim(),
                          ),
                          InfoField(
                            title: 'QUỐC GIA',
                            content: 'Việt Nam',
                          ),
                          InfoField(
                            title: 'THỜI HẠN SỬ DỤNG',
                            content: data?.timeCTS ?? '',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ButtonPrimary(
                onTap: () {
                  AppNavigator.push(Routes.EKYC_VERIFY_INFO_GUIDE);
                },
                content: 'Xác nhận',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
