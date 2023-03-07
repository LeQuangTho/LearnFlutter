import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;
import 'package:ekyc_flutter_sdk/ekyc_flutter_sdk.dart';
import 'dart:async';

// detection len == 1
// livenessResult == truel
// currentStep == WAITING
// ---> co the start
typedef void RealTimeCallBack(
  List<Detection> detection,
  bool livenessResult,
  double leftAndRigtPercent,
  FaceValidationViewModelStep currentStep,
);

typedef void FaceValidationSuccess(
  bool inSuccess,
  String message,
);

typedef void FaceValidationFailed(
  bool inSuccess,
  String errorCode,
  String message,
);

typedef void FaceValidationCheckStraightResult(
  bool inSuccess,
  String errorCode,
  String message,
  FaceValidationViewModelStep nextStep,
);

typedef void FaceValidationCheckLeftResult(
  bool inSuccess,
  String errorCode,
  String message,
  FaceValidationViewModelStep nextStep,
);

typedef void FaceValidationCheckRightResult(
  bool inSuccess,
  String errorCode,
  String message,
  FaceValidationViewModelStep nextStep,
);

enum FaceValidationViewModelStep {
  WAITING,
  CHECKING_STRAIGHT,
  CHECKING_RIGHT,
  CHECKING_LEFT,
  DONE
}

extension FaceValidationViewModelStepExt on FaceValidationViewModelStep {
  String get message {
    switch (this) {
      case FaceValidationViewModelStep.WAITING:
        return 'Đưa mặt vào khung chụp';
      case FaceValidationViewModelStep.CHECKING_STRAIGHT:
        return 'Giữ thẳng khuôn mặt';
      case FaceValidationViewModelStep.CHECKING_RIGHT:
        return 'Quay mặt sang phải';
      case FaceValidationViewModelStep.CHECKING_LEFT:
        return 'Quay mặt sang trái';
      case FaceValidationViewModelStep.DONE:
        return 'Hoàn thành';
      default:
        return 'Unknown';
    }
  }
}

// chua implement rule
// chua implement ham tra lai ket qua
// chua dinh nghia cac interface output
class FaceValidationViewModel {
  late FaceValidation faceValidation;
  late SdkConfig sdkConfig;
  late Size screenSize;
  late MaskView maskView;
  late Size maskSize;
  late bool isRecording = false;
  late CameraDescription choosenCamera;
  late double cardAreaLeft, cardAreaTop, cardAreaWidth, cardAreaHeight;
  Timer? _timer;
  int _start = 7;
  bool checkStraight = false;
  bool checkRight = false;
  bool checkLeft = false;
  int countFailFrame = 0;
  int maxFromeFailed = 10;
  FaceValidationViewModelStep _faceValidationStep =
      FaceValidationViewModelStep.WAITING;
  RealTimeCallBack? realTimeCallBack;
  FaceValidationSuccess? faceValidationSuccess;
  FaceValidationCheckStraightResult? faceValidationCheckStraightResult;
  FaceValidationCheckRightResult? faceValidationCheckRightResult;
  FaceValidationCheckLeftResult? faceValidationCheckLeftResult;
  late List<Detection> detections;
  bool livenessResult = false;
  double currentLeftAndRigtPercent = 0;

  FaceValidationViewModel(
    RealTimeCallBack newRealTimeCallBack,
    FaceValidationSuccess newFaceValidationSuccess,
    FaceValidationCheckStraightResult newFaceValidationCheckStraightResult,
    FaceValidationCheckRightResult newFaceValidationCheckRightResult,
    FaceValidationCheckLeftResult newFaceValidationCheckLeftResult, {
    required screenSize,
    required choosenCamera,
    required cardAreaLeft,
    required cardAreaTop,
    required cardAreaWidth,
    required cardAreaHeight,
  }) {
    print("init FaceValidationViewModel");
    maskView =
        MaskView(cardAreaLeft, cardAreaTop, cardAreaWidth, cardAreaHeight);
    sdkConfig =
        SdkConfig(screenSize, maskView, ValidationStep.FACE, choosenCamera);
    detections = [];
    faceValidation = FaceValidation(
      sdkConfig,
      faceDetectionCallBack: _faceDetectCallBack,
      faceLivenessCallBack: _faceLivenessCallBack,
    );
    print("init newRealTimeCallBack");
    realTimeCallBack = newRealTimeCallBack;
    faceValidationSuccess = newFaceValidationSuccess;
    faceValidationCheckStraightResult = newFaceValidationCheckRightResult;
    faceValidationCheckLeftResult = newFaceValidationCheckLeftResult;
    faceValidationCheckRightResult = newFaceValidationCheckRightResult;
  }

  void runDetect(CameraImage image) {
    faceValidation.runDetect(image);
  }

