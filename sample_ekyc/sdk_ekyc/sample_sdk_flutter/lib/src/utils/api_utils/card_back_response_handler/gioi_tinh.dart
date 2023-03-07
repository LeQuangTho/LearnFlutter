class GioiTinh {
  String? value;
  _Normalized? normalized;
  double? confidence;
  String? valueUnidecode;

  GioiTinh({this.value, this.normalized, this.confidence, this.valueUnidecode});

  GioiTinh.fromJson(Map<String, dynamic> json) {
    value = json['value'].toString();
    normalized = json['normalized'] != null
        ? new _Normalized.fromJson(json['normalized'])
        : null;
    confidence = json['confidence'];
    valueUnidecode = json['value_unidecode'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    if (this.normalized != null) {
      data['normalized'] = this.normalized!.toJson();
    }
    data['confidence'] = this.confidence;
    data['value_unidecode'] = this.valueUnidecode;
    return data;
  }
}

class _Normalized {
  String? value;

  _Normalized({this.value});

  _Normalized.fromJson(Map<String, dynamic> json) {
    value = json['value'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    return data;
  }
}
