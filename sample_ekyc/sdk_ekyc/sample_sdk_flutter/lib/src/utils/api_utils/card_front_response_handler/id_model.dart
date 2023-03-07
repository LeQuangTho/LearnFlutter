class Id {
  String? value;
  double? confidence;
  _Validate? validate;
  String? valueUnidecode;

  Id({this.value, this.confidence, this.validate, this.valueUnidecode});

  Id.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    confidence = json['confidence'];
    validate = json['validate'] != null
        ? new _Validate.fromJson(json['validate'])
        : null;
    valueUnidecode = json['value_unidecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['confidence'] = this.confidence;
    if (this.validate != null) {
      data['validate'] = this.validate!.toJson();
    }
    data['value_unidecode'] = this.valueUnidecode;
    return data;
  }
}

class _Validate {
  String? idCheck;
  String? idLogic;
  String? idLogicMessage;
  List<double>? idconf;

  _Validate({this.idCheck, this.idLogic, this.idLogicMessage, this.idconf});

  _Validate.fromJson(Map<String, dynamic> json) {
    idCheck = json['id_check'].toString();
    idLogic = json['id_logic'].toString();
    idLogicMessage = json['id_logic_message'].toString();
    idconf = json['idconf'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_check'] = this.idCheck;
    data['id_logic'] = this.idLogic;
    data['id_logic_message'] = this.idLogicMessage;
    data['idconf'] = this.idconf;
    return data;
  }
}
