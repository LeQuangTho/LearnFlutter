class QuocTich {
  String? value;
  _Normalized? normalized;
  double? confidence;
  String? valueUnidecode;

  QuocTich({this.value, this.normalized, this.confidence, this.valueUnidecode});

  QuocTich.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    normalized = json['normalized'] != null
        ? new _Normalized.fromJson(json['normalized'])
        : null;
    confidence = json['confidence'];
    valueUnidecode = json['value_unidecode'];
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
  String? code;
  String? code2;
  String? valueUnidecode;

  _Normalized({this.value, this.code, this.code2, this.valueUnidecode});

  _Normalized.fromJson(Map<String, dynamic> json) {
    value = json['value'].toString();
    code = json['code'].toString();
    code2 = json['code2'].toString();
    valueUnidecode = json['value_unidecode'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['code'] = this.code;
    data['code2'] = this.code2;
    data['value_unidecode'] = this.valueUnidecode;
    return data;
  }
}
