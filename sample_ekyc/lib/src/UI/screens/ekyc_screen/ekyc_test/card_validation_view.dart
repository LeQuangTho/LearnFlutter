import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ekyc_flutter_sdk/ekyc_flutter_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';
import 'package:uiux_ekyc_flutter_sdk/src/callback/card_validation_callback.dart';

import '../../../common_widgets/loading/cover_loading.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../widgets/card_overlay_shape.dart';

enum CardValidationStep { CARDFRONT, CARDBACK }

// ignore: must_be_immutable
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
    return getBody2();
  }

  void getScannerSize() {
    const _CARD_ASPECT_RATIO = 1 / 1.5;
    const _OFFSET_X_FACTOR = 0.05;

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

  getBody2() {
    if (isCameraReady) {
      var camera = cameraController!.value;
      final size = MediaQuery.of(context).size;
      var scale = size.aspectRatio * camera.aspectRatio;
      if (scale < 1) scale = 1 / scale;
      return Container(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Transform.scale(
                scale: scale,
                child: Center(
                  child: CameraPreview(cameraController!),
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: CardOverlayShape(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [_buildButtonUsePhotoOrNot()],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.px, vertical: 16.px),
                  color: ColorsPrimary.Lv1,
                  child: Text(
                    'Vui lòng đặt CCCD/CMND nằm trong vùng chọn. Ảnh chụp trong điều kiện đủ sáng, rõ nét.',
                    style: AppTextStyle.textStyle.s12().w700().cW5(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ));
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: DecoratedBox(
        decoration: BoxDecoration(color: ColorsLight.Lv1),
        child: CoverLoading(),
      ),
    );
  }

  Widget _buildButtonUsePhotoOrNot() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.px, 16.px, 20.px, 42.px),
      child: Column(
        children: [
          SvgPicture.asset(widget.currentStep == CardValidationStep.CARDFRONT
              ? AppAssetsLinks.cccdfront
              : AppAssetsLinks.cccdback),
          SizedBox(height: 8.px),
          Text(
            widget.currentStep == CardValidationStep.CARDFRONT
                ? 'Chụp mặt trước của CCCD/CMND'
                : 'Chụp mặt sau của CCCD/CMND',
            style: AppTextStyle.textStyle.s16().w500().cN5(),
          ),
          SizedBox(height: 20.px),
          GestureDetector(
            onTap: () {
              cardValidation.detect(currentImage);
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
