import 'package:flutter/material.dart';

enum FaceValidationStatus {
  WAITING,
  CHECKING_STRAIGHT,
  CHECKING_RIGHT,
  CHECKING_LEFT,
  DONE
}

extension FaceValidationStatusExt on FaceValidationStatus {
  String get message {
    switch (this) {
      case FaceValidationStatus.WAITING:
        return 'Đưa mặt vào khung chụp';
      case FaceValidationStatus.CHECKING_STRAIGHT:
        return 'Giữ thẳng khuôn mặt';
      case FaceValidationStatus.CHECKING_RIGHT:
        return 'Quay mặt sang phải';
      case FaceValidationStatus.CHECKING_LEFT:
        return 'Quay mặt sang trái';
      case FaceValidationStatus.DONE:
        return 'Hoàn thành';
      default:
        return 'Unknown';
    }
  }

  Color get color {
    switch (this) {
      case FaceValidationStatus.WAITING:
        return Colors.white;
      case FaceValidationStatus.CHECKING_STRAIGHT:
        return Colors.white;
      case FaceValidationStatus.CHECKING_RIGHT:
        return Colors.white;
      case FaceValidationStatus.CHECKING_LEFT:
        return Colors.white;
      case FaceValidationStatus.DONE:
        return Colors.white;
    }
  }
}
