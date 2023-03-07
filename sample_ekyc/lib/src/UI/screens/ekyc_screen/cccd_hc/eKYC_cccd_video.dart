import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/ekyc/ekyc_bloc.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_pop.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_background.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../widgets/button_record_video.dart';
import '../widgets/my_video_player.dart';
import '../widgets/time_record.dart';

class EKYCIDVideoScreen extends StatefulWidget {
  const EKYCIDVideoScreen({Key? key}) : super(key: key);

  @override
  State<EKYCIDVideoScreen> createState() => _EKYCIDVideoScreenState();
}

class _EKYCIDVideoScreenState extends State<EKYCIDVideoScreen> {
  @override
  void initState() {
    super.initState();
    AppBlocs.ekycBloc.add(EkycMovingForwardStepEvent(newStep: 1));
    AppBlocs.ekycBloc.add(EkycSetupFirstCameraEvent());
  }

  @override
  void dispose() {
    super.dispose();
    AppBlocs.ekycBloc.add(EkycStopRecordVideoCccdEvent());
    AppBlocs.ekycBloc.videoPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkycBloc, EkycState>(
      builder: (context, state) {
        if (state is EkycCameraReadyState) {
          return Scaffold(
            backgroundColor: ColorsLight.Lv1,
            appBar: MyAppBar('Quay video giấy tờ'),
            body: state.currentStep == 3
                ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      MyVideoPlayer(state: state),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.px, vertical: 16.px),
                            color: ColorsSuccess.Lv1,
                            child: Text(
                              'Vui lòng đặt giấy tờ vào giữa khung hình, quay đủ 2 mặt giấy tờ.',
                              style: AppTextStyle.textStyle.s12().w700().cW5(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          _buildButtonUsePhotoOrNot(state),
                        ],
                      ),
                    ],
                  )
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: CameraPreview(
                          state.cameraController,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.px, vertical: 16.px),
                            color: ColorsPrimary.Lv1,
                            child: Text(
                              'Vui lòng đặt giấy tờ vào giữa khung hình, quay đủ 2 mặt giấy tờ.',
                              style: AppTextStyle.textStyle.s12().w700().cW5(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          _buildButtonUsePhotoOrNot(state),
                        ],
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
      color: ColorsLight.Lv1,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.px, 16.px, 20.px, 42.px),
      child: Column(
        children: state.currentStep == 3
            ? [
                SvgPicture.asset(AppAssetsLinks.success, height: 56.px),
                SizedBox(
                  height: 8.px,
                ),
                Text('Hoàn thành',
                    style: AppTextStyle.textStyle.s16().w500().cG5()),
                SizedBox(
                  height: 24.px,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ButtonPop2(
                        onTap: () {
                          AppBlocs.ekycBloc.videoPlayerController?.dispose();
                          AppBlocs.ekycBloc
                              .add(EkycMovingForwardStepEvent(newStep: 1));
                          AppBlocs.ekycBloc.add(EkycSetupFirstCameraEvent());
                        },
                        buttonTitle: 'Quay lại',
                        colorText: ColorsPrimary.Lv1,
                        colorButton: ColorsPrimary.Lv5,
                      ),
                    ),
                    SizedBox(width: 20.px),
                    Expanded(
                      child: ButtonPrimary(
                        onTap: () {
                          AppBlocs.ekycBloc.videoPlayerController?.pause();

                          AppBlocs.ekycBloc.add(EkycUploadFileEvent(
                            file: File(AppBlocs.ekycBloc
                                    .images['video_identification']?.path ??
                                ''),
                            fileName: 'video_identification',
                            routeReplace: Routes.CHECK_INFO_CCCD,
                          ));
                        },
                        content: 'Sử dụng',
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                )
              ]
            : [
                SvgPicture.asset(AppAssetsLinks.cccdback),
                SizedBox(height: 8.px),
                Text(
                  'Quay video giấy tờ',
                  style: AppTextStyle.textStyle.s16().w500().cN5(),
                ),
                SizedBox(height: 20.px),
                ButtonRecordVideo(
                  step: state.currentStep,
                  onTap: () {
                    if (state.currentStep == 1) {
                      AppBlocs.ekycBloc.add(EkycStartRecordVideoCccdEvent());
                    } else if (state.currentStep == 2) {
                      AppBlocs.ekycBloc.add(EkycStopRecordVideoCccdEvent());
                    }
                  },
                ),
                TimeRecord(),
              ],
      ),
    );
  }
}
