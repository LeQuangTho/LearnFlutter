class DiHinh {
  String? value;
  double? confidence;
  String? valueUnidecode;

  DiHinh({this.value, this.confidence, this.valueUnidecode});

  DiHinh.fromJson(Map<String, dynamic> json) {
    value = json['value'].toString();
    confidence = json['confidence'];
    valueUnidecode = json['value_unidecode'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['confidence'] = this.confidence;
    data['value_unidecode'] = this.valueUnidecode;
    return data;
  }
}
