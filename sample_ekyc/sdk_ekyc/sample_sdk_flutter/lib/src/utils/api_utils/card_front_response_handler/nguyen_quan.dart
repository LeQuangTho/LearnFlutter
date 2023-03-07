class NguyenQuan {
  String? value;
  _Normalized? normalized;
  double? confidence;
  String? valueUnidecode;

  NguyenQuan(
      {this.value, this.normalized, this.confidence, this.valueUnidecode});

  NguyenQuan.fromJson(Map<String, dynamic> json) {
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
  _Tinh? tinh;
  _Huyen? huyen;
  _Xa? xa;
  String? valueUnidecode;

  _Normalized(
      {this.value, this.tinh, this.huyen, this.xa, this.valueUnidecode});

  _Normalized.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    tinh = json['tinh'] != null ? new _Tinh.fromJson(json['tinh']) : null;
    huyen = json['huyen'] != null ? new _Huyen.fromJson(json['huyen']) : null;
    xa = json['xa'] != null ? new _Xa.fromJson(json['xa']) : null;
    valueUnidecode = json['value_unidecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    if (this.tinh != null) {
      data['tinh'] = this.tinh!.toJson();
    }
    if (this.huyen != null) {
      data['huyen'] = this.huyen!.toJson();
    }
    if (this.xa != null) {
      data['xa'] = this.xa!.toJson();
    }
    data['value_unidecode'] = this.valueUnidecode;
    return data;
  }
}

class _Tinh {
  String? value;
  String? code;
  String? valueUnidecode;

  _Tinh({this.value, this.code, this.valueUnidecode});

  _Tinh.fromJson(Map<String, dynamic> json) {
    value = json['value'].toString();
    code = json['code'].toString();
    valueUnidecode = json['value_unidecode'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['code'] = this.code;
    data['value_unidecode'] = this.valueUnidecode;
    return data;
  }
}

class _Huyen {
  String? value;
  String? code;
  String? valueUnidecode;

  _Huyen({this.value, this.code, this.valueUnidecode});

  _Huyen.fromJson(Map<String, dynamic> json) {
    value = json['value'].toString();
    code = json['code'].toString();
    valueUnidecode = json['value_unidecode'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['code'] = this.code;
    data['value_unidecode'] = this.valueUnidecode;
    return data;
  }
}

class _Xa {
  String? value;
  String? code;
  String? valueUnidecode;

  _Xa({this.value, this.code, this.valueUnidecode});

  _Xa.fromJson(Map<String, dynamic> json) {
    value = json['value'].toString();
    code = json['code'].toString();
    valueUnidecode = json['value_unidecode'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['code'] = this.code;
    data['value_unidecode'] = this.valueUnidecode;
    return data;
  }
}