  void _faceDetectCallBack(
      List<Detection> detection,
      imglib.Image? img,
      bool detectResult,
      String resultName,
      String message,
      double leftAndRigtPercent) {
    detections = detection;
    currentLeftAndRigtPercent = leftAndRigtPercent;
    if (isRecording == true) {
      if (detectResult == false) {
        countFailFrame += 1;
        print("Hubert count = $countFailFrame");
        if (countFailFrame == maxFromeFailed) {
          // sai 3 frame lien tiep
          // reset
          _start = 7;
          checkLeft = false;
          checkRight = false;
          checkStraight = false;
          _faceValidationStep = FaceValidationViewModelStep.WAITING;
          stopTime();
          // bao cho hostapp update status
          if (realTimeCallBack != null)
            realTimeCallBack!(detections, livenessResult,
                currentLeftAndRigtPercent, _faceValidationStep);
          return;
        }
      } else {
        countFailFrame = 0;
      }
      // check chinh giua
      if (_faceValidationStep ==
          FaceValidationViewModelStep.CHECKING_STRAIGHT) {
        if (!checkStraight &&
            detectResult &&
            -50 < leftAndRigtPercent &&
            leftAndRigtPercent < 50) {
          checkStraight = true;
        }
      }
      // check phai
      if (_faceValidationStep == FaceValidationViewModelStep.CHECKING_RIGHT) {
        if (!checkRight && leftAndRigtPercent > 60) {
          checkRight = true;
        }
      }
      // check trai
      if (_faceValidationStep == FaceValidationViewModelStep.CHECKING_LEFT) {
        if (!checkLeft && leftAndRigtPercent < -60) {
          checkLeft = true;
        }
      }
    }
  }

  void _faceLivenessCallBack(
      bool livenessResult, String resultName, String message) {
    livenessResult = livenessResult;
    if (isRecording == false) {
      if (!livenessResult) {
        // bao cho hostapp update status
        // chua the bat dau
        if (realTimeCallBack != null)
          realTimeCallBack!(detections, livenessResult,
              currentLeftAndRigtPercent, _faceValidationStep);
      } else {
        // bao cho hostapp update status
        // co the bat dau
        if (realTimeCallBack != null)
          realTimeCallBack!(detections, livenessResult,
              currentLeftAndRigtPercent, _faceValidationStep);
      }
    } else {
      if (!livenessResult && resultName != "SMALL_FACE") {
        countFailFrame += 1;
        print("Hubert count = $countFailFrame");
        if (countFailFrame == maxFromeFailed) {
          // failed 3 frame lien tiep
          // reset status
          _start = 7;
          checkLeft = false;
          checkRight = false;
          checkStraight = false;
          _faceValidationStep = FaceValidationViewModelStep.WAITING;
          stopTime();
          // bao cho hostapp update status
          if (realTimeCallBack != null)
            realTimeCallBack!(detections, livenessResult,
                currentLeftAndRigtPercent, _faceValidationStep);
        }
      } else {
        countFailFrame = 0;
      }
    }
  }

  void startRecord() {
    isRecording = true;
    _faceValidationStep = FaceValidationViewModelStep.CHECKING_STRAIGHT;
    startTimer();
  }

  void stopTime() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        print("Notify _start == $_start");
        if (_start == 0) {
          if (!checkLeft) {
            // chua bat dc mat quay trai
            _start = 7;
            checkLeft = false;
            checkRight = false;
            checkStraight = false;
            _faceValidationStep = FaceValidationViewModelStep.WAITING;
            if (faceValidationCheckLeftResult != null)
              faceValidationCheckRightResult!(false, "Failed", "Failed",
                  FaceValidationViewModelStep.WAITING);
            stopTime();
          } else {
            // liveness done
            _faceValidationStep = FaceValidationViewModelStep.DONE;
            if (faceValidationCheckLeftResult != null)
              faceValidationCheckRightResult!(
                  true, "Success", "Success", FaceValidationViewModelStep.DONE);
            if (faceValidationSuccess != null)
              faceValidationSuccess!(true, "Success");
          }
        } else {
          if (_start == 6) {
            // count done straight
            if (!checkStraight) {
              // chua bat dc mat chinh giua
              // reset lai tu dau
              _start = 8;
              checkLeft = false;
              checkRight = false;
              checkStraight = false;
              _faceValidationStep = FaceValidationViewModelStep.WAITING;
              stopTime();
              // bao cho hostapp update status
              if (faceValidationCheckStraightResult != null)
                faceValidationCheckStraightResult!(false, "False", "False",
                    FaceValidationViewModelStep.WAITING);
            } else {
              // done chinh giua chuyen sang quay phai
              _faceValidationStep = FaceValidationViewModelStep.CHECKING_RIGHT;
              // bao cho hostapp update status
              if (faceValidationCheckStraightResult != null)
                faceValidationCheckStraightResult!(true, "Success", "Success",
                    FaceValidationViewModelStep.CHECKING_RIGHT);
            }
          }
          if (_start == 3) {
            // count done right
            if (!checkRight) {
              // chua bat dc mat quay phai
              // reset lai tu dau
              _start = 8;
              checkLeft = false;
              checkRight = false;
              checkStraight = false;
              _faceValidationStep = FaceValidationViewModelStep.WAITING;
              stopTime();
              // bao cho hostapp update status
              if (faceValidationCheckRightResult != null)
                faceValidationCheckRightResult!(false, "False", "False",
                    FaceValidationViewModelStep.WAITING);
            } else {
              // done chinh giua chuyen sang quay trai
              _faceValidationStep = FaceValidationViewModelStep.CHECKING_LEFT;
              // bao cho hostapp update status
              if (faceValidationCheckRightResult != null)
                faceValidationCheckRightResult!(true, "Success", "Success",
                    FaceValidationViewModelStep.CHECKING_LEFT);
            }
          }
          _start--;
        }
      },
    );
  }
}
