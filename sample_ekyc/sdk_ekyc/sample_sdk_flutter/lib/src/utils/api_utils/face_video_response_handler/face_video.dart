class FaceVideo {
  String? id;
  String? userId;
  String? session;
  String? file;
  bool? embeddingRegistered;
  String? reviewStatus;
  String? croppedImage;
  String? source;
  String? updatedAt;

  FaceVideo(
      {this.id,
      this.userId,
      this.session,
      this.file,
      this.embeddingRegistered,
      this.reviewStatus,
      this.croppedImage,
      this.source,
      this.updatedAt});

  FaceVideo.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    session = json['session'].toString();
    file = json['file'].toString();
    embeddingRegistered = json['embedding_registered'];
    reviewStatus = json['review_status'].toString();
    croppedImage = json['cropped_image'].toString();
    source = json['source'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['session'] = this.session;
    data['file'] = this.file;
    data['embedding_registered'] = this.embeddingRegistered;
    data['review_status'] = this.reviewStatus;
    data['cropped_image'] = this.croppedImage;
    data['source'] = this.source;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
