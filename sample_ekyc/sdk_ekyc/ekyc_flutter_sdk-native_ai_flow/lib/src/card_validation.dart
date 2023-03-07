import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';
import 'package:ekyc_flutter_sdk/src/ai_service/card_liveness.dart';
import 'package:ekyc_flutter_sdk/src/utils/sdk_config.dart';
import 'package:ekyc_flutter_sdk/src/utils/card_validation_result_handle.dart';
import 'package:ekyc_flutter_sdk/src/callback/card_validation_callback.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:ekyc_flutter_sdk/src/utils/image_utils.dart';
import 'package:flutter/services.dart';
import 'package:ekyc_flutter_sdk/src/utils/native_plugin.dart';
import 'dart:isolate';

class CardValidation {
  late final CardValidationCallBack _validationCallBack;
  late CardLiveness _cardLiveness;
  late SdkConfig _sdkConfig;
  bool usingNative = true;

  CardValidation(
      SdkConfig sdkConfig, CardValidationCallBack validationCallBack) {
    _sdkConfig = sdkConfig;
    _validationCallBack = validationCallBack;
    if (Platform.isAndroid && usingNative) {
      initModel();
    } else {
      _cardLiveness = CardLiveness();
    }
  }

  void detect(CameraImage cameraImage) async {
    late imglib.Image _img;
    if (Platform.isAndroid) {
      _img = ImageUtils.convertCameraImage(cameraImage)!;
      _img = imglib.copyRotate(
          _img, _sdkConfig.cameraDescription.sensorOrientation);
    } else {
      _img = ImageUtils.convertCameraImage(cameraImage)!;
    }
    imglib.Image cropedCardImage = ImageUtils.cropImage(_img, _sdkConfig);
    if (Platform.isAndroid && usingNative) {
      detectImageByNative(_img, cropedCardImage);
    } else {
      detectImage(_img, cropedCardImage);
    }
  }

  initModel() async {
    var res1 = await NativePlugin.loadModel(
      model:
          "packages/ekyc_flutter_sdk/assets/models/cardliveness_mymodel_12_mobilenetv2_26classes_finger_spotlight_04042022_1553.tflite",
      modelType: "cardLiveness",
      numThreads: 1, // defaults to 1
      isAsset:
          true, // defaults to true, set to false to load resources outside assets
    );
    print("hubert res1: $res1");
  }

  void detectFromFile(String path) async {
    final Uint8List inputImg = await File(path).readAsBytes();
    final decoder = imglib.JpegDecoder();
    imglib.Image? decodedImg = decoder.decodeImage(inputImg);
    if (decodedImg == null) {
      detectImage(null, null);
      return;
    }
    var receiPort = ReceivePort();
    await Isolate.spawn(rotateImageFile, [decodedImg, receiPort.sendPort]);
    receiPort.listen((res) async {
      final imglib.Image orientedImage = res;
      if (orientedImage == null) {
        detectImage(null, null);
      } else {
        imglib.Image cropedCardImage =
            ImageUtils.cropImage(orientedImage, _sdkConfig);
        detectImage(orientedImage, cropedCardImage);
      }
    });
  }

  static void rotateImageFile(paramList) {
    imglib.Image orginImage = paramList[0];
    SendPort sendPort = paramList[1];
    imglib.Image rotatedImage = imglib.bakeOrientation(orginImage);
    sendPort.send(rotatedImage);
  }

  void detectImageByNative(imglib.Image? rawImg, imglib.Image? img) async {
    if (img == null) {
      _validationCallBack(null, null, null, false, "Image null");
      return;
    }
    List<dynamic>? _detections = await NativePlugin.runCardValidateOnImage(img);

    int maxIndex = _getMaxIndexInNative(_detections!);
    CardValidationClass cardValidationClass =
        CardValidationClass.values[maxIndex];
    bool validationResult = _validation(cardValidationClass);
    if (!validationResult) {
      if (cardValidationClass == CardValidationClass.valid_front_CCCD ||
          cardValidationClass == CardValidationClass.valid_front_CMND ||
          cardValidationClass == CardValidationClass.valid_front_chip ||
          cardValidationClass == CardValidationClass.valid_back_CCCD ||
          cardValidationClass == CardValidationClass.valid_back_CMND ||
          cardValidationClass == CardValidationClass.valid_back_chip) {
        cardValidationClass = CardValidationClass.invalid_SIDE;
      }
    }
    String message = cardValidationClass.message;
    _validationCallBack(
        rawImg, img, cardValidationClass, validationResult, message);
  }

  void detectImage(imglib.Image? rawImg, imglib.Image? img) {
    if (img == null) {
      _validationCallBack(null, null, null, false, "Image null");
      return;
    }
    List<double>? _detections = _cardLiveness.predict(img);
    int maxIndex = _getMaxIndex(_detections!);
    CardValidationClass cardValidationClass =
        CardValidationClass.values[maxIndex];
    bool validationResult = _validation(cardValidationClass);
    if (!validationResult) {
      if (cardValidationClass == CardValidationClass.valid_front_CCCD ||
          cardValidationClass == CardValidationClass.valid_front_CMND ||
          cardValidationClass == CardValidationClass.valid_front_chip ||
          cardValidationClass == CardValidationClass.valid_back_CCCD ||
          cardValidationClass == CardValidationClass.valid_back_CMND ||
          cardValidationClass == CardValidationClass.valid_back_chip) {
        cardValidationClass = CardValidationClass.invalid_SIDE;
      }
    }
    String message = cardValidationClass.message;
    img = ImageUtils.resize(img, 640, 480);
    _validationCallBack(
        rawImg, img, cardValidationClass, validationResult, message);
  }

  int _getMaxIndexInNative(List<dynamic>? result) {
    double max = result![0];
    int maxIndex = 0;
    for (int i = 0; i < result.length; i++) {
      if (result[i] > max) {
        max = result[i];
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  int _getMaxIndex(List<double>? result) {
    double max = result![0];
    int maxIndex = 0;
    for (int i = 0; i < result.length; i++) {
      if (result[i] > max) {
        max = result[i];
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  bool _validation(CardValidationClass cardValidationClass) {
    if (cardValidationClass == CardValidationClass.valid_PASSPORT) {
      return true;
    } else if (_sdkConfig.step == ValidationStep.CARDFRONT) {
      if (cardValidationClass == CardValidationClass.valid_front_CCCD ||
          cardValidationClass == CardValidationClass.valid_front_CMND ||
          cardValidationClass == CardValidationClass.valid_front_chip) {
        return true;
      } else {
        return false;
      }
    } else if (_sdkConfig.step == ValidationStep.CARDBACK) {
      if (cardValidationClass == CardValidationClass.valid_back_CCCD ||
          cardValidationClass == CardValidationClass.valid_back_CMND ||
          cardValidationClass == CardValidationClass.valid_back_chip) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void changeCamera(CameraDescription cameraDescription) {
    _sdkConfig.cameraDescription = cameraDescription;
  }
}
