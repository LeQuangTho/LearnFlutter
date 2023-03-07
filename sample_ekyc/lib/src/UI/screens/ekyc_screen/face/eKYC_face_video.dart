import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

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

class EKYCFaceVideoScreen extends StatefulWidget {
  const EKYCFaceVideoScreen({Key? key}) : super(key: key);

  @override
  State<EKYCFaceVideoScreen> createState() => _EKYCFaceVideoScreenState();
}

class _EKYCFaceVideoScreenState extends State<EKYCFaceVideoScreen> {
  @override
  void initState() {
    super.initState();
    AppBlocs.ekycBloc.add(EkycMovingForwardStepEvent(newStep: 1));
    AppBlocs.ekycBloc.add(EkycSetupSecondaryCameraEvent());
  }

  String recordingTime = '00:00';
  bool isRecording = false;

  void recordTime() {
    var startTime = DateTime.now();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      var diff = DateTime.now().difference(startTime);
      final minutesStr =
          (diff.inMinutes % 60).floor().toString().padLeft(2, '0');
      var seconds = (diff.inSeconds % 60).floor().toString().padLeft(2, '0');
      recordingTime = '${minutesStr}:${seconds}';
      if (!isRecording) {
        t.cancel();
        recordingTime = '00:00';
      }
      setState(() {});
    });
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
            body: state.currentStep == 3
                ? Column(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            VideoPlayer(state.videoPlayerController!),
                            state.isPlaying
                                ? SizedBox.shrink()
                                : InkWell(
                                    onTap: () {
                                      AppBlocs.ekycBloc
                                          .add(EkycPlayingVideoEvent());
                                    },
                                    child: SvgPicture.asset(
                                        AppAssetsLinks.play_circle),
                                  )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.px, vertical: 16.px),
                        color: ColorsSuccess.Lv1,
                        child: Text(
                          'Thực hiện quay qua trái/phải, nháy mắt, ngước lên/xuống. Quay trong điều kiện đủ sáng, rõ nét.',
                          style: AppTextStyle.textStyle.s12().w700().cW5(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _buildButtonUsePhotoOrNot(state)
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: CameraPreview(
                            state.cameraController,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.px, vertical: 16.px),
                        color: ColorsPrimary.Lv1,
                        child: Text(
                          'Thực hiện quay qua trái/phải, nháy mắt, ngước lên/xuống. Quay trong điều kiện đủ sáng, rõ nét.',
                          style: AppTextStyle.textStyle.s12().w700().cW5(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _buildButtonUsePhotoOrNot(state),
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

  Container _buildButtonUsePhotoOrNot(EkycCameraReadyState state) {
    return Container(
      width: double.infinity,
      color: ColorsLight.Lv1,
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
                          AppBlocs.ekycBloc
                              .add(EkycMovingForwardStepEvent(newStep: 1));
                          AppBlocs.ekycBloc
                              .add(EkycSetupSecondaryCameraEvent());
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
                          print('${AppBlocs.ekycBloc.images}');
                          AppNavigator.replaceWith(Routes.EKYC_PREPARE_OCR);
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
                  'Quay video chính diện',
                  style: AppTextStyle.textStyle.s16().w500().cN5(),
                ),
                SizedBox(height: 20.px),
                GestureDetector(
                  onTap: () {
                    if (state.currentStep == 1) {
                      AppBlocs.ekycBloc.add(EkycStartRecordVideoFaceEvent());
                      setState(() {
                        isRecording = true;
                        recordTime();
                      });
                    } else if (state.currentStep == 2) {
                      AppBlocs.ekycBloc.add(EkycStopRecordVideoFaceEvent());

                      setState(() {
                        isRecording = false;
                      });
                    }
                  },
                  child: Container(
                    width: 66.px,
                    height: 66.px,
                    decoration: BoxDecoration(
                      color: ColorsPrimary.Lv5,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: state.currentStep == 2
                          ? Container(
                              width: 60.px,
                              height: 60.px,
                              decoration: BoxDecoration(
                                color: ColorsLight.Lv1,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: 36.px,
                                  height: 36.px,
                                  decoration: BoxDecoration(
                                    color: ColorsPrimary.Lv1,
                                    borderRadius: BorderRadius.circular(8.px),
                                  ),
                                ),
                              ),
                            )
                          : Container(
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
                if (isRecording)
                  Padding(
                    padding: EdgeInsets.only(top: 4.px),
                    child: Text(
                      '${recordingTime}',
                      style: AppTextStyle.textStyle.s12().w400().cN5(),
                    ),
                  ),
              ],
      ),
    );
  }
}
