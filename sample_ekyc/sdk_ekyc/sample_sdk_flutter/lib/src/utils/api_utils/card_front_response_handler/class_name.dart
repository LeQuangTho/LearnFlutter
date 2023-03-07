class ClassName {
  String? value;
  double? confidence;
  _Normalized? normalized;

  ClassName({this.value, this.confidence, this.normalized});

  ClassName.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    confidence = json['confidence'];
    normalized = json['normalized'] != null
        ? new _Normalized.fromJson(json['normalized'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['confidence'] = this.confidence;
    if (this.normalized != null) {
      data['normalized'] = this.normalized!.toJson();
    }
    return data;
  }
}

class _Normalized {
  String? value;
  String? code;

  _Normalized({this.value, this.code});

  _Normalized.fromJson(Map<String, dynamic> json) {
    value = json['value'].toString();
    code = json['code'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['code'] = this.code;
    return data;
  }
}
