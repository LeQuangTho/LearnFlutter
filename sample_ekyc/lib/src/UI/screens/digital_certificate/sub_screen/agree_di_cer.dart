import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';
import 'package:hdsaison_signing/src/BLOC/user_remote/user_remote_bloc.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_assets_links.dart';

import '../../../../BLOC/ekyc/ekyc_bloc.dart';

import '../../../../BLOC/ekyc/models/ekyc_eform_response/ekyc_eform_response.dart';
import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/check_box/check_box.dart';
import '../../../common_widgets/loading/cover_loading.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';

class AgreeDiCer extends StatefulWidget {
  const AgreeDiCer({Key? key, required this.eform}) : super(key: key);
  final EkycEformCTSResponse eform;

  @override
  State<AgreeDiCer> createState() => _AgreeDiCerState();
}

class _AgreeDiCerState extends State<AgreeDiCer> {
  bool _isCheck = false;

  @override
  void initState() {
    super.initState();
    AppBlocs.userRemoteBloc.add(UserRemoteGetPDFeFormCTSEvent(
        PDFLink: widget.eform.data?.fileUrl ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Ký đơn đề nghị cấp CTS'),
      backgroundColor: ColorsGray.Lv3,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.px),
                  Text(
                    'Đơn đăng ký CTS',
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
                          'Vui lòng kiểm tra thông tin trên đơn và xác nhận đồng ý',
                          style: AppTextStyle.textStyle.s12().w400().cN4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.px),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        BlocBuilder<UserRemoteBloc, UserRemoteState>(
                          builder: (context, state) {
                            if (state is UserRemoteGetDoneData &&
                                state.PDFFilesEFormCTS != null) {
                              return Container(
                                child: PDFView(
                                  filePath: state.PDFFilesEFormCTS?.path,
                                  defaultPage: 0,
                                  fitPolicy: FitPolicy.BOTH,
                                  onError: (e) {},
                                ),
                              );
                            }
                            return CoverLoading();
                          },
                        ),
                        InkWell(
                          onTap: () {
                            AppNavigator.push(Routes.DETAIL_PDF_EFORM_CTS);
                          },
                          child: Container(
                            height: 42.px,
                            width: 125.px,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.px),
                              color: ColorsGray.Lv2,
                            ),
                            child: Center(
                              child: Text(
                                'Xem chi tiết',
                                style:
                                    AppTextStyle.textStyle.s16().w700().cN5(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.px),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.px, 16.px, 20.px, 0.px),
            color: ColorsLight.Lv1,
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.px, vertical: 8.px),
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorsGray.Lv2),
                      borderRadius: BorderRadius.circular(6.px),
                      color: _isCheck ? ColorsSuccess.Lv5 : null),
                  child: Row(
                    children: [
                      CheckBoxCustom(
                        isChecked: _isCheck,
                        onPress: (v) {
                          setState(() {
                            _isCheck = !_isCheck;
                          });
                        },
                      ),
                      Flexible(
                        child: Text(
                          'Tôi đồng ý chấp thuận đăng ký sử dụng chứng thư số',
                          style: AppTextStyle.textStyle.s16().w400().cN5(),
                        ),
                      )
                    ],
                  ),
                ),
                ButtonPrimary(
                  onTap: () {
                    AppBlocs.ekycBloc.add(EkycConfirmEformRequestDiCerEvent(
                        documentCode: widget.eform.data?.documentCode ?? ''));
                  },
                  content: 'Ký đơn',
                  enable: _isCheck,
                  padding: EdgeInsets.only(top: 8.px, bottom: 24.px),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
