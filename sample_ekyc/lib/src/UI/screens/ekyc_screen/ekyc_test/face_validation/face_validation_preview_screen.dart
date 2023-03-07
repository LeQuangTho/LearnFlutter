import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/buttons/button_pop.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/buttons/button_primary.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/dialogs/show_dialog_animations.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/layouts/appbar_common.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';
import 'package:sample_sdk_flutter/src/utils/api_utils/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';
import 'package:sample_sdk_flutter/src/utils/server_error_code_handler.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import '../../../../../helpers/untils/logger.dart';
import '../../../../designs/app_themes/app_assets_links.dart';
import '../../../../designs/app_themes/app_text_styles.dart';

class FaceValidationPreview extends StatefulWidget {
  final String filePath;
  const FaceValidationPreview({Key? key, required this.filePath})
      : super(key: key);

  @override
  State<FaceValidationPreview> createState() => _FaceValidationPreviewState();
}

class _FaceValidationPreviewState extends State<FaceValidationPreview> {
  late VideoPlayerController _controller;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _controller.addListener(playVideo);
  }

  void playVideo() {
    if (_controller.value.isPlaying == true) {
      setState(() {
        isPlaying = true;
      });
    } else {
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future _initVideoPlayer() async {
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) async {
        // await _controller.setLooping(true);
        // await _controller.play();
        // setState(() {
        //   _isVideoReady = true;
        // });
      });
  }

  bool isPlaying = false;
  void play() async {
    await _controller.play();
    setState(() {
      isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsWhite.Lv1,
      appBar: MyAppBar(
        "Quay video khuôn mặt",
      ),
      body: getBody(),
    );
  }

  getBody() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            // VideoPlayer(_controller),
            isPlaying
                ? SizedBox.shrink()
                : Positioned(
                    top: 180.px,
                    child: InkWell(
                      onTap: play,
                      child: SvgPicture.asset(AppAssetsLinks.play_circle),
                    ),
                  )
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: ColorsLight.Lv1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.px, vertical: 16.px),
                  color: ColorsSuccess.Lv1,
                  child: Text(
                    'Kiểm tra video của bạn. Bạn có thể quay lại hoặc sử dụng video này.',
                    style: AppTextStyle.textStyle.s12().w700().cW5(),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16.px),
                SvgPicture.asset(AppAssetsLinks.success, height: 56.px),
                SizedBox(height: 8.px),
                Text('Hoàn thành',
                    style: AppTextStyle.textStyle.s16().w500().cN5()),
                SizedBox(height: 24.px),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.px, 0, 20.px, 42.px),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //Center Column contents vertically,
                    crossAxisAlignment: CrossAxisAlignment
                        .center, //Center Column contents horizontally,
                    children: <Widget>[
                      Expanded(
                        child: ButtonPop2(
                          colorButton: ColorsPrimary.Lv5,
                          colorText: ColorsPrimary.Lv1,
                          buttonTitle: "Quay lại",
                          onTap: () => AppNavigator.pop(),
                        ),
                      ),
                      SizedBox(width: 20.px),
                      Expanded(
                        child: ButtonPrimary(
                          onTap: () async {
                            showDialogLoading();
                            var response = await ApiHelper.uploadFaceVideo(
                                widget.filePath);
                            UtilLogger.log(
                                'Response uploadFaceVideo', response.toJson());
                            if (response.output != null) {
                              if (AppConfig().sdkCallback != null) {
                                AppConfig()
                                    .sdkCallback!
                                    .faceCloudCheck(true, "", "");
                              }
                              // Navigator.pop(context);
                              AppNavigator.popUntil(Routes.EKYC_FACE_VIDEO_GUIDE);
                              AppNavigator.push(Routes.EKYC_PREPARE_OCR);
                            } else {
                              if (response.error != null) {
                                if (AppConfig().sdkCallback != null) {
                                  AppConfig().sdkCallback!.faceCloudCheck(
                                      false,
                                      response.error!,
                                      getMessageFromErrorCode(response.code));
                                }
                              }
                              AppNavigator.pop();
                              showToast(ToastType.error,
                                  title:
                                      getMessageFromErrorCode(response.code));
                            }
                          },
                          content: "Sử dụng",
                          padding: EdgeInsets.zero,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
