enum FaceValidationClass {
  VALID,
  HAND,
  MASK,
  SUNGLASSES,
  COVER,
  LOW_QUALITY,
  NO_FACE,
  SMALL_FACE,
  BIG_FACE,
  TWO_FACE,
  NO_FACE_FRONT,
  NO_FACE_RIGHT,
  NO_FACE_LEFT,
  MISS_TRACKING_FACE,
  DEEPFAKE,
  CLOSE_EYES
}

extension FaceValidationClassExt on FaceValidationClass {
  String get name {
    switch (this) {
      case FaceValidationClass.VALID:
        return "VALID";
      case FaceValidationClass.HAND:
        return "HAND";
      case FaceValidationClass.MASK:
        return "MASK";
      case FaceValidationClass.SUNGLASSES:
        return "SUNGLASSES";
      case FaceValidationClass.COVER:
        return "COVER";
      case FaceValidationClass.NO_FACE:
        return "NO_FACE";
      case FaceValidationClass.SMALL_FACE:
        return "SMALL_FACE";
      case FaceValidationClass.BIG_FACE:
        return "BIG_FACE";
      case FaceValidationClass.TWO_FACE:
        return "TWO_FACE";
      case FaceValidationClass.NO_FACE_FRONT:
        return "NO_FACE_FRONT";
      case FaceValidationClass.NO_FACE_RIGHT:
        return "NO_FACE_RIGHT";
      case FaceValidationClass.NO_FACE_LEFT:
        return "NO_FACE_LEFT";
      case FaceValidationClass.MISS_TRACKING_FACE:
        return "MISS_TRACKING_FACE";
      case FaceValidationClass.DEEPFAKE:
        return "DEEPFAKE";
      case FaceValidationClass.CLOSE_EYES:
        return "CLOSE_EYES";
      default:
        return "INVALID";
    }
  }

  String get errorCode {
    switch (this) {
      case FaceValidationClass.HAND:
        return "E319";
      case FaceValidationClass.MASK:
        return "E303";
      case FaceValidationClass.SUNGLASSES:
        return "E301";
      case FaceValidationClass.COVER:
        return "E300";
      case FaceValidationClass.NO_FACE:
        return "E309";
      case FaceValidationClass.SMALL_FACE:
        return "E304";
      case FaceValidationClass.TWO_FACE:
        return "E307";
      case FaceValidationClass.NO_FACE_FRONT:
        return "E313";
      case FaceValidationClass.NO_FACE_RIGHT:
        return "E311";
      case FaceValidationClass.NO_FACE_LEFT:
        return "E311";
      case FaceValidationClass.DEEPFAKE:
        return "E311";
      case FaceValidationClass.CLOSE_EYES:
        return "E310";
      default:
        return "NO_ERROR_CODE";
    }
  }

  String get vnMessage {
    switch (this) {
      case FaceValidationClass.VALID:
        return "Khuôn mặt hợp lệ";
      case FaceValidationClass.HAND:
      case FaceValidationClass.MASK:
      case FaceValidationClass.SUNGLASSES:
      case FaceValidationClass.COVER:
        return "Không che mặt";
      case FaceValidationClass.NO_FACE:
        return "Đưa mặt vào trong khung hình";
      case FaceValidationClass.SMALL_FACE:
        return "Đưa mặt lại gần";
      case FaceValidationClass.BIG_FACE:
        return "Đưa mặt ra xa khung chụp";
      case FaceValidationClass.TWO_FACE:
        return "Đảm bảo chỉ có 1 khuôn mặt trong khung hình";
      case FaceValidationClass.NO_FACE_FRONT:
        return "Giữ thẳng khuôn mặt";
      case FaceValidationClass.NO_FACE_RIGHT:
        return "Quay phải";
      case FaceValidationClass.NO_FACE_LEFT:
        return "Quay trái";
      case FaceValidationClass.MISS_TRACKING_FACE:
        return "Giữ khuôn mặt trong khung chụp";
      case FaceValidationClass.DEEPFAKE:
      case FaceValidationClass.CLOSE_EYES:
        return "Khuôn mặt không hợp lệ";
      default:
        return "Không tồn tại";
    }
  }

  String get enMessage {
    switch (this) {
      case FaceValidationClass.VALID:
        return "Valid Face";
      case FaceValidationClass.HAND:
      case FaceValidationClass.MASK:
      case FaceValidationClass.SUNGLASSES:
      case FaceValidationClass.COVER:
        return "Make sure your face is unobstructed";
      case FaceValidationClass.NO_FACE:
        return "No face detected";
      case FaceValidationClass.SMALL_FACE:
        return "Please move your face closer to the oval";
      case FaceValidationClass.BIG_FACE:
        return "Please move your face further from the oval";
      case FaceValidationClass.TWO_FACE:
        return "Make sure there is only 1 face in the frame";
      case FaceValidationClass.NO_FACE_FRONT:
        return "Keep your face traight";
      case FaceValidationClass.NO_FACE_RIGHT:
        return "Turn right";
      case FaceValidationClass.NO_FACE_LEFT:
        return "Turn left";
      case FaceValidationClass.MISS_TRACKING_FACE:
        return "Please keep your face within the oval";
      case FaceValidationClass.DEEPFAKE:
      case FaceValidationClass.CLOSE_EYES:
        return "Invalid Face";
      default:
        return "InValid Face";
    }
  }
}

FaceValidationClass convertFaceLivenessClass(int maxIndex) {
  switch (maxIndex) {
    case 0:
      return FaceValidationClass.VALID;
    case 1:
      return FaceValidationClass.HAND;
    case 2:
      return FaceValidationClass.MASK;
    case 3:
      return FaceValidationClass.SUNGLASSES;
    case 4:
      return FaceValidationClass.COVER;
    default:
      return FaceValidationClass.NO_FACE;
  }
}
