import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../../user_profile/sub_screens/user_info_screen.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';


class EKYCOCRSuccess extends StatelessWidget {
  const EKYCOCRSuccess({Key? key}) : super(key: key);

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
                        'Vui lòng kiểm tra lại thông tin bên dưới',
                        style: AppTextStyle.textStyle.s16().w400().cN4(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.px),
                      ContainerInfo(
                        list: [
                          Text(
                            'THÔNG TIN GIẤY TỜ TÙY THÂN',
                            style: AppTextStyle.textStyle.s16().w700().cN5(),
                          ),
                          InfoField(
                            title: 'Họ và tên',
                            content: AppConfig().eKycSessionInfor.name,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InfoField(
                                  title: 'Ngày sinh',
                                  content: AppConfig().eKycSessionInfor.dateOfBirth,
                                ),
                              ),
                              Expanded(
                                child: InfoField(
                                  title: 'Giới tính',
                                  content: AppConfig().eKycSessionInfor.sex,
                                ),
                              ),
                            ],
                          ),
                          InfoField(
                            title: 'Số CCCD/CMND/HỘ CHIẾU',
                            content: AppConfig().eKycSessionInfor.idNumber,
                          ),
                          InfoField(
                            title: 'Nguyên quán',
                            content: 'Hà Nội',
                          ),
                          InfoField(
                            title: 'Nơi đăng ký HKTT',
                            content: AppConfig().eKycSessionInfor.placeOfResidence,
                          ),
                          InfoField(
                            title: 'Ngày cấp',
                            content:  AppConfig().eKycSessionInfor.dateOfIssue,
                          ),
                          InfoField(
                            title: 'Nơi cấp',
                            content:  AppConfig().eKycSessionInfor.placeOfOrigin,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.px),
                    ],
                  ),
                ),
              ),
              ButtonPrimary(
                onTap: () {
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
