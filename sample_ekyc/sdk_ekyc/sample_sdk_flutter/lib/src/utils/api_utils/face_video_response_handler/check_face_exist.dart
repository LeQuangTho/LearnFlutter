class CheckFaceExist {
  bool? isExist;
  // Null? matchedUser;
  // List<Null>? matchedFaces;
  // List<Null>? matchedFacesVideo;
  double? confidence;

  CheckFaceExist(
      {this.isExist,
      // this.matchedUser,
      // this.matchedFaces,
      // this.matchedFacesVideo,
      this.confidence});

  CheckFaceExist.fromJson(Map<String, dynamic> json) {
    isExist = json['is_exist'];
    // matchedUser = json['matched_user'];
    // if (json['matched_faces'] != null) {
    //   matchedFaces = <Null>[];
    //   json['matched_faces'].forEach((v) {
    //     matchedFaces!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['matched_faces_video'] != null) {
    //   matchedFacesVideo = <Null>[];
    //   json['matched_faces_video'].forEach((v) {
    //     matchedFacesVideo!.add(new Null.fromJson(v));
    //   });
    // }
    confidence = json['confidence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_exist'] = this.isExist;
    // data['matched_user'] = this.matchedUser;
    // if (this.matchedFaces != null) {
    //   data['matched_faces'] =
    //       this.matchedFaces!.map((v) => v.toJson()).toList();
    // }
    // if (this.matchedFacesVideo != null) {
    //   data['matched_faces_video'] =
    //       this.matchedFacesVideo!.map((v) => v.toJson()).toList();
    // }
    data['confidence'] = this.confidence;
    return data;
  }
}
