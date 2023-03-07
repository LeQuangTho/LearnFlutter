import 'package:ekyc_flutter_sdk/src/ai_service/detector.dart';
import 'package:ekyc_flutter_sdk/src/utils/image_utils.dart';
import 'package:ekyc_flutter_sdk/src/utils/throttler.dart';
import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';
import 'package:ekyc_flutter_sdk/src/utils/sdk_config.dart';
import 'package:ekyc_flutter_sdk/src/utils/detect_isolate.dart';
import 'package:ekyc_flutter_sdk/src/utils/face_liveness_isolate.dart';
import 'dart:isolate';
import 'dart:async';
import 'package:ekyc_flutter_sdk/src/ai_service/models/detection.dart';
import 'package:ekyc_flutter_sdk/src/ai_service/face_liveness.dart';
import 'package:ekyc_flutter_sdk/src/callback/face_validation_callback.dart';
import 'package:ekyc_flutter_sdk/src/utils/face_validation_response_handler.dart';
import 'dart:io';
import 'package:ekyc_flutter_sdk/src/utils/native_plugin.dart';
import 'package:ekyc_flutter_sdk/src/utils/throttler.dart';
import 'package:path_provider/path_provider.dart';

enum FaceValidationStep { WAIT, STRAIGHT, RIGHT, LEFT, DONE }

class FaceValidation {
  Detector? _detector;
  FaceLiveness? _faceLiveness;
  DetectIsolate? _isolateUtils;
  FaceLivenessIsolate? _faceLivenessIsolate;

  late ReceivePort _receivePort = ReceivePort();

  late bool _isDetecting = false;
  late bool _isRecog = false;
  late SdkConfig _sdkConfig;
  FaceDetectionCallBack? _faceDetectionCallBack;
  FaceLivenessCallBack? _faceLivenessCallBack;
  late FaceValidationStep _currentStep;
  late double currentSmallFaceThreshold;
  late int imageHeight, imageWidth, maskLeft, maskTop, maskWidth, maskHeight;

  late List<Detection> _forRecogDetections;
  late imglib.Image _forRecogImg;
  late List<Detection> _forRecogFaceInCenterBox;
  late imglib.Image _forRecogBoxImage;
  late var throttler;
  bool isInitConfig = false;
  bool isUsingNative = false;

  FaceValidation(SdkConfig sdkConfig,
      {FaceDetectionCallBack? faceDetectionCallBack,
      FaceLivenessCallBack? faceLivenessCallBack,
      double smallFaceThreshold = 0.5,
      int throttlerTime = 300}) {
    currentSmallFaceThreshold = smallFaceThreshold;
    _currentStep = FaceValidationStep.WAIT;
    _sdkConfig = sdkConfig;
    _faceDetectionCallBack = faceDetectionCallBack;
    _faceLivenessCallBack = faceLivenessCallBack;
    throttler = Throttler(throttlerTime);
    if (Platform.isAndroid && isUsingNative) {
      initModel();
    } else {
      _detector = Detector();
      _faceLiveness = FaceLiveness();
      _isolateUtils = DetectIsolate();
      _isolateUtils!.start();
      _faceLivenessIsolate = FaceLivenessIsolate();
      _faceLivenessIsolate!.start();
      _listenDetect();
    }
  }

  initModel() async {
    await NativePlugin.loadModel(
      model:
          "packages/ekyc_flutter_sdk/assets/models/face_detection_front.tflite",
      modelType: "faceDetection",
      numThreads: 1, // defaults to 1
      isAsset:
          true, // defaults to true, set to false to load resources outside assets
    );
    await NativePlugin.loadModel(
      model:
          "packages/ekyc_flutter_sdk/assets/models/Faceliveness_mobilenetv2_0.25_mymodel_3_train_01042022_export_01042022.tflite",
      modelType: "faceLiveness",
      numThreads: 1, // defaults to 1
      isAsset:
          true, // defaults to true, set to false to load resources outside assetsx
    );
  }

