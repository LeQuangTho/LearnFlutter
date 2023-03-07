import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:ekyc_flutter_sdk/ekyc_flutter_sdk.dart';
import 'package:ekyc_flutter_sdk/src/utils/convert_image.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../ai_service/models/detection.dart';
import '../ai_service/detector.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:ekyc_flutter_sdk/src/utils/image_utils.dart';
import 'package:flutter/material.dart';

/// Manages separate Isolate instance for inference
class DetectIsolate {
  static const String DEBUG_NAME = "InferenceIsolate";

  late Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();
  SendPort? _sendPort;

  SendPort? get sendPort => _sendPort;

  void start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: DEBUG_NAME,
    );
    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);
    ImageConverter imageConverter = ImageConverter();
    // SortFlutter sortDart = SortFlutter(3, 1, 1, 0.3, 0.6, 1);
    var exist = [];
    await for (final IsolateData isolateData in port) {
      Detector detector = Detector(
          interpreter: Interpreter.fromAddress(isolateData.interpreterAddress));
      imglib.Image _img;

      if (Platform.isAndroid) {
        // _img = ImageUtils.convertCameraImage(isolateData.cameraImage)!;
        // _img = imglib.copyRotate(
        //     _img, isolateData.sdkConfig.cameraDescription.sensorOrientation);
        int startDetect = DateTime.now().millisecondsSinceEpoch;
        _img = imageConverter.convertYuvToRGBByC(isolateData.cameraImage);
        print(
            "Hubert detect time = ${DateTime.now().millisecondsSinceEpoch - startDetect}");
        _img = imglib.copyRotate(_img,
            isolateData.sdkConfig.cameraDescription.sensorOrientation - 90);
      } else {
        _img = ImageUtils.convertCameraImage(isolateData.cameraImage)!;
      }
      // detect full screen
      List<Detection>? _detections = detector.predict(_img);
      print("Hubert detections len = ${_detections!.length}");

      // crop box image
      imglib.Image boxImage =
          ImageUtils.cropImageFrontCamera(_img, isolateData.sdkConfig);

      // detect box screen
      // List<Detection>? _boxDetections = detector.predict(boxImage);

      List<Detection>? _boxDetections = [];
      if (_detections != null) {
        if (_detections.length == 1) {
          List<double> scaleList =
              computeMaskScale(_img, isolateData.sdkConfig);
          late double _cardAreaLeftScale = scaleList[0];
          late double _cardAreaTopScale = scaleList[1];
          late double _cardAreaWidthScale = scaleList[2];
          late double _cardAreaHeightScale = scaleList[3];

          double padding = 0;
          int imgHeight = _img.height;
          if (_img.height / _img.width > 1.9) {
            padding = _img.height - _img.width * 1.779;
            imgHeight = _img.height - padding.round();
          }

          int cropLeft = (_cardAreaLeftScale * _img.width).round();
          int cropTop = (_cardAreaTopScale * imgHeight + padding).round();
          int cropWidth = (_cardAreaWidthScale * _img.width).round();
          int cropHeight = (_cardAreaHeightScale * imgHeight).round();

          int xMin = (_detections[0].xMin * _img.width).round();
          int yMin = (_detections[0].yMin * _img.height).round();
          int height = (_detections[0].height * _img.height).round();
          int width = (_detections[0].width * _img.width).round();

          print("Check Face Inbox ===================================");
          print(cropLeft);
          print(cropTop);
          print(cropWidth);
          print(cropHeight);
          print(xMin);
          print(yMin);
          print(width);
          print(height);

          if (checkFaceInBox(cropLeft, cropTop, cropWidth, cropHeight, xMin,
              yMin, width, height)) {
            _boxDetections.add(_detections[0]);
            // Log.e("Hubert", "livenessResults.size(): " + livenessResults.size());
          }
        }
      }

      // return
      // 1 : default for detection
      print("Hubert _boxDetections len = ${_boxDetections.length}");
      isolateData.responsePort!
          .send([1, _detections, _img, _boxDetections, boxImage]);
    }
  }

  static bool checkFace(Detection detection, int imageWidth, int imageHeight,
      double screenWidth, double screenHeight) {
    const _CARD_ASPECT_RATIO = 1.5 / 1;
    const _OFFSET_X_FACTOR = 0.225;
    final screenRatio = screenWidth / screenHeight;
    final xScale = screenWidth.round() / imageHeight;
    final yScale = screenHeight.round() / imageWidth;

    final defaultX = _OFFSET_X_FACTOR * screenWidth.round();
    final defaultWidth = screenWidth.round() - defaultX * 2;
    final defaultHeight = defaultWidth * _CARD_ASPECT_RATIO;
    final defaultY =
        (screenHeight.round() - screenHeight.round() * 0.1 - defaultHeight) / 2;

    final x = imageHeight - detection.xMin * imageHeight * xScale;
    final y = detection.yMin * imageWidth * yScale;
    final w = detection.width * imageHeight * xScale;
    final h = detection.height * imageWidth * yScale;

    var iou = iou_score([
      x,
      y,
      x + w,
      y + h
    ], [
      defaultX,
      defaultY,
      defaultX + defaultWidth,
      defaultY + defaultHeight
    ]);
    // print("check iou score: ${iou}");
    if (defaultX < x &&
        defaultY < y &&
        (defaultX + defaultWidth) > (x + w) &&
        (defaultY + defaultHeight) > (y + h) &&
        iou > 0.3) return true;
    return false;
  }

  static double iou_score(
      List<double> boundingBox1, List<double> boundingBox2) {
    var xA = max(boundingBox1[0], boundingBox2[0]);
    var yA = max(boundingBox1[1], boundingBox2[1]);
    var xB = min(boundingBox1[2], boundingBox2[2]);
    var yB = min(boundingBox1[3], boundingBox2[3]);
    var interArea = max(0, xB - xA) * max(0, yB - yA);
    var boxAArea = (boundingBox1[2] - boundingBox1[0]) *
        (boundingBox1[3] - boundingBox1[1]);
    var boxBArea = (boundingBox2[2] - boundingBox2[0]) *
        (boundingBox2[3] - boundingBox2[1]);
    var iou = interArea / (boxAArea + boxBArea - interArea);
    return iou;
  }

  static int matchingDetection(
      List<double> re, List<Detection> detections, int height, int width) {
    for (int i = 0; i < detections.length; i++) {
      double iou = iou_score_for_detection(detections[i], re, height, width);
      if (iou > 0.3) {
        return i;
      }
    }
    return -1;
  }

  static double iou_score_for_detection(
      Detection detection, List<double> boundingBox, int height, int width) {
    double testX1 = height * detection.xMin;
    double testY1 = width * detection.yMin;
    double testX2 = height * (detection.width + detection.xMin);
    double testY2 = width * (detection.height + detection.yMin);

    var xA = max(testX1, boundingBox[0]);
    var yA = max(testY1, boundingBox[1]);
    var xB = min(testX2, boundingBox[2]);
    var yB = min(testY2, boundingBox[3]);

    var interArea = max(0, xB - xA + 1) * max(0, yB - yA + 1);
    var boxAArea = (testX2 - testX1 + 1) * (testY2 - testY1 + 1);
    var boxBArea = (boundingBox[2] - boundingBox[0] + 1) *
        (boundingBox[3] - boundingBox[1] + 1);

    var iou = interArea / (boxAArea + boxBArea - interArea);
    return iou;
  }

  static bool checkFaceInBox(int boxLeft, int boxTop, int boxWidth,
      int boxHeight, int faceLeft, int faceTop, int faceWidth, int FaceHeight) {
    if (faceLeft >= boxLeft &&
        faceTop >= boxTop &&
        (faceLeft + faceWidth) <= (boxLeft + boxWidth) &&
        (faceTop + FaceHeight) <= (boxTop + boxHeight + boxHeight / 5)) {
      return true;
    }
    return false;
  }

  static List<double> computeMaskScale(imglib.Image img, SdkConfig sdkConfig) {
    late double _cardAreaLeftScale;
    late double _cardAreaTopScale;
    late double _cardAreaWidthScale;
    late double _cardAreaHeightScale;

    double sizeAspectRatio = sdkConfig.screenSize.aspectRatio;
    double imageAspectRatio = img.height / img.width;
    double scale = sizeAspectRatio * imageAspectRatio;

    if (scale < 1) {
      // image width fit screen width -> cut image width
      double realImageWidth =
          (sdkConfig.screenSize.height * img.width) / img.height;
      double marginWidth = realImageWidth - sdkConfig.screenSize.width;
      _cardAreaLeftScale =
          (sdkConfig.maskViewSize.left + marginWidth / 2) / realImageWidth;
      _cardAreaTopScale =
          sdkConfig.maskViewSize.top / sdkConfig.screenSize.height;
      _cardAreaWidthScale = sdkConfig.maskViewSize.width / realImageWidth;
      _cardAreaHeightScale =
          sdkConfig.maskViewSize.height / sdkConfig.screenSize.height;
    } else {
      // image height fit screen height -> cut image height
      double realImageHeight =
          (sdkConfig.screenSize.width * img.height) / img.width;
      double marginHeight = realImageHeight - sdkConfig.screenSize.height;

      _cardAreaLeftScale =
          sdkConfig.maskViewSize.left / sdkConfig.screenSize.width;
      _cardAreaTopScale =
          (sdkConfig.maskViewSize.top + marginHeight / 2) / realImageHeight;
      _cardAreaWidthScale =
          sdkConfig.maskViewSize.width / sdkConfig.screenSize.width;
      _cardAreaHeightScale = sdkConfig.maskViewSize.height / realImageHeight;
    }
    return [
      _cardAreaLeftScale,
      _cardAreaTopScale,
      _cardAreaWidthScale,
      _cardAreaHeightScale
    ];
  }
}

/// Bundles data to pass between Isolate
class IsolateData {
  CameraImage cameraImage;
  int interpreterAddress;
  SendPort? responsePort;
  SdkConfig sdkConfig;

  IsolateData(this.cameraImage, this.interpreterAddress, this.sdkConfig);
}
