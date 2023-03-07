import './liveness.dart';
import './check_face_exist.dart';
import './customer.dart';
import './face_video.dart';

class Output {
  Liveness? liveness;
  double? similarity;
  CheckFaceExist? checkFaceExist;
  Customer? customer;
  FaceVideo? faceVideo;

  Output(
      {this.liveness,
      this.similarity,
      this.checkFaceExist,
      this.customer,
      this.faceVideo});

  Output.fromJson(Map<String, dynamic> json) {
    liveness = json['liveness'] != null
        ? new Liveness.fromJson(json['liveness'])
        : null;
    similarity = json['similarity'];
    checkFaceExist = json['check_face_exist'] != null
        ? new CheckFaceExist.fromJson(json['check_face_exist'])
        : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    faceVideo = json['face_video'] != null
        ? new FaceVideo.fromJson(json['face_video'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.liveness != null) {
      data['liveness'] = this.liveness!.toJson();
    }
    data['similarity'] = this.similarity;
    if (this.checkFaceExist != null) {
      data['check_face_exist'] = this.checkFaceExist!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.faceVideo != null) {
      data['face_video'] = this.faceVideo!.toJson();
    }
    return data;
  }
}