  _listenDetect() async {
    final Stream<dynamic> receiveBroadcast = _receivePort.asBroadcastStream();
    StreamSubscription<dynamic> subscription;
    subscription = receiveBroadcast.listen(
      (dynamic result) {
        var status = result.first;
        if (status == 1) {
          List<Detection> _detections = result[1];
          imglib.Image img = result[2];
          List<Detection> faceInCenterBox = result[3];
          imglib.Image boxImage = result[4];
          _faceDetectValidation(_detections, img, faceInCenterBox, boxImage);
          if (_isRecog == false) {
            _forRecogDetections = _detections;
            _forRecogImg = img;
            _forRecogFaceInCenterBox = faceInCenterBox;
            _forRecogBoxImage = boxImage;
            _isRecog = true;
            // saveImageToDevice(boxImage);
            if (_forRecogFaceInCenterBox.length == 1) {
              FaceLivenessIsolateData faceLivenessIsolateData =
                  FaceLivenessIsolateData(_forRecogFaceInCenterBox,
                      _forRecogBoxImage, _faceLiveness!.interpreter!.address);
              _faceLivenessIsolate!.sendPort!.send(faceLivenessIsolateData
                ..responsePort = _receivePort.sendPort);
            } else {
              _faceLivenessValidation(null, _forRecogBoxImage);
              _isRecog = false;
            }
          }
          _isDetecting = false;
        } else if (status == 2) {
          var livenessResult = result[1];
          imglib.Image img = result[2];
          _faceLivenessValidation(livenessResult, _forRecogBoxImage);
          _isRecog = false;
        }
      },
    );
  }

  void _faceLivenessValidation(List<double>? livenessResult, imglib.Image img) {
    if (_forRecogFaceInCenterBox.length == 1 && livenessResult != null) {
      int maxIndex = _getMaxIndex(livenessResult);
      FaceValidationClass faceValidationClass =
          convertFaceLivenessClass(maxIndex);

      // check small face
      int faceWidth = (_forRecogFaceInCenterBox[0].width * imageWidth).round();
      // if ((_forRecogFaceInCenterBox[0].width *
      //         _forRecogFaceInCenterBox[0].height) <
      //     currentSmallFaceThreshold) {
      if ((faceWidth / maskWidth) < currentSmallFaceThreshold) {
        faceValidationClass = FaceValidationClass.SMALL_FACE;
      }

      late bool validationResult;
      if (faceValidationClass == FaceValidationClass.VALID) {
        validationResult = true;
      } else {
        validationResult = false;
      }

      if (_faceLivenessCallBack != null) {
        _faceLivenessCallBack!(validationResult, faceValidationClass.name,
            faceValidationClass.vnMessage);
      }
    } else {
      bool validationResult = false;
      late FaceValidationClass faceValidationClass =
          FaceValidationClass.NO_FACE;

      // co nhieu face
      if (_forRecogDetections.length > 1) {
        faceValidationClass = FaceValidationClass.TWO_FACE;
      }
      if (_faceLivenessCallBack != null) {
        _faceLivenessCallBack!(validationResult, faceValidationClass.name,
            faceValidationClass.vnMessage);
      }
    }
  }

  void _nativeFaceLivenessValidation(
      List<Detection> detections, List<double> livenessResult) {
    if (detections.length == 1 && livenessResult.isNotEmpty) {
      int maxIndex = _getMaxIndex(livenessResult);
      FaceValidationClass faceValidationClass =
          convertFaceLivenessClass(maxIndex);

      // check small face
      int faceWidth = (detections[0].width * imageWidth).round();
      if ((faceWidth / maskWidth) < currentSmallFaceThreshold) {
        faceValidationClass = FaceValidationClass.SMALL_FACE;
      }

      late bool validationResult;
      if (faceValidationClass == FaceValidationClass.VALID) {
        validationResult = true;
      } else {
        validationResult = false;
      }

      if (_faceLivenessCallBack != null) {
        _faceLivenessCallBack!(validationResult, faceValidationClass.name,
            faceValidationClass.vnMessage);
      }
    } else {
      bool validationResult = false;
      late FaceValidationClass faceValidationClass =
          FaceValidationClass.NO_FACE;

      // co nhieu face
      if (detections.length > 1) {
        faceValidationClass = FaceValidationClass.TWO_FACE;
      }
      if (_faceLivenessCallBack != null) {
        _faceLivenessCallBack!(validationResult, faceValidationClass.name,
            faceValidationClass.vnMessage);
      }
    }
  }

