import 'package:sample_sdk_flutter/src/utils/api_utils/card_back_response_handler/card_back_response.dart';
import 'package:sample_sdk_flutter/src/utils/api_utils/card_front_response_handler/card_front_response.dart';
import 'package:sample_sdk_flutter/src/utils/api_utils/face_video_response_handler/face_video_response.dart';
import 'package:sample_sdk_flutter/src/utils/api_utils/init_session_response_handler/init_session_response.dart';

class EKycSessionInfor {
  bool isPassport = false;
  late String sessionId;
  late String requestId;
  late bool isValid;
  late double matchingDetail;
  late String idNumber;
  late String name;
  late String dateOfBirth;
  late String sex;
  late String nation; // quốc tịch
  late String ethnicity; // dân tộc
  late String religion; // tôn giáo
  late String placeOfOrigin; // nguyên quán
  late String placeOfResidence; // hộ khẩu thường trú
  late String dateOfExpiry; // ngày cấp
  late String dateOfIssue; // ngày hết hạn
  late String personalIdentification; // dị hình
  late String issuedAt; // nơi cấp
  String? cardFrontImagePath;
  String? cardBackImagePath;
  String? faceStraightImagePath;

  EKycSessionInfor() {
    isValid = false;
    matchingDetail = 0.0;
    idNumber = "None";
    name = "None";
    dateOfBirth = "None";
    sex = "None";
    nation = "None";
    ethnicity = "None";
    religion = "None";
    placeOfOrigin = "None";
    placeOfResidence = "None";
    personalIdentification = "None";
    issuedAt = "None";
    dateOfIssue = "None";
    dateOfExpiry = "None";
    sessionId = "None";
    requestId = "None";
  }

  void setInitResponseResult(InitResponseHandler initResponseHandler) {
    if (initResponseHandler.output == null) {
      return;
    }
    if (initResponseHandler.output!.id != null) {
      sessionId = initResponseHandler.output!.id!;
    }
    if (initResponseHandler.requestId != null) {
      requestId = initResponseHandler.requestId!;
    }
  }

  void setCardBackResponseResult(CardBackResponseModel cardBackResponseModel) {
    if (cardBackResponseModel.output == null) {
      return;
    }
    if (cardBackResponseModel.output!.result!.diHinh != null) {
      personalIdentification =
          cardBackResponseModel.output!.result!.diHinh!.value.toString();
    }
    if (cardBackResponseModel.output!.result!.ngayCap != null) {
      dateOfIssue =
          cardBackResponseModel.output!.result!.ngayCap!.value.toString();
    }
    if (cardBackResponseModel.output!.result!.noiCap != null) {
      issuedAt = cardBackResponseModel.output!.result!.noiCap!.value.toString();
    }
  }

  void setCardFrontResponseResult(
      CardFrontResponseModel cardFrontResponseModel) {
    if (cardFrontResponseModel.output == null) return;

    if (cardFrontResponseModel.output!.result!.hoTen != null) {
      name = cardFrontResponseModel.output!.result!.hoTen!.value.toString();
    }
    if (cardFrontResponseModel.output!.result!.id != null) {
      idNumber = cardFrontResponseModel.output!.result!.id!.value.toString();
    }
    if (cardFrontResponseModel.output!.result!.ngaySinh != null) {
      dateOfBirth =
          cardFrontResponseModel.output!.result!.ngaySinh!.value.toString();
    }
    if (cardFrontResponseModel.output!.result!.gioiTinh != null) {
      sex = cardFrontResponseModel.output!.result!.gioiTinh!.value.toString();
    }
    if (cardFrontResponseModel.output!.result!.quocTich != null) {
      nation =
          cardFrontResponseModel.output!.result!.quocTich!.value.toString();
    }
    if (cardFrontResponseModel.output!.result!.nguyenQuan != null) {
      placeOfOrigin =
          cardFrontResponseModel.output!.result!.nguyenQuan!.value.toString();
    }
    if (cardFrontResponseModel.output!.result!.hoKhauThuongTru != null) {
      placeOfResidence = cardFrontResponseModel
          .output!.result!.hoKhauThuongTru!.value
          .toString();
    }
    if (cardFrontResponseModel.output!.result!.ngayHetHan != null) {
      dateOfExpiry =
          cardFrontResponseModel.output!.result!.ngayHetHan!.value.toString();
    }

    ethnicity = "Kinh";
    religion = "None";
  }

  void setFaceVideoResponseResult(FaceVideoResponse faceVideoResponse) {
    if (faceVideoResponse.code == "SUCCESS") {
      isValid = true;
    }
    if (faceVideoResponse.output == null) return;
    if (faceVideoResponse.output!.similarity != null) {
      matchingDetail = faceVideoResponse.output!.similarity!;
      if (faceVideoResponse.output!.similarity! > 0.8 &&
          faceVideoResponse.code != "ERROR" &&
          faceVideoResponse.output!.liveness!.liveness == "True") {
        isValid = true;
      }
    }
  }

  void setCardFrontImagePath(String cardFrontImagePath) {
    this.cardFrontImagePath = cardFrontImagePath;
  }

  void setCardBackImagePath(String cardBackImagePath) {
    this.cardBackImagePath = cardBackImagePath;
  }

  void setFaceStraightImagePath(String faceStraightImagePath) {
    this.faceStraightImagePath = faceStraightImagePath;
  }

  void usingPassport() {
    isPassport = true;
  }

  void reIntEkycSession() {
    isValid = false;
    matchingDetail = 0.0;
    idNumber = "None";
    name = "None";
    dateOfBirth = "None";
    sex = "None";
    nation = "None";
    ethnicity = "None";
    religion = "None";
    placeOfOrigin = "None";
    placeOfResidence = "None";
    personalIdentification = "None";
    issuedAt = "None";
    dateOfIssue = "None";
    dateOfExpiry = "None";
    sessionId = "None";
    requestId = "None";
  }
}
