import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/ekyc/ekyc_bloc.dart';
import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_pop.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_background.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';

class EKYCFace2 extends StatefulWidget {
  const EKYCFace2({Key? key}) : super(key: key);

  @override
  State<EKYCFace2> createState() => _EKYCFace2State();
}

class _EKYCFace2State extends State<EKYCFace2> {
  @override
  void initState() {
    super.initState();
    AppBlocs.ekycBloc.add(EkycMovingForwardStepEvent(newStep: 1));
    AppBlocs.ekycBloc.add(EkycSetupSecondaryCameraEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkycBloc, EkycState>(
      builder: (context, state) {
        if (state is EkycCameraReadyState) {
          return Scaffold(
            appBar: MyAppBar('Xác thực khuôn mặt'),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: CameraPreview(
                    state.cameraController,
                  ),
                ),
                Container(
                  color: ColorsLight.Lv1,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.px, vertical: 16.px),
                        color: state.currentStep == 2
                            ? ColorsSuccess.Lv1
                            : ColorsPrimary.Lv1,
                        child: Text(
                          'Vui lòng chụp ảnh chân dung của bạn. Ảnh chụp trong điều kiện đủ sáng, rõ nét.',
                          style: AppTextStyle.textStyle.s12().w700().cW5(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _buildButtonUsePhotoOrNot(state),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return BackgroundStack(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 8.px,
                ),
                Text('Đang xử lý...',
                    style: AppTextStyle.textStyle.s16().w500().cN1()),
                SizedBox(
                  height: 16.px,
                ),
                Text(
                  'Quá trình này có thể mất đến 30 giây. Vui lòng không tắt hoặc thoát ứng dụng.',
                  style: AppTextStyle.textStyle.s16().w500().cN1(),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonUsePhotoOrNot(EkycCameraReadyState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.px, 16.px, 20.px, 42.px),
      child: Column(
        children: state.currentStep == 2
            ? [
                SvgPicture.asset(AppAssetsLinks.success, height: 56.px),
                SizedBox(height: 8.px),
                Text('Hoàn thành',
                    style: AppTextStyle.textStyle.s16().w500().cG5()),
                SizedBox(height: 24.px),
                Row(
                  children: [
                    Expanded(
                      child: ButtonPop2(
                        onTap: () {
                          AppBlocs.ekycBloc
                              .add(EkycMovingForwardStepEvent(newStep: 1));
                          AppBlocs.ekycBloc
                              .add(EkycSetupSecondaryCameraEvent());
                        },
                        buttonTitle: 'Chụp lại',
                        colorText: ColorsPrimary.Lv1,
                        colorButton: ColorsPrimary.Lv5,
                      ),
                    ),
                    SizedBox(width: 20.px),
                    Expanded(
                      child: ButtonPrimary(
                        onTap: () {
                          AppNavigator.replaceWith(
                              Routes.EKYC_FACE_VIDEO_GUIDE);
                        },
                        content: 'Sử dụng',
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                )
              ]
            : [
                SvgPicture.asset(AppAssetsLinks.face_2),
                SizedBox(height: 8.px),
                Text(
                  'Chụp ảnh chính diện',
                  style: AppTextStyle.textStyle.s16().w500().cN5(),
                ),
                SizedBox(height: 20.px),
                GestureDetector(
                  onTap: () {
                    AppBlocs.ekycBloc.add(EkycTakeFacePictureEvent());
                  },
                  child: Container(
                    width: 66.px,
                    height: 66.px,
                    decoration: BoxDecoration(
                      color: ColorsPrimary.Lv5,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 60.px,
                        height: 60.px,
                        decoration: BoxDecoration(
                          color: ColorsPrimary.Lv1,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4.px,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}