  void _faceDetectValidation(
    List<Detection> detections,
    imglib.Image img,
    List<Detection> faceInCenterBox,
    imglib.Image boxImg,
  ) {
    late String message;
    late bool detectResult;
    late double leftAndRightPercent;
    late FaceValidationClass faceValidationClass;

    // co nhieu face
    if (detections.length > 1) {
      faceValidationClass = FaceValidationClass.TWO_FACE;
      detectResult = false;
      leftAndRightPercent = 0;
    } else {
      // get face in box
      if (faceInCenterBox.length == 0) {
        // ko co face in box
        faceValidationClass = FaceValidationClass.NO_FACE;
        detectResult = false;
        leftAndRightPercent = 0;
      } else {
        // check left and right percent
        faceValidationClass = FaceValidationClass.VALID;
        double sLeft = _triangle_area(
            faceInCenterBox[0].landmark[4].x,
            faceInCenterBox[0].landmark[4].y,
            faceInCenterBox[0].landmark[0].x,
            faceInCenterBox[0].landmark[0].y,
            faceInCenterBox[0].landmark[3].x,
            faceInCenterBox[0].landmark[3].y);
        double sRight = _triangle_area(
            faceInCenterBox[0].landmark[5].x,
            faceInCenterBox[0].landmark[5].y,
            faceInCenterBox[0].landmark[1].x,
            faceInCenterBox[0].landmark[1].y,
            faceInCenterBox[0].landmark[3].x,
            faceInCenterBox[0].landmark[3].y);
        leftAndRightPercent = _computePercent(sRight, sLeft);
        detectResult = true;
      }
    }
    if (_faceDetectionCallBack != null) {
      _faceDetectionCallBack!(
          faceInCenterBox,
          boxImg,
          detectResult,
          faceValidationClass.name,
          faceValidationClass.vnMessage,
          leftAndRightPercent);
    }
  }

