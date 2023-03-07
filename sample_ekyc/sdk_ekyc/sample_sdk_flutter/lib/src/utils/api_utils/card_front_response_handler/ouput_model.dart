import './result_model.dart';

class Output {
  String? id;

  bool? isSuccess;
  bool? isLiveness;
  String? livenessCode;

  String? cardType;
  String? name;
  String? cardId;
  String? userId;
  String? session;
  String? type;
  String? file;
  bool? embeddingRegistered;
  String? reviewStatus;

  String? status;

  Result? result;
  String? croppedImage;
  String? source;
  String? updatedAt;
  String? cardDateOfBirth;
  String? cardDateOfBirthNormalized;
  int? cardGender;

  String? cardIssuedDate;
  String? cardIssuedDateNormalized;

  String? cardExpiryDate;
  String? cardExpiryDateNormalized;
  String? cardAddress;
  String? cardPlaceOfBirth;
  String? cardPlaceOfIssue;

  Output(
      {this.id,
      this.cardType,
      this.name,
      this.cardId,
      this.userId,
      this.session,
      this.type,
      this.file,
      this.embeddingRegistered,
      this.reviewStatus,
      this.result,
      this.croppedImage,
      this.source,
      this.updatedAt,
      this.cardDateOfBirth,
      this.cardDateOfBirthNormalized,
      this.cardGender,
      this.cardIssuedDate,
      this.cardIssuedDateNormalized,
      this.cardExpiryDate,
      this.cardExpiryDateNormalized,
      this.cardAddress,
      this.cardPlaceOfBirth,
      this.cardPlaceOfIssue});

  Output.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isSuccess = json['is_success'];
    isLiveness = json['is_liveness'];
    livenessCode = json['liveness_code'];
    cardType = json['card_type'];
    name = json['name'];
    cardId = json['card_id'];
    userId = json['user_id'];
    session = json['session'];
    type = json['type'];
    file = json['file'];
    embeddingRegistered = json['embedding_registered'];
    reviewStatus = json['review_status'];
    status = json['status'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    croppedImage = json['cropped_image'];
    source = json['source'];
    updatedAt = json['updated_at'];
    cardDateOfBirth = json['card_date_of_birth'];
    cardDateOfBirthNormalized = json['card_date_of_birth_normalized'];
    cardGender = json['card_gender'];
    cardIssuedDate = json['card_issued_date'];
    cardIssuedDateNormalized = json['card_issued_date_normalized'];
    cardExpiryDate = json['card_expiry_date'];
    cardExpiryDateNormalized = json['card_expiry_date_normalized'];
    cardAddress = json['card_address'];
    cardPlaceOfBirth = json['card_place_of_birth'];
    cardPlaceOfIssue = json['card_place_of_issue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['card_type'] = this.cardType;
    data['name'] = this.name;
    data['card_id'] = this.cardId;
    data['user_id'] = this.userId;
    data['session'] = this.session;
    data['type'] = this.type;
    data['file'] = this.file;
    data['embedding_registered'] = this.embeddingRegistered;
    data['review_status'] = this.reviewStatus;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['cropped_image'] = this.croppedImage;
    data['source'] = this.source;
    data['updated_at'] = this.updatedAt;
    data['card_date_of_birth'] = this.cardDateOfBirth;
    data['card_date_of_birth_normalized'] = this.cardDateOfBirthNormalized;
    data['card_gender'] = this.cardGender;
    data['card_issued_date'] = this.cardIssuedDate;
    data['card_issued_date_normalized'] = this.cardIssuedDateNormalized;
    data['card_expiry_date'] = this.cardExpiryDate;
    data['card_expiry_date_normalized'] = this.cardExpiryDateNormalized;
    data['card_address'] = this.cardAddress;
    data['card_place_of_birth'] = this.cardPlaceOfBirth;
    data['card_place_of_issue'] = this.cardPlaceOfIssue;
    return data;
  }
}
