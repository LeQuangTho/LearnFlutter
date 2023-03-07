import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hdsaison_signing/src/BLOC/user_remote/models/response/detail_cts_model.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/loading/cover_loading.dart';
import 'package:hdsaison_signing/src/extentions/type_extesions.dart';
import 'package:hdsaison_signing/src/helpers/date_time_helper.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/user_remote/models/response/digital_certificate_response.dart';
import '../../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../../helpers/untils/logger.dart';
import '../../../../navigations/app_pages.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../../user_profile/sub_screens/user_info_screen.dart';

class DetailDiCertificate extends StatefulWidget {
  const DetailDiCertificate({Key? key, required this.diCer}) : super(key: key);
  final DigitalCertificate diCer;
  @override
  State<DetailDiCertificate> createState() => _DetailDiCertificateState();
}

class _DetailDiCertificateState extends State<DetailDiCertificate> {
  @override
  void initState() {
    super.initState();
    UtilLogger.log('diCer', widget.diCer.id);
    AppBlocs.userRemoteBloc
        .add(UserRemoteGetDetailCTSEvent(idCTS: widget.diCer.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Thông tin chứng từ số'),
      backgroundColor: ColorsGray.Lv3,
      body: BlocBuilder<UserRemoteBloc, UserRemoteState>(
        builder: (context, state) {
          if (state is UserRemoteGetDoneData) {
            final cerInfo = state.detailCtsModel?.certificateInfo;
            final userInfo = AppBlocs.userRemoteBloc.userResponseDataEntry;
            return state.detailCtsModel != DetailCtsModel.empty
                ? Column(
                    children: [
                      Divider(height: 1),
                      Container(
                        height: 40.px,
                        color: ColorsLight.Lv1,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.px, vertical: 6.px),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Trạng thái',
                              style: AppTextStyle.textStyle.s16().w700().cN5(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: widget.diCer.status!
                                    ? ColorsSuccess.Lv5
                                    : ColorsPrimary.Lv5,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Text(
                                  widget.diCer.status!
                                      ? "ĐANG HOẠT ĐỘNG"
                                      : "HẾT HẠN",
                                  style: AppTextStyle.textStyle
                                      .s10()
                                      .w700()
                                      .copyWith(
                                        color: widget.diCer.status!
                                            ? ColorsSuccess.Lv1
                                            : ColorsPrimary.Lv1,
                                      )),
                            )
                          ],
                        ),
                      ),
                      Divider(height: 1),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.px),
                          child: Column(
                            children: [
                              SizedBox(height: 32.px),
                              ContainerInfo(
                                list: [
                                  InfoField(
                                    first: true,
                                    title: 'Họ và tên',
                                    content: cerInfo?.subjectName,
                                  ),
                                  InfoField(
                                    title: 'Số CCCD/CMND/HC',
                                    content: userInfo.identityNumber
                                        ?.replaceAll(
                                            RegExp(r'\d(?!\d{0,3}$)'), '*'),
                                  ),
                                  InfoField(
                                    title: 'Tỉnh/thành phố nơi sống/ làm việc',
                                    content:
                                        cerInfo?.issuer?.cutString(type: 'ST='),
                                  ),
                                  InfoField(
                                    title: 'Quốc gia',
                                    content:
                                        cerInfo?.issuer?.cutString(type: 'C='),
                                  ),
                                  InfoField(
                                    title: 'Serial chứng thư số',
                                    content: cerInfo?.serialNumber,
                                  ),
                                  InfoField(
                                    title: 'Tên tổ chức chứng thực',
                                    content:
                                        cerInfo?.issuer?.cutString(type: 'O='),
                                  ),
                                  InfoField(
                                    title: 'Thời gian hiệu lực',
                                    content: dateTimeFormat4(state
                                        .detailCtsModel!.validFrom
                                        .toString()),
                                  ),
                                  InfoField(
                                    title: 'Thời gian hết hiệu lực',
                                    content: dateTimeFormat4(state
                                        .detailCtsModel!.validTo
                                        .toString()),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      ButtonPrimary(
                        padding:
                            EdgeInsets.fromLTRB(20.px, 20.px, 20.px, 42.px),
                        onTap: () => AppNavigator.pop(),
                        content: 'Đóng',
                      )
                    ],
                  )
                : CoverLoading();
          }
          return CoverLoading();
        },
      ),
    );
  }
}
