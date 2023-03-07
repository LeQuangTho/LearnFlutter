import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/helpers/untils/validator_untils.dart';

import '../../../BLOC/app_blocs.dart';
import '../../../BLOC/user_remote/models/response/digital_certificate_response.dart';
import '../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../navigations/app_pages.dart';
import '../../../navigations/app_routes.dart';
import '../../common_widgets/buttons/button_primary.dart';
import '../../common_widgets/dialogs/show_dialog_animations.dart';
import '../../common_widgets/loading/cover_loading.dart';
import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/layouts/appbar_common.dart';
import '../../designs/sizer_custom/sizer.dart';

class DigitalCertificateScreen extends StatefulWidget {
  const DigitalCertificateScreen({Key? key}) : super(key: key);

  @override
  State<DigitalCertificateScreen> createState() =>
      _DigitalCertificateScreenState();
}

class _DigitalCertificateScreenState extends State<DigitalCertificateScreen> {
  @override
  void initState() {
    super.initState();
    AppBlocs.userRemoteBloc.add(UserRemoteGetListDigitalCertificateEvent());
  }

  String _warning(String time) {
    final timeRemaining = DateTime.parse(time).difference(DateTime.now());
    if (timeRemaining.inHours > 0) {
      return 'Chứng thư số của bạn còn hiệu lực trong vòng ${timeRemaining.inHours} giờ.';
    } else if (timeRemaining.inMinutes > 0) {
      return 'Chứng thư số của bạn còn hiệu lực trong vòng ${timeRemaining.inMinutes} phút.';
    } else {
      return 'Chứng thư số của bạn còn hiệu lực trong vòng ${timeRemaining.inSeconds} giây.';
    }
  }

  bool isValidTime(String time) {
    final now = DateTime.now();
    final expiredTime = DateTime.parse(time);
    return now.compareTo(expiredTime) > 0;
  }

  void registerCTS() {
    if (ValidatorUtils.hasInfoCreateCTS()) {
      AppBlocs.ekycBloc.isManageCTS = true;
      AppNavigator.push(Routes.EKYC);
    } else {
      showDialogMissInfo(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsGray.Lv3,
      appBar: MyAppBar('Quản lý chứng thư số'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.px),
        child: Column(
          children: [
            Expanded(child: BlocBuilder<UserRemoteBloc, UserRemoteState>(
                builder: (context, state) {
              if (state is UserRemoteGetDoneData) {
                if (state.digitalCertificates.isEmpty) {
                  return Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          AppAssetsLinks.background_otp_sc,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(AppAssetsLinks.empty_box),
                          SizedBox(height: 24.px),
                          Text(
                            'Bạn chưa có chứng thư số, vui lòng đăng ký. Chứng thư số cấp mới có hiệu lực trong 24h.',
                            style: AppTextStyle.textStyle.s16().w400().cN4(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return ListView.separated(
                    padding: EdgeInsets.only(top: 24.px),
                    itemCount: state.digitalCertificates.length,
                    separatorBuilder: (c, i) => SizedBox(height: 8),
                    itemBuilder: (c, i) =>
                        _ItemCTS(diCer: state.digitalCertificates[i]),
                  );
                }
              }
              return CoverLoading();
            })),
            BlocBuilder<UserRemoteBloc, UserRemoteState>(
              builder: (context, state) {
                if (state is UserRemoteGetDoneData &&
                    state.digitalCertificates.isNotEmpty) {
                  return ButtonPrimary(
                    onTap: () {
                      isValidTime(state.digitalCertificates[0].validTo!)
                          ? registerCTS()
                          : showToast(ToastType.warning,
                              title: _warning(
                                  state.digitalCertificates[0].validTo!));
                    },
                    content: 'Đăng ký',
                  );
                } else {
                  return ButtonPrimary(
                    onTap: () => registerCTS(),
                    content: 'Đăng ký',
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class _ItemCTS extends StatelessWidget {
  const _ItemCTS({Key? key, required this.diCer}) : super(key: key);

  final DigitalCertificate diCer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppNavigator.push(Routes.DETAIL_DI_CER, arguments: {'diCer': diCer});
      },
      child: Container(
          padding: EdgeInsets.all(16.px),
          decoration: BoxDecoration(
            color: ColorsLight.Lv1,
            borderRadius: BorderRadius.circular(10.px),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                diCer.subjectDN
                        ?.split(',')
                        .toList()
                        .firstWhere((e) => e.contains('CN='), orElse: () => '')
                        .replaceAll(' CN=', '') ??
                    '',
                style: AppTextStyle.textStyle.s16().w500().cN5(),
              ),
              SizedBox(height: 4.px),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      diCer.name ?? '',
                      style: AppTextStyle.textStyle.s16().w400().cN4(),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:
                          diCer.status! ? ColorsSuccess.Lv5 : ColorsPrimary.Lv5,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text(
                      diCer.status! ? "ĐANG HOẠT ĐỘNG" : "HẾT HẠN",
                      style: AppTextStyle.textStyle.s10().w700().copyWith(
                            color: diCer.status!
                                ? ColorsSuccess.Lv1
                                : ColorsPrimary.Lv1,
                          ),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
