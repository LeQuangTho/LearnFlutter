import 'package:sample_sdk_flutter/src/components/loading_dialog.dart';
import 'package:sample_sdk_flutter/src/components/time_out_dialog.dart';
import 'package:sample_sdk_flutter/src/constants.dart';
import 'package:sample_sdk_flutter/src/screens/result/result_screen.dart';
import 'package:sample_sdk_flutter/src/utils/api_utils/api_helper.dart';
import 'package:sample_sdk_flutter/src/components/primary_appbar.dart';
import 'package:sample_sdk_flutter/src/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';
import 'package:sample_sdk_flutter/src/utils/server_error_code_handler.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class FaceValidationPreview extends StatefulWidget {
  final String filePath;
  const FaceValidationPreview({Key? key, required this.filePath})
      : super(key: key);

  @override
  State<FaceValidationPreview> createState() => _FaceValidationPreviewState();
}

class _FaceValidationPreviewState extends State<FaceValidationPreview> {
  late VideoPlayerController _controller;
  bool _isVideoReady = false;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  Future _initVideoPlayer() async {
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) async {
        await _controller.setLooping(true);
        await _controller.play();
        setState(() {
          _isVideoReady = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        appBar: AppBar(),
        iconColor: Colors.white,
        text: "Quay video khuôn mặt",
      ),
      body: getBody(),
    );
  }

  getBody() {
    var size = MediaQuery.of(context).size;
    List<double> cardBoudingBox = computeCardBoudingBox(size);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _controller.value.isInitialized && _isVideoReady
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Column contents vertically,
              crossAxisAlignment: CrossAxisAlignment
                  .center, //Center Column contents horizontally,
              children: <Widget>[
                PrimaryButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "Chụp lại",
                  color: Colors.black,
                  backgroundColor: kPrimaryWhiteColor,
                  size: Size(size.width * 0.40, 50),
                  borderColor: kPrimaryColor,
                ),
                SizedBox(width: 5),
                PrimaryButton(
                  onPressed: () async {
                    showLoadingDialog(context);
                    var response =
                        await ApiHelper.uploadFaceVideo(widget.filePath);
                    if (response.output != null) {
                      if (AppConfig().sdkCallback != null) {
                        AppConfig().sdkCallback!.faceCloudCheck(true, "", "");
                      }
                      Navigator.pop(context);
                      Route route = MaterialPageRoute(
                        builder: (context) => ResultScreen(),
                      );
                      Navigator.push(context, route);
                    } else {
                      if (response.error != null) {
                        if (AppConfig().sdkCallback != null) {
                          AppConfig().sdkCallback!.faceCloudCheck(
                              false,
                              response.error!,
                              getMessageFromErrorCode(response.code));
                        }
                      }
                      Navigator.pop(context);
                      showTimeOutDialog(context,
                          message: getMessageFromErrorCode(response.code),
                          callback: () {
                        Navigator.pop(context);
                      });
                    }
                  },
                  text: "Xác nhận",
                  color: Colors.white,
                  backgroundColor: kPrimaryColor,
                  size: Size(size.width * 0.40, 50),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _buildPopupDialog(BuildContext context, {String message = ""}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            content: Container(
              height: 320,
              width: 290,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    "Please waiting ...",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Loading image",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          );
        });
  }

  List<double> computeCardBoudingBox(var rect) {
    const _CARD_ASPECT_RATIO = 1 / 1.5;
    const _OFFSET_X_FACTOR = 0.05;
    final offsetX = rect.width * _OFFSET_X_FACTOR;
    final cardWidth = rect.width - offsetX * 2;
    final cardHeight = cardWidth * _CARD_ASPECT_RATIO;
    final offsetY = (rect.height - cardHeight) / 2;
    return [offsetX, offsetY, cardWidth, cardHeight];
  }
}
