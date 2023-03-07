import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:uiux_ekyc_flutter_sdk/src/widgets/cardScanner.dart';
import 'package:image/image.dart' as imglib;
import 'package:ekyc_flutter_sdk/ekyc_flutter_sdk.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:uiux_ekyc_flutter_sdk/src/helper/uiux_sdk_config.dart';
import 'package:uiux_ekyc_flutter_sdk/src/callback/card_validation_callback.dart';
import 'package:path_provider/path_provider.dart';

class CardValidationView extends StatefulWidget {
  CardValidationStep currentStep;
  UIUXCardValidationCallback callback;
  CardValidationView(
      {Key? key, required this.currentStep, required this.callback})
      : super(key: key);
  @override
  _CardValidationViewState createState() => _CardValidationViewState();
}

class _CardValidationViewState extends State<CardValidationView> {
  CameraController? cameraController;
  bool isCameraReady = false;
  late CardValidation cardValidation;
  bool isCapture = false;
  late CameraImage currentImage;

  late double screenWidth, screenHeight;
  late double _cardAreaLeft, _cardAreaTop, _cardAreaHeight, _cardAreaWidth;
  imglib.Image? _showImage;
  List<int>? _showBuffer;
  late SdkConfig sdkConfig;
  bool isInit = false;
  CameraDescription? choosenCamera;
  late UIUXCardValidationCallback uiuxCardValidationCallback;

  @override
  void initState() {
    super.initState();
    uiuxCardValidationCallback = widget.callback;
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    isCapture = false;
    print("Init camera");
    if (cameraController != null) cameraController!.dispose();
    final cameras = await availableCameras();
    choosenCamera = cameras[0];
    print(choosenCamera!.sensorOrientation);

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
    if (cameraController != null && cameraController!.value.isInitialized) {
      cameraController!.startImageStream((CameraImage image) {
        currentImage = image;
      });
    }
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
  void dispose() {
    if (cameraController != null) {
      cameraController!.dispose();
    }
    super.dispose();
  }

  Future<void> onCardValidationCallback(
      imglib.Image? rawCardImage,
      imglib.Image? cardImage,
      CardValidationClass? cardValidationClass,
      bool cardValidationResult,
      String message) async {
    List<int> cardImageJpeg = imglib.JpegEncoder().encodeImage(cardImage!);
    List<int> rawCardImageJpeg =
        imglib.JpegEncoder().encodeImage(rawCardImage!);
    final appDir = await getTemporaryDirectory();
    final appPath = appDir.path;
    var now = DateTime.now().millisecondsSinceEpoch;

    final fileRawImageOnDevice = File('$appPath/${now}_raw_front.jpg');
    File fileRawImage =
        await fileRawImageOnDevice.writeAsBytes(rawCardImageJpeg, flush: true);

    final fileOnDevice = File('$appPath/${now}_front.jpg');
    File file = await fileOnDevice.writeAsBytes(cardImageJpeg, flush: true);

    _disposeCamera();
    uiuxCardValidationCallback(cardValidationResult, fileRawImage.path,
        file.path, message, _initializeCamera);
  }

  @override
  Widget build(BuildContext context) {
    if (!isInit && choosenCamera != null) {
      isInit = true;
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
      getScannerSize();

      MaskView maskView = MaskView(
          _cardAreaLeft, _cardAreaTop, _cardAreaWidth, _cardAreaHeight);

      ValidationStep cardStep =
          widget.currentStep == CardValidationStep.CARDFRONT
              ? ValidationStep.CARDFRONT
              : ValidationStep.CARDBACK;
      SdkConfig sdkConfig = SdkConfig(
          MediaQuery.of(context).size, maskView, cardStep, choosenCamera!);
      cardValidation = CardValidation(sdkConfig, onCardValidationCallback);
    }
    return getBody();
  }

  void getScannerSize() {
    const _CARD_ASPECT_RATIO = 1 / 1.5;
    const _OFFSET_X_FACTOR = 0.05;
    final screenRatio = screenWidth / screenHeight;

    _cardAreaLeft = _OFFSET_X_FACTOR * screenWidth.round();
    _cardAreaWidth = screenWidth.round() - _cardAreaLeft * 2;
    _cardAreaHeight = _cardAreaWidth * _CARD_ASPECT_RATIO;
    _cardAreaTop = (screenHeight.round() - _cardAreaHeight) / 2;
  }

  Widget cameraWidget(context) {
    var camera = cameraController!.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(cameraController!),
      ),
    );
  }

  int _getQuarterTurns() {
    final Map<DeviceOrientation, int> turns = <DeviceOrientation, int>{
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeRight: 1,
      DeviceOrientation.portraitDown: 2,
      DeviceOrientation.landscapeLeft: 3,
    };
    return turns[_getApplicableOrientation()]!;
  }

  DeviceOrientation _getApplicableOrientation() {
    return cameraController!.value.isRecordingVideo
        ? cameraController!.value.recordingOrientation!
        : (cameraController!.value.previewPauseOrientation ??
            cameraController!.value.lockedCaptureOrientation ??
            cameraController!.value.deviceOrientation);
  }

  getBody() {
    if (isCameraReady) {
      var camera = cameraController!.value;
      final size = MediaQuery.of(context).size;
      var scale = size.aspectRatio * camera.aspectRatio;
      if (scale < 1) scale = 1 / scale;
      return SafeArea(
        bottom: false,
        top: false,
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Transform.scale(
                scale: scale,
                child: Center(
                  child: CameraPreview(cameraController!),
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: CardScannerOverlayShape(
                    borderColor: Colors.white,
                    borderRadius: 6,
                    borderLength: 32,
                    borderWidth: 4,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.05),
                  child: Container(
                      height: 130,
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.currentStep == CardValidationStep.CARDFRONT
                                ? "Mặt trước"
                                : "Mặt sau",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            icon: const Icon(Icons.camera),
                            color: Color.fromARGB(255, 0, 0, 0),
                            iconSize: 72,
                            tooltip: 'Take Pickture',
                            onPressed: () async {
                              cardValidation.detect(currentImage);
                              // print("hubert currentImage height = " +
                              //     currentImage.height.toString());
                              // print("hubert currentImage width = " +
                              //     currentImage.width.toString());

                              // final image =
                              //     await cameraController!.takePicture();
                              // cardValidation.detectFromFile(image.path);
                            },
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
