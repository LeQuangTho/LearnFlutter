class Liveness {
  // String? msg;
  // String? code;
  // double? confidence;
  // bool? isLiveness;
  String? liveness;

  Liveness({this.liveness});

  Liveness.fromJson(Map<String, dynamic> json) {
    // msg = json['msg'].toString();
    // code = json['code'].toString();
    // confidence = json['confidence'];
    // isLiveness = json['is_liveness'];
    liveness = json['liveness'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['msg'] = this.msg;
    // data['code'] = this.code;
    // data['confidence'] = this.confidence;
    // data['is_liveness'] = this.isLiveness;
    data['liveness'] = this.liveness;
    return data;
  }
}
