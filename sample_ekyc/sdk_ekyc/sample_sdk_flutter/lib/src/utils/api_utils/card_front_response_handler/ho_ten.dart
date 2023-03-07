class HoTen {
  String? value;
  double? confidence;
  String? valueUnidecode;

  HoTen({this.value, this.confidence, this.valueUnidecode});

  HoTen.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    confidence = json['confidence'];
    valueUnidecode = json['value_unidecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['confidence'] = this.confidence;
    data['value_unidecode'] = this.valueUnidecode;
    return data;
  }
}
