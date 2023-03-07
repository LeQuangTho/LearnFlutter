import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;
import 'package:ekyc_flutter_sdk/ekyc_flutter_sdk.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:uiux_ekyc_flutter_sdk/components/primary_button.dart';
import 'package:uiux_ekyc_flutter_sdk/src/helper/face_validation_status.dart';
import 'package:uiux_ekyc_flutter_sdk/src/provider/face_validation_provider.dart';
import 'package:uiux_ekyc_flutter_sdk/src/widgets/face_scanner.dart';
import 'package:provider/provider.dart';
import 'package:uiux_ekyc_flutter_sdk/src/callback/face_validation_callback.dart';

class FaceValidationView extends StatefulWidget {
  FaceValidationCallback faceValidationCallback;
  FaceValidationView({Key? key, required this.faceValidationCallback})
      : super(key: key);

  @override
  _FaceValidationViewState createState() => _FaceValidationViewState();
}

class _FaceValidationViewState extends State<FaceValidationView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? cameraController;
  bool isCameraReady = false;
  bool isCapture = false;
  late CameraImage currentImage;
  late double screenWidth, screenHeight;
  late double _cardAreaLeft, _cardAreaTop, _cardAreaHeight, _cardAreaWidth;
  FaceValidation? faceValidation;
  Color boderColor = Colors.white;
  bool isInit = false;
  CameraDescription? choosenCamera;
  bool startRecog = false;
  FaceValidationStatus faceValidateCurrentStatus = FaceValidationStatus.WAITING;
  bool checkStraight = false;
  bool checkRight = false;
  bool checkLeft = false;
  FaceValidationNotifier faceValidationNotifier =
      FaceValidationNotifier(currentStatus: FaceValidationStatus.WAITING);
  late FaceValidationCallback faceValidationCallback;

  late Animation<double> _progressAnimationStep12;
  late AnimationController _progressAnimcontrollerStep12;

  late Animation<double> _progressAnimationStep23;
  late AnimationController _progressAnimcontrollerStep23;

  late BuildContext _currentContext;

  int countDetectFailedFrame = 0;
  int countLivenessFailedFrame = 0;
  int maxDetectFrameFailed = 10;
  int maxLivenessFrameFailed = 4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    faceValidationCallback = widget.faceValidationCallback;

    _progressAnimcontrollerStep12 = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _progressAnimationStep12 =
        Tween<double>(begin: 0, end: 0).animate(_progressAnimcontrollerStep12);

    _progressAnimcontrollerStep23 = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _progressAnimationStep23 =
        Tween<double>(begin: 0, end: 0).animate(_progressAnimcontrollerStep23);
    initializeCamera();
  }

  _setProgressAnimStep12(double maxWidth, int curPageIndex) {
    _progressAnimcontrollerStep12.reset();

    _progressAnimcontrollerStep12 = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    setState(() {
      _progressAnimationStep12 = Tween<double>(begin: 0, end: 45)
          .animate(_progressAnimcontrollerStep12);
    });
    _progressAnimcontrollerStep12.forward();
  }

  _setProgressAnimStep23(double maxWidth, int curPageIndex) {
    _progressAnimcontrollerStep23.reset();

    _progressAnimcontrollerStep23 = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    setState(() {
      _progressAnimationStep23 = Tween<double>(begin: 0, end: 45)
          .animate(_progressAnimcontrollerStep23);
    });
    _progressAnimcontrollerStep23.forward();
  }

  Future<void> initializeCamera() async {
    if (cameraController != null) cameraController!.dispose();
    final cameras = await availableCameras();
    for (int i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == CameraLensDirection.front) {
        choosenCamera = cameras[i];
        break;
      }
    }
    if (choosenCamera == null) {
      print("Can't select camera !!!");
      return;
    }
    cameraController = CameraController(choosenCamera!, ResolutionPreset.high,
        enableAudio: false);

    cameraController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (cameraController!.value.hasError) {
      print('Camera Error ${cameraController!.value.errorDescription}');
    }

    try {
      await cameraController!.initialize().then((_) => {
            setState(() {
              isCameraReady = true;
            })
          });
    } catch (e) {
      print('Camera Error ${e}');
    }

    if (mounted) {
      setState(() {});
    }

    await cameraController!.prepareForVideoRecording();

    if (cameraController != null && cameraController!.value.isInitialized) {
      cameraController!.startImageStream((CameraImage image) {
        if (faceValidation != null) {
          faceValidation!.runDetect(image);
        }
      });
    }
  }

  Future<void> _resetStatus() async {
    _start = 7;
    checkStraight = false;
    checkRight = false;
    checkLeft = false;
    faceValidateCurrentStatus = FaceValidationStatus.WAITING;
    faceValidationNotifier.resetStatus();

    _progressAnimcontrollerStep12 = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
    );

    _progressAnimationStep12 =
        Tween<double>(begin: 0, end: 0).animate(_progressAnimcontrollerStep12);

    _progressAnimcontrollerStep23 = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
    );

    _progressAnimationStep23 =
        Tween<double>(begin: 0, end: 0).animate(_progressAnimcontrollerStep23);
  }

  Future<void> _disposeCamera() async {
    setState(() {
      isCameraReady = false;
    });
    Future<void>.delayed(const Duration(milliseconds: 200), () {
      if (cameraController != null) {
        cameraController!.dispose();
        cameraController = null;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      reInitFaceValidation();
    } else if (state == AppLifecycleState.inactive) {
      _disposeCamera();
    } else if (state == AppLifecycleState.paused) {
      _disposeCamera();
    } else if (state == AppLifecycleState.detached) {
      _disposeCamera();
    }
  }

  Timer? _timer;
  int _start = 7;
  void stopTime() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void startTimer(BuildContext context) {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        print("Notify _start == $_start");
        if (_start == 0) {
          // count done left
          if (!checkLeft || !checkRight || !checkStraight) {
            _start = 7;
            checkLeft = false;
            checkRight = false;
            checkStraight = false;
            faceValidateCurrentStatus = FaceValidationStatus.WAITING;
            faceValidationNotifier
                .updateFaceValidateCurrentStatus(FaceValidationStatus.WAITING);

            _stopRecordVideo(context,
                errorCode: "faceLeftFail",
                errMessage: "Lỗi xảy ra khi thực hiện mặt trái");
          } else {
            faceValidateCurrentStatus = FaceValidationStatus.DONE;
            faceValidationNotifier
                .updateFaceValidateCurrentStatus(FaceValidationStatus.DONE);
            _stopRecordVideo(context, isRecordDone: true);
          }
        } else {
          if (_start == 6) {
            // count done straight
            if (!checkStraight) {
              _start = 8;
              checkLeft = false;
              checkRight = false;
              checkStraight = false;

              faceValidateCurrentStatus = FaceValidationStatus.WAITING;
              faceValidationNotifier.updateFaceValidateCurrentStatus(
                  FaceValidationStatus.WAITING);
              _stopRecordVideo(context,
                  errorCode: "faceStraightFail",
                  errMessage: "Lỗi xảy ra khi thực hiện mặt trước");
            } else {
              faceValidateCurrentStatus = FaceValidationStatus.CHECKING_RIGHT;
              faceValidationNotifier.updateFaceValidateCurrentStatus(
                  FaceValidationStatus.CHECKING_RIGHT);
              _setProgressAnimStep12(1, 1);
            }
          }
          if (_start == 3) {
            // count done right
            if (!checkRight || !checkStraight) {
              _start = 8;
              checkLeft = false;
              checkRight = false;
              checkStraight = false;
              faceValidateCurrentStatus = FaceValidationStatus.WAITING;
              faceValidationNotifier.updateFaceValidateCurrentStatus(
                  FaceValidationStatus.WAITING);
              _stopRecordVideo(context,
                  errorCode: "faceRightFail",
                  errMessage: "Lỗi xảy ra khi thực hiện mặt phải");
            } else {
              faceValidateCurrentStatus = FaceValidationStatus.CHECKING_LEFT;
              faceValidationNotifier.updateFaceValidateCurrentStatus(
                  FaceValidationStatus.CHECKING_LEFT);
              _setProgressAnimStep23(1, 1);
            }
          }
          _start--;
        }
      },
    );
  }

  void faceDetectCallBack(
      List<Detection> detection,
      imglib.Image? img,
      bool detectResult,
      String resultName,
      String message,
      double leftAndRigtPercent) {
    if (faceValidationNotifier.isRecording == true) {
      if (detectResult == false) {
        countDetectFailedFrame += 1;
        if (countDetectFailedFrame == maxDetectFrameFailed) {
          _start = 7;
          checkLeft = false;
          checkRight = false;
          checkStraight = false;
          faceValidateCurrentStatus = FaceValidationStatus.WAITING;
          faceValidationNotifier
              .updateFaceValidateCurrentStatus(FaceValidationStatus.WAITING);
          // stop record
          _stopRecordVideo(_currentContext,
              errorCode: resultName, errMessage: message);
          return;
        }
      } else {
        countDetectFailedFrame = 0;
      }
      if (faceValidateCurrentStatus == FaceValidationStatus.CHECKING_STRAIGHT) {
        if (!checkStraight &&
            detectResult &&
            -50 < leftAndRigtPercent &&
            leftAndRigtPercent < 50) {
          checkStraight = true;
        }
      }
      if (faceValidateCurrentStatus == FaceValidationStatus.CHECKING_RIGHT) {
        if (!checkRight && leftAndRigtPercent > 60) {
          checkRight = true;
          faceValidationNotifier.changeArrowPath(
              "assets/images/face_validate_right_arrow_success.png");
        }
      }
      if (faceValidateCurrentStatus == FaceValidationStatus.CHECKING_LEFT) {
        if (!checkLeft && leftAndRigtPercent < -60) {
          faceValidationNotifier.changeArrowPath(
              "assets/images/face_validate_left_arrow_success.png");
          checkLeft = true;
        }
      }
    }
  }

  void faceLivenessCallBack(
      bool livenessResult, String resultName, String message) {
    if (faceValidationNotifier.isRecording == false) {
      if (!livenessResult) {
        faceValidationNotifier.changeValidationResult(message.toString());
        if (faceValidationNotifier.canStart == true) {
          faceValidationNotifier.changeCanStartStatus(false);
        }
      } else {
        faceValidationNotifier.changeValidationResult("Bấm để bắt đầu");
        faceValidationNotifier.changeCanStartStatus(true);
      }
    } else {
      if (!livenessResult && resultName != "SMALL_FACE") {
        countLivenessFailedFrame += 1;
        if (countLivenessFailedFrame == maxLivenessFrameFailed) {
          _start = 7;
          checkLeft = false;
          checkRight = false;
          checkStraight = false;
          faceValidateCurrentStatus = FaceValidationStatus.WAITING;
          faceValidationNotifier
              .updateFaceValidateCurrentStatus(FaceValidationStatus.WAITING);
          _stopRecordVideo(_currentContext,
              errorCode: resultName, errMessage: message);
        }
      } else {
        countLivenessFailedFrame = 0;
      }
    }
  }

  @override
  void dispose() {
    if (cameraController != null) {
      cameraController!.dispose();
    }
    // _disposeCamera();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    getScannerSize();
    if (!isInit && choosenCamera != null && isCameraReady) {
      _currentContext = context;
      MaskView maskView = MaskView(
          _cardAreaLeft, _cardAreaTop, _cardAreaWidth, _cardAreaHeight);
      SdkConfig sdkConfig = SdkConfig(MediaQuery.of(context).size, maskView,
          ValidationStep.CARDBACK, choosenCamera!);
      faceValidation = FaceValidation(sdkConfig,
          faceDetectionCallBack: faceDetectCallBack,
          faceLivenessCallBack: faceLivenessCallBack);
      isInit = true;
    }
    return getBody();
  }

  void getScannerSize() {
    const _CARD_ASPECT_RATIO = 1.25 / 1;
    const _OFFSET_X_FACTOR = 0.15;
    final screenRatio = screenWidth / screenHeight;

    _cardAreaLeft = _OFFSET_X_FACTOR * screenWidth.round();
    _cardAreaWidth = screenWidth.round() - _cardAreaLeft * 2;
    _cardAreaHeight = _cardAreaWidth * _CARD_ASPECT_RATIO;
    _cardAreaTop =
        (screenHeight.round() - screenHeight.round() * 0.15 - _cardAreaHeight) /
            2;
  }

  void _startFaceRecogFlow(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200), () {
      _startRecordVideo(context);
    });
  }

  _startRecordVideo(BuildContext context) async {
    if (faceValidationNotifier.isRecording == false) {
      if (cameraController!.value.isRecordingVideo) {
        return;
      }

      faceValidationNotifier.updateFaceValidateCurrentStatus(
          FaceValidationStatus.CHECKING_STRAIGHT);
      faceValidateCurrentStatus = FaceValidationStatus.CHECKING_STRAIGHT;
      faceValidationNotifier.changeRecordStatus(true);
      await cameraController!.prepareForVideoRecording();
      await cameraController!.startVideoRecording();
      startTimer(context);
    }
  }

  Future<void> reInitFaceValidation() async {
    await _resetStatus();
    await initializeCamera();
  }

  Future<void> failedFunction() async {}

  _stopRecordVideo(BuildContext context,
      {bool isRecordDone = false,
      String errorCode = "",
      String errMessage = "Xin hãy thực hiện theo hướng dẫn"}) async {
    if (faceValidationNotifier.isRecording == true) {
      final CameraController? controller = cameraController;

      if (controller == null || !controller.value.isRecordingVideo) {
        return null;
      }
      XFile? file;
      try {
        file = await controller.stopVideoRecording();
      } on CameraException catch (e) {
        print(e);
        return null;
      }

      stopTime();
      faceValidationNotifier.changeRecordStatus(false);
      faceValidationNotifier.changeCanStartStatus(false);
      if (isRecordDone == true) {
        _buildSuccessPopupDialog(context);
        await _disposeCamera();
        if (file != null) {
          Future.delayed(const Duration(milliseconds: 1000), () async {
            Navigator.of(context).pop();
            await faceValidationCallback(
                true, file!.path, "", "", reInitFaceValidation);
          });
        }
      } else {
        _buildPopupDialog(context, message: errMessage);
        if (file != null) {
          File videoFile = File(file.path);
          videoFile.delete();
        }
        faceValidationCallback(
            false, "", errorCode, errMessage, failedFunction);
        await _disposeCamera();
        await _resetStatus();
        // Future.delayed(const Duration(milliseconds: 200), () {
        //   initializeCamera();
        // });
      }
    }
  }

  void _buildSuccessPopupDialog(BuildContext context,
      {String message = "Hoan Thanh"}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              height: 320,
              width: 290,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 120,
                    child: Image.asset(
                      "assets/images/face_validate_success_popup_icon1.png",
                      package: 'uiux_ekyc_flutter_sdk',
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Hoàn thành video",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          );
        });
  }

  void _buildPopupDialog(BuildContext context,
      {String message = "Xin hãy thực hiện theo hướng dẫn"}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              height: 320,
              width: 290,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 120,
                    child: Image.asset(
                      "assets/images/face_validate_failed_dialog_icon1.png",
                      package: 'uiux_ekyc_flutter_sdk',
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "THAO TÁC SAI",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    message,
                    style:
                        const TextStyle(color: Color(0xFF1B1D29), fontSize: 15),
                  ),
                  const SizedBox(height: 25),
                  PrimaryButton(
                    onPressed: () {
                      initializeCamera();
                      Navigator.of(context).pop();
                    },
                    text: "Thao tác lại",
                    color: Color(0xFF1B1D29),
                    backgroundColor: Color(0xFFFFC709),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          );
        });
  }

  getBody() {
    // if (isCameraReady) {
    var scale = 1.0;
    final size = MediaQuery.of(context).size;
    if (isCameraReady) {
      var camera = cameraController!.value;
      scale = size.aspectRatio * camera.aspectRatio;
      if (scale < 1) scale = 1 / scale;
    }
    return ChangeNotifierProvider<FaceValidationNotifier>.value(
      value: faceValidationNotifier,
      child: Consumer<FaceValidationNotifier>(
        builder: (context, faceValidationNotifier, child) {
          return SafeArea(
            bottom: false,
            top: false,
            child: Container(
              height: size.height,
              width: size.width,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Transform.scale(
                    scale: scale,
                    child: isCameraReady
                        ? Center(
                            child: CameraPreview(cameraController!),
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                  Container(
                    decoration: ShapeDecoration(
                      shape: FaceScannerOverlayShape(
                        borderColor: faceValidationNotifier.faceMaskBorderColor,
                        borderRadius: 12,
                        borderLength: 32,
                        borderWidth: 4,
                      ),
                    ),
                  ),
                  Positioned(
                    top: _cardAreaTop + _cardAreaHeight / 2 - 70 / 2,
                    left: _cardAreaLeft + _cardAreaWidth / 2 - 160 / 2,
                    child: SizedBox(
                      child: faceValidationNotifier.arrowPath != null
                          ? Image.asset(
                              AssetImage(faceValidationNotifier.arrowPath!)
                                  .assetName,
                              package: 'uiux_ekyc_flutter_sdk')
                          : Container(),
                      height: 70,
                      width: 160,
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.topCenter,
                  //   child: Padding(
                  //     padding: EdgeInsets.only(top: size.height * 0.15),
                  //     child: Text(
                  //       faceValidationNotifier.validationResult,
                  //       textAlign: TextAlign.center,
                  //       style: const TextStyle(
                  //         fontSize: 17,
                  //         fontWeight: FontWeight.normal,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height * 0.05),
                      child: Container(
                        height: size.height * 0.3,
                        margin: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              child: faceValidationNotifier.iconPath != null
                                  ? Image.asset(
                                      AssetImage(
                                              faceValidationNotifier.iconPath!)
                                          .assetName,
                                      package: 'uiux_ekyc_flutter_sdk',
                                    )
                                  : Container(),
                              height: 70,
                              width: 70,
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(25),
                              child: Text(
                                faceValidationNotifier.validationResult,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: size.width,
                              child: faceValidationNotifier.isRecording == false
                                  ? SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: faceValidationNotifier.canStart
                                          ? InkWell(
                                              onTap: () {
                                                _startFaceRecogFlow(context);
                                              },
                                              child: Image.asset(
                                                  const AssetImage(
                                                          "assets/images/ic_capture.png")
                                                      .assetName,
                                                  package:
                                                      'uiux_ekyc_flutter_sdk'),
                                            )
                                          : Image.asset(
                                              const AssetImage(
                                                      "assets/images/ic_capture_disabled.png")
                                                  .assetName,
                                              package: 'uiux_ekyc_flutter_sdk'),
                                    )
                                  :
                                  // horizoltal step
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, //Center Row contents horizontally,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center, //Center Row contents vertically,
                                      children: [
                                        SizedBox(
                                          child: Image.asset(
                                              faceValidationNotifier.step1Path,
                                              package: 'uiux_ekyc_flutter_sdk'),
                                          height: 35,
                                          width: 35,
                                        ),
                                        SizedBox(
                                          width: 45,
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: <Widget>[
                                                AnimatedProgressBar(
                                                  animation:
                                                      _progressAnimationStep12,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: 6.0,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          child: Image.asset(
                                              faceValidationNotifier.step2Path,
                                              package: 'uiux_ekyc_flutter_sdk'),
                                          height: 35,
                                          width: 35,
                                        ),
                                        SizedBox(
                                          width: 45,
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: <Widget>[
                                                AnimatedProgressBar(
                                                  animation:
                                                      _progressAnimationStep23,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: 6.0,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          child: Image.asset(
                                              faceValidationNotifier.step3Path,
                                              package: 'uiux_ekyc_flutter_sdk'),
                                          height: 35,
                                          width: 35,
                                        ),
                                      ],
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedProgressBar extends AnimatedWidget {
  AnimatedProgressBar({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Container(
      height: 6.0,
      width: animation.value,
      decoration: BoxDecoration(color: Colors.green),
    );
  }
}
