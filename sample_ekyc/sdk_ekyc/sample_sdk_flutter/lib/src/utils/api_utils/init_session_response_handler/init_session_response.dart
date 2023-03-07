class InitResponseHandler {
  String? requestId;
  String? code;
  String? error;
  double? time;
  String? msg;
  Output? output;

  InitResponseHandler(
      {this.requestId, this.code, this.time, this.msg, this.output});

  InitResponseHandler.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    code = json['code'];
    error = json['error'] ?? null;
    time = json['time'];
    msg = json['msg'];
    output = json['output'] != null ? Output.fromJson(json['output']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['code'] = this.code;
    data['error'] = this.error;
    data['time'] = this.time;
    data['msg'] = this.msg;
    if (this.output != null) {
      data['output'] = this.output!.toJson();
    } else {
      data['output'] = null;
    }
    return data;
  }
}

class Output {
  String? id;
  String? customer;
  String? userId;
  bool? isSuccess;
  String? reviewStatus;
  String? status;
  Metadata? metadata;
  String? created;
  String? updatedAt;

  Output(
      {this.id,
      this.customer,
      this.userId,
      this.isSuccess,
      this.reviewStatus,
      this.status,
      this.metadata,
      this.created,
      this.updatedAt});

  Output.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'];
    userId = json['user_id'];
    isSuccess = json['is_success'];
    reviewStatus = json['review_status'];
    status = json['status'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    created = json['created'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['customer'] = customer;
    data['user_id'] = userId;
    data['is_success'] = isSuccess;
    data['review_status'] = reviewStatus;
    data['status'] = status;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['created'] = created;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Metadata {
  String? source;

  Metadata({this.source});

  Metadata.fromJson(Map<String, dynamic> json) {
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    return data;
  }
}
