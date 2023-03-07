import 'dart:convert';
import './ouput_model.dart';

class CardFrontResponseModel {
  String? requestId;
  String? code;
  double? time;
  String? sessionId;
  Output? output;
  CheckFaceExist? checkFaceExist;
  String? error;

  CardFrontResponseModel(
      {this.requestId,
      this.code,
      this.time,
      this.sessionId,
      this.output,
      this.checkFaceExist,
      this.error});

  CardFrontResponseModel.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    code = json['code'];
    time = json['time'];
    sessionId = json['session_id'];
    error = json['error'];
    output = json['output'] != null ? Output.fromJson(json['output']) : null;
    checkFaceExist = json['check_face_exist'] != null
        ? CheckFaceExist.fromJson(json['check_face_exist'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['code'] = this.code;
    data['time'] = this.time;
    data['session_id'] = this.sessionId;
    if (this.output != null) {
      data['output'] = this.output!.toJson();
    }
    if (this.checkFaceExist != null) {
      data['check_face_exist'] = this.checkFaceExist!.toJson();
    }
    return data;
  }
}

class CheckFaceExist {
  bool? isExist;
  // Null? matchedUser;
  // List<Null>? matchedCards;
  // double? confidence;

  CheckFaceExist({this.isExist});

  // CheckFaceExist(
  //     {this.isExist, this.matchedUser, this.matchedCards, this.confidence});

  CheckFaceExist.fromJson(Map<String, dynamic> json) {
    isExist = json['is_exist'];
    // matchedUser = json['matched_user'];
    // if (json['matched_cards'] != null) {
    //   matchedCards = <Null>[];
    //   json['matched_cards'].forEach((v) {
    //     matchedCards!.add( Null.fromJson(v));
    //   });
    // }
    // confidence = json['confidence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['is_exist'] = this.isExist;
    // data['matched_user'] = this.matchedUser;
    // if (this.matchedCards != null) {
    //   data['matched_cards'] =
    //       this.matchedCards!.map((v) => v.toJson()).toList();
    // }
    // data['confidence'] = this.confidence;
    return data;
  }
}
