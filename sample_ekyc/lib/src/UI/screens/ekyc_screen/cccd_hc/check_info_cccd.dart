import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/helpers/date_time_helper.dart';

import '../../../../BLOC/ekyc/models/detail_ocr_response/detail_ocr_response.dart';
import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../../user_profile/sub_screens/user_info_screen.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';

class CheckInfoCccd extends StatefulWidget {
  const CheckInfoCccd({Key? key, this.detailOcr}) : super(key: key);

  final DetailOcrResponse? detailOcr;

  @override
  State<CheckInfoCccd> createState() => _CheckInfoCccdState();
}

class _CheckInfoCccdState extends State<CheckInfoCccd> {
  @override
  void initState() {
    super.initState();
    if (widget.detailOcr != null) {
      AppConfig().eKycSessionInfor.name = widget.detailOcr?.data?.fullName ?? 'None'; // Tên
      AppConfig().eKycSessionInfor.dateOfBirth = dateTimeFormat3(widget.detailOcr?.data?.birthday ?? '', 'dd-MM-yyyy'); // Ngày sinh
      AppConfig().eKycSessionInfor.idNumber = widget.detailOcr?.data?.identityNumber ?? 'None'; // CMND
      AppConfig().eKycSessionInfor.placeOfOrigin = widget.detailOcr?.data?.placeOfOrigin ?? 'None';  // Nguyên quán
      AppConfig().eKycSessionInfor.placeOfResidence = widget.detailOcr?.data?.placeOfResidence ?? 'None'; // Thường trú
      AppConfig().eKycSessionInfor.dateOfExpiry = dateTimeFormat3(widget.detailOcr?.data?.expireDate ?? '', 'dd-MM-yyyy'); // Ngày hết hạn
      AppConfig().eKycSessionInfor.dateOfIssue = dateTimeFormat3(widget.detailOcr?.data?.issueDate ?? '', 'dd-MM-yyyy'); // Ngày cấp
      AppConfig().eKycSessionInfor.sex = widget.detailOcr?.data?.sex == 1 ? 'Nam' : widget.detailOcr?.data?.sex == 2 ? 'Nữ' : 'Khác'; // Giới tính
      AppConfig().eKycSessionInfor.nation = widget.detailOcr?.data?.nation ?? ''; // Quốc tịch
      AppConfig().eKycSessionInfor.issuedAt = widget.detailOcr?.data?.issueBy ?? 'None'; // Nơi cấp
      AppConfig().sdkCallback?.ekycResult(
          true,
          true,
          "",
          "",
          AppConfig().eKycSessionInfor.matchingDetail,
          AppConfig().eKycSessionInfor.name,
          AppConfig().eKycSessionInfor.dateOfBirth,
          AppConfig().eKycSessionInfor.idNumber,
          AppConfig().eKycSessionInfor.placeOfOrigin,
          AppConfig().eKycSessionInfor.placeOfResidence,
          AppConfig().eKycSessionInfor.dateOfExpiry,
          AppConfig().eKycSessionInfor.dateOfIssue,
          AppConfig().eKycSessionInfor.sex,
          AppConfig().eKycSessionInfor.ethnicity,
          AppConfig().eKycSessionInfor.personalIdentification,
          AppConfig().eKycSessionInfor.nation,
          AppConfig().eKycSessionInfor.issuedAt);
    } else {
      if (AppConfig().eKycSessionInfor.isValid) {
        if (AppConfig().sdkCallback != null) {
          AppConfig().sdkCallback!.ekycResult(
              true,
              true,
              "",
              "",
              AppConfig().eKycSessionInfor.matchingDetail,
              AppConfig().eKycSessionInfor.name,
              AppConfig().eKycSessionInfor.dateOfBirth,
              AppConfig().eKycSessionInfor.idNumber,
              AppConfig().eKycSessionInfor.placeOfOrigin,
              AppConfig().eKycSessionInfor.placeOfResidence,
              AppConfig().eKycSessionInfor.dateOfExpiry,
              AppConfig().eKycSessionInfor.dateOfIssue,
              AppConfig().eKycSessionInfor.sex,
              AppConfig().eKycSessionInfor.ethnicity,
              AppConfig().eKycSessionInfor.personalIdentification,
              AppConfig().eKycSessionInfor.nation,
              AppConfig().eKycSessionInfor.issuedAt);
        }
      } else {
        if (AppConfig().sdkCallback != null) {
          AppConfig().sdkCallback!.ekycResult(
              true,
              false,
              "erro",
              "Ekyc thất bại",
              0,
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Kiểm tra thông tin'),
      backgroundColor: ColorsGray.Lv3,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.px),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.px),
                    Text(
                      'Kiểm tra thông tin cá nhân',
                      style: AppTextStyle.textStyle.s24().w700().cN5(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.px),
                    Row(
                      children: [
                        SvgPicture.asset(AppAssetsLinks.ic_danger),
                        SizedBox(width: 8.px),
                        Expanded(
                          child: Text(
                            'Hãy chắc chắn những thông tin bên dưới trùng khớp với thông tin trên CMND/CCCD',
                            style: AppTextStyle.textStyle.s12().w400().cN4(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.px),
                    ContainerInfo(
                      list: [
                        InfoField(
                          first: true,
                          title: 'HỌ VÀ TÊN',
                          content: AppConfig().eKycSessionInfor.name,
                        ),
                        InfoField(
                          title: 'NGÀY SINH',
                          content: AppConfig().eKycSessionInfor.dateOfBirth,
                        ),
                        InfoField(
                          title: 'GIỚI TÍNH',
                          content: AppConfig().eKycSessionInfor.sex == "None"
                              ? ""
                              : AppConfig().eKycSessionInfor.sex,
                        ),
                        InfoField(
                          title: 'SỐ CMND/CCCD/Hộ chiếu',
                          content: AppConfig().eKycSessionInfor.idNumber,
                        ),
                        InfoField(
                          title: 'NGÀY CẤP',
                          content: AppConfig().eKycSessionInfor.dateOfIssue,
                        ),
                        InfoField(
                          title: 'CÓ GIÁ TRỊ ĐẾN',
                          content: AppConfig().eKycSessionInfor.dateOfExpiry ==
                                  "None"
                              ? ''
                              : AppConfig().eKycSessionInfor.dateOfExpiry,
                        ),
                        InfoField(
                          title: 'NƠI CẤP',
                          content: AppConfig().eKycSessionInfor.issuedAt,
                        ),
                        InfoField(
                          title: 'NƠI THƯỜNG TRÚ',
                          content:
                              AppConfig().eKycSessionInfor.placeOfResidence,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ButtonPrimary(
              onTap: () {
                AppNavigator.push(Routes.EKYC_FACE_VIDEO_GUIDE);
              },
              content: 'Tiếp tục',
              padding: EdgeInsets.only(top: 8.px, bottom: 24.px),
            )
          ],
        ),
      ),
    );
  }
}
