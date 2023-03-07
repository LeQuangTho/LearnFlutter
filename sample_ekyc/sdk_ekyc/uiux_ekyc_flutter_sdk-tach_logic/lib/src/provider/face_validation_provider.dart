import 'package:flutter/material.dart';
import 'package:uiux_ekyc_flutter_sdk/src/helper/face_validation_status.dart';

class FaceValidationNotifier extends ChangeNotifier {
  bool isRecording = false;
  bool canStart = false;
  String? arrowPath = null;
  String? iconPath = "assets/images/face_validate_straight_icon.png";
  // String step1Path = "assets/images/face_validate_step1_icon.png";
  String step1Path = "assets/images/Group 30Step1_icon.svg";
  String step2Path = "assets/images/face_validate_step2_icon.png";
  String step3Path = "assets/images/face_validate_step3_icon.png";
  String validationResult = "Đưa mặt vào khung hình";
  Color dividerStep12Color = Colors.white;
  Color dividerStep23Color = Colors.white;
  Color faceMaskBorderColor = Colors.white;
  late FaceValidationStatus faceValidateCurrentStatus;
  FaceValidationNotifier({required FaceValidationStatus currentStatus}) {
    faceValidateCurrentStatus = currentStatus;
  }

  void changeRecordStatus(bool status) {
    isRecording = status;
    notifyListeners();
  }

  void changeArrowPath(String path) {
    arrowPath = path;
    notifyListeners();
  }

  void changeCanStartStatus(bool status) {
    canStart = status;
    notifyListeners();
  }

  void changeValidationResult(String result) {
    validationResult = result;
    notifyListeners();
  }

  void updateFaceValidateCurrentStatus(FaceValidationStatus status) {
    faceValidateCurrentStatus = status;
    switch (faceValidateCurrentStatus) {
      case FaceValidationStatus.WAITING:
        print("Notify change to WAITING");
        iconPath = "assets/images/face_validate_straight_icon.png";
        step1Path = "assets/images/face_validate_step1_icon.png";
        step2Path = "assets/images/face_validate_step2_icon.png";
        step3Path = "assets/images/face_validate_step3_icon.png";
        arrowPath = null;
        validationResult = "Giữ thẳng khuôn mặt";
        dividerStep12Color = Colors.white;
        dividerStep23Color = Colors.white;
        break;
      case FaceValidationStatus.CHECKING_STRAIGHT:
        print("Notify change to CHECKING_STRAIGHT");
        iconPath = "assets/images/face_validate_straight_icon.png";
        step1Path = "assets/images/face_validate_step1_icon.png";
        step2Path = "assets/images/face_validate_step2_icon.png";
        step3Path = "assets/images/face_validate_step3_icon.png";
        validationResult = "Giữ thẳng khuôn mặt";
        faceMaskBorderColor = Colors.green;
        updateFaceMaskBorderNormal(time: 1000);
        break;
      case FaceValidationStatus.CHECKING_RIGHT:
        print("Notify change to CHECKING_RIGHT");
        // update step1 done
        step1Path = "assets/images/face_validate_step1_success_icon.png";

        // change status to right
        iconPath = "assets/images/face_validate_right_face.png";
        validationResult = "Quay phải";
        arrowPath = "assets/images/face_validate_right_arrow.png";

        updateFaceMaskBorderNormal(time: 1000);
        break;
      case FaceValidationStatus.CHECKING_LEFT:
        print("Notify change to CHECKING_LEFT");
        // update step2 done
        step2Path = "assets/images/face_validate_step2_success_icon.png";
        dividerStep12Color = Colors.green;
        faceMaskBorderColor = Colors.green;

        // change status to left
        iconPath = "assets/images/face_validate_left_face.png";
        validationResult = "Quay trái";
        arrowPath = "assets/images/face_validate_left_arrow.png";

        updateFaceMaskBorderNormal(time: 1000);
        break;
      case FaceValidationStatus.DONE:
        iconPath = null;
        validationResult = "Hoàn Thành";
        step3Path = "assets/images/face_validate_step3_success_icon.png";
        arrowPath = "assets/images/face_validate_done.png";
        dividerStep23Color = Colors.green;
        faceMaskBorderColor = Colors.green;
        break;
      default:
        print("Notify Unknown");
        iconPath = "assets/images/face_validate_straight_face.png";
        step1Path = "assets/images/face_validate_step1_icon.png";
        step2Path = "assets/images/face_validate_step2_icon.png";
        step3Path = "assets/images/face_validate_step3_icon.png";
        validationResult = "Đưa mặt vào khung hình";
    }

    print("Notify face validation notifyListeners");
    notifyListeners();
  }

  void resetStatus() {
    faceValidateCurrentStatus = FaceValidationStatus.WAITING;
    arrowPath = null;
    iconPath = "assets/images/face_validate_straight_icon.png";
    step1Path = "assets/images/face_validate_step1_icon.png";
    step2Path = "assets/images/face_validate_step2_icon.png";
    step3Path = "assets/images/face_validate_step3_icon.png";
    validationResult = "Đưa mặt vào khung hình";
    dividerStep12Color = Colors.white;
    dividerStep23Color = Colors.white;
    faceMaskBorderColor = Colors.white;
    notifyListeners();
  }

  void updateFaceMaskBorderNormal({int time = 300}) {
    if (time > 0) {
      Future.delayed(Duration(milliseconds: time), () {
        print("Notify change border to white");
        faceMaskBorderColor = Colors.white;
        notifyListeners();
      });
    }
  }
}