  void _nativeFaceDetectValidation(List<Detection> detections) {
    late String message;
    late bool detectResult;
    late double leftAndRightPercent;
    late FaceValidationClass faceValidationClass;
    if (detections.length > 1) {
      faceValidationClass = FaceValidationClass.TWO_FACE;
      detectResult = false;
      leftAndRightPercent = 0;
    } else {
      if (detections.length == 0) {
        // ko co face in box
        faceValidationClass = FaceValidationClass.NO_FACE;
        detectResult = false;
        leftAndRightPercent = 0;
      } else {
        faceValidationClass = FaceValidationClass.VALID;
        double sLeft = _triangle_area(
            detections[0].landmark[4].x,
            detections[0].landmark[4].y,
            detections[0].landmark[0].x,
            detections[0].landmark[0].y,
            detections[0].landmark[3].x,
            detections[0].landmark[3].y);
        double sRight = _triangle_area(
            detections[0].landmark[5].x,
            detections[0].landmark[5].y,
            detections[0].landmark[1].x,
            detections[0].landmark[1].y,
            detections[0].landmark[3].x,
            detections[0].landmark[3].y);
        leftAndRightPercent = _computePercent(sRight, sLeft);
        detectResult = true;
      }
    }
    if (_faceDetectionCallBack != null) {
      _faceDetectionCallBack!(
          detections,
          null,
          detectResult,
          faceValidationClass.name,
          faceValidationClass.vnMessage,
          leftAndRightPercent);
    }
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

  double _computePercent(double rightArea, double leftArea) {
    double leftAndRightRatio = leftArea / (rightArea + leftArea);
    double percent = (leftAndRightRatio - 0.5) / 0.3; // 0.3 = 0.8 - 0.5
    if (percent > 1) {
      percent = 100;
    } else if (percent < -1) {
      percent = -100;
    } else {
      percent = percent * 100;
    }
    // double a = leftArea / (leftArea + rightArea);
    // return 100 * (1 - a * 2);
    if (_sdkConfig.cameraDescription.lensDirection ==
        CameraLensDirection.back) {
      return -percent;
    } else if (Platform.isAndroid) {
      return -percent;
    } else {
      return percent;
    }
  }

  double _triangle_area(double cheekX, double cheekY, double eyeX, double eyeY,
      double mouthX, double mouthY) {
    double x_min = _minIn3Number(cheekX, eyeX, mouthX);
    double y_min = _minIn3Number(cheekY, eyeY, mouthY);
    double x_max = _maxIn3Number(cheekX, eyeX, mouthX);
    double y_max = _maxIn3Number(cheekY, eyeY, mouthY);

    double area_rectangle = (y_max - y_min) * (x_max - x_min);
    double t1 = (0.5 * ((eyeX - mouthX) * (eyeY - mouthY)).abs());
    double t2 = (0.5 * ((eyeX - cheekX) * (eyeY - cheekY)).abs());
    double t3 = (0.5 * ((mouthX - cheekX) * (mouthY - cheekY)).abs());
    return area_rectangle - t1 - t2 - t3;
  }

  double _minIn3Number(double x, double y, double z) {
    if (x < y) {
      if (x < z)
        return x;
      else
        return z;
    } else {
      if (y < z)
        return y;
      else
        return z;
    }
  }

  double _maxIn3Number(double x, double y, double z) {
    if (x < y) {
      if (y < z)
        return z;
      else
        return y;
    } else {
      if (x < z)
        return z;
      else
        return x;
    }
  }

  void _initConfig(CameraImage img) {
    if (img.height < img.width) {
      imageHeight = img.width;
      imageWidth = img.height;
    } else {
      imageHeight = img.height;
      imageWidth = img.width;
    }
    late double _cardAreaLeftScale;
    late double _cardAreaTopScale;
    late double _cardAreaWidthScale;
    late double _cardAreaHeightScale;

    double sizeAspectRatio = _sdkConfig.screenSize.aspectRatio;
    double imageAspectRatio = imageHeight / imageWidth;
    double scale = sizeAspectRatio * imageAspectRatio;

    if (scale < 1) {
      // image width fit screen width -> cut image width
      double realImageWidth =
          (_sdkConfig.screenSize.height * imageWidth) / imageHeight;
      double marginWidth = realImageWidth - _sdkConfig.screenSize.width;
      _cardAreaLeftScale =
          (_sdkConfig.maskViewSize.left + marginWidth / 2) / realImageWidth;
      _cardAreaTopScale =
          _sdkConfig.maskViewSize.top / _sdkConfig.screenSize.height;
      _cardAreaWidthScale = _sdkConfig.maskViewSize.width / realImageWidth;
      _cardAreaHeightScale =
          _sdkConfig.maskViewSize.height / _sdkConfig.screenSize.height;
    } else {
      // image height fit screen height -> cut image height
      double realImageHeight =
          (_sdkConfig.screenSize.width * imageHeight) / imageWidth;
      double marginHeight = realImageHeight - _sdkConfig.screenSize.height;

      _cardAreaLeftScale =
          _sdkConfig.maskViewSize.left / _sdkConfig.screenSize.width;
      _cardAreaTopScale =
          (_sdkConfig.maskViewSize.top + marginHeight / 2) / realImageHeight;
      _cardAreaWidthScale =
          _sdkConfig.maskViewSize.width / _sdkConfig.screenSize.width;
      _cardAreaHeightScale = _sdkConfig.maskViewSize.height / realImageHeight;
    }

    maskLeft = (_cardAreaLeftScale * imageWidth).round();
    maskTop = (_cardAreaTopScale * imageHeight).round();
    maskWidth = (_cardAreaWidthScale * imageWidth).round();
    maskHeight = (_cardAreaHeightScale * imageHeight).round();
  }

  void _runNativeDetect(CameraImage cameraImage) async {
    List<dynamic>? result = await NativePlugin.runFaceValidationOnFrame(
        cameraImage: cameraImage, sdkConfig: _sdkConfig);
    if (result == null) {
    } else {
      List<Detection> detections = [];
      List<double> livenessResult = [];
      for (int i = 0; i < result.length; i++) {
        if (result[i]['type'] == 'Detection') {
          detections.add(Detection.fromMap(result[i]));
        } else {
          var tmpLivenessResult = result[i]['liveness'];
          if (tmpLivenessResult != 'null') {
            for (int i = 0; i < tmpLivenessResult.length; i++) {
              livenessResult.add(double.parse(tmpLivenessResult[i].toString()));
            }
          }
        }
      }
      _nativeFaceDetectValidation(detections);
      _nativeFaceLivenessValidation(detections, livenessResult);
    }
    _isDetecting = false;
  }

  runDetect(CameraImage cameraImage) async {
    if (!isInitConfig) {
      _initConfig(cameraImage);
      isInitConfig = true;
    }
    throttler.run(() {
      if (Platform.isAndroid && isUsingNative) {
        if (_isDetecting) return;
        _isDetecting = true;
        _runNativeDetect(cameraImage);
      } else {
        if (_isDetecting || _isolateUtils!.sendPort == null) return;
        _isDetecting = true;
        imglib.Image _img;
        var isolateData = IsolateData(
            cameraImage, _detector!.interpreter!.address, _sdkConfig);
        // ReceivePort responsePort = ReceivePort();
        _isolateUtils!.sendPort!
            .send(isolateData..responsePort = _receivePort.sendPort);
      }
    });
  }

  void changeCamera(CameraDescription cameraDescription) {
    _sdkConfig.cameraDescription = cameraDescription;
  }

  void saveImageToDevice(imglib.Image img) async {
    List<int> faceListInt = imglib.JpegEncoder().encodeImage(img);
    final appDir = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory();
    final appPath = appDir!.path;
    final fileOnDevice =
        File('$appPath/${DateTime.now().millisecondsSinceEpoch}.jpg');
    File file = await fileOnDevice.writeAsBytes(faceListInt, flush: true);
    print("face save on ${file.path}");
  }
}
