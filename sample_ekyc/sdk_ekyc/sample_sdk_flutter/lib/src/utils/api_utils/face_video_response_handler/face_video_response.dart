import './output.dart';

class FaceVideoResponse {
  String? requestId;
  String? code;
  double? time;
  String? sessionId;
  String? error;
  Output? output;

  FaceVideoResponse(
      {this.requestId,
      this.code,
      this.time,
      this.sessionId,
      this.error,
      this.output});

  FaceVideoResponse.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'].toString();
    code = json['code'].toString();
    time = json['time'];
    sessionId = json['session_id'].toString();
    error = json['error'].toString();
    output =
        json['output'] != null ? new Output.fromJson(json['output']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['code'] = this.code;
    data['time'] = this.time;
    data['session_id'] = this.sessionId;
    data['error'] = this.error;
    if (this.output != null) {
      data['output'] = this.output!.toJson();
    }
    return data;
  }
}
