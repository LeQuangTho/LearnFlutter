import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/ekyc/ekyc_bloc.dart';
import '../../../common_widgets/loading/cover_loading.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class EKYCPrepareOCR extends StatefulWidget {
  const EKYCPrepareOCR({Key? key}) : super(key: key);

  @override
  State<EKYCPrepareOCR> createState() => _EKYCPrepareOCRState();
}

class _EKYCPrepareOCRState extends State<EKYCPrepareOCR> {
  @override
  void initState() {
    super.initState();
    AppBlocs.ekycBloc.add(
        EkycCreateEformRequestDiCerEvent(info: AppConfig().eKycSessionInfor));
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
        child: Column(
          children: [
            SizedBox(
                height: kToolbarHeight.px +
                    MediaQuery.of(context).viewPadding.top.px),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: Text(
                'Dữ liệu khuôn mặt đang trong quá trình xác thực',
                style: AppTextStyle.textStyle.s30().w700().cN5(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 64.px),
              child: SvgPicture.asset(
                AppAssetsLinks.onboarding_welcome,
                width: 335.px,
                height: 268.px,
              ),
            ),
            CoverLoading(size: 30),
            SizedBox(height: 20.px),
            Text(
              'Đang xác thực',
              style: AppTextStyle.textStyle.s16().w500().cN5(),
            ),
          ],
        ),
      ),
    );
  }
}
