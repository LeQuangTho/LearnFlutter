import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/user_remote/models/response/detail_cts_model.dart';
import '../../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../../extentions/type_extesions.dart';
import '../../../../helpers/date_time_helper.dart';
import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/loading/cover_loading.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../../user_profile/sub_screens/user_info_screen.dart';

class RegisterDiCerSuccess extends StatefulWidget {
  const RegisterDiCerSuccess({
    Key? key,
    required this.idCTS,
  }) : super(key: key);

  final String? idCTS;

  @override
  State<RegisterDiCerSuccess> createState() => _RegisterDiCerSuccessState();
}

class _RegisterDiCerSuccessState extends State<RegisterDiCerSuccess> {
  @override
  void initState() {
    super.initState();
    AppBlocs.userRemoteBloc
        .add(UserRemoteGetDetailCTSEvent(idCTS: widget.idCTS));
  }

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
                child: BlocBuilder<UserRemoteBloc, UserRemoteState>(
                  builder: (context, state) {
                    if (state is UserRemoteGetDoneData) {
                      final cerInfo = state.detailCtsModel?.certificateInfo;
                      final userInfo =
                          AppBlocs.userRemoteBloc.userResponseDataEntry;
                      return state.detailCtsModel != DetailCtsModel.empty
                          ? SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context)
                                            .viewPadding
                                            .top
                                            .px +
                                        24.px,
                                  ),
                                  SizedBox(height: 8.px),
                                  SvgPicture.asset(AppAssetsLinks.success),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.px),
                                    child: Text(
                                      'Cấp CTS thành công',
                                      style: AppTextStyle.textStyle
                                          .s24()
                                          .w700()
                                          .cN5(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text(
                                    'Chứng thư số mới có hiệu lực trong 24h.',
                                    style: AppTextStyle.textStyle
                                        .s16()
                                        .w400()
                                        .cN4(),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.px),
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
                                        title:
                                            'Tỉnh/thành phố nơi sống/ làm việc',
                                        content: cerInfo?.issuer
                                            ?.cutString(type: 'ST='),
                                      ),
                                      InfoField(
                                        title: 'Quốc gia',
                                        content: cerInfo?.issuer
                                            ?.cutString(type: 'C='),
                                      ),
                                      InfoField(
                                        title: 'Serial chứng thư số',
                                        content: cerInfo?.serialNumber,
                                      ),
                                      InfoField(
                                        title: 'Tên tổ chức chứng thực',
                                        content: cerInfo?.issuer
                                            ?.cutString(type: 'O='),
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
                            )
                          : CoverLoading();
                    }
                    return CoverLoading();
                  },
                ),
              ),
              ButtonPrimary(
                onTap: () {
                  AppBlocs.userRemoteBloc
                      .add(UserRemoteGetListDigitalCertificateEvent());
                  if(AppBlocs.ekycBloc.isManageCTS){
                    AppNavigator.popUntil(Routes.DIGITAL_CERTIFICATE);
                  }else{
                    AppNavigator.popUntil(Routes.DRAW_SIGNATURE);
                  }
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                content: 'Hoàn thành',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
