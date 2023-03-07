/// eFormType : "DDNSDCKDTAT"
/// eFormId : "41266e32-8533-4599-9c6a-76e6a2ddd9ef"
/// eFormCode : "DDNSDCKDTAT-0524432171"
/// fileUrl : "https://sandbox-apim.savis.vn/cdn/v1/hdss/HDSS/2022/10/27/DDNSDCKDTAT-0524432171/HDSS.0357629040.DDNSDCKDTAT0524432171._22102710361366.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=savis%2F20221027%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221027T033614Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=d5868047a0e05011c2cfb6fe1ce6b936229c30aa82f38ed365ac7abcd73dd503"
/// eFormStatus : 1

class EForm {
  EForm({
    String? eFormType,
    String? eFormId,
    String? eFormCode,
    String? fileUrl,
    num? eFormStatus,
  }) {
    _eFormType = eFormType;
    _eFormId = eFormId;
    _eFormCode = eFormCode;
    _fileUrl = fileUrl;
    _eFormStatus = eFormStatus;
  }

  EForm.fromJson(dynamic json) {
    _eFormType = json['eFormType'] ?? '';
    _eFormId = json['eFormId'] ?? '';
    _eFormCode = json['eFormCode'] ?? '';
    _fileUrl = json['fileUrl'] ?? '';
    _eFormStatus = json['eFormStatus'] ?? '';
  }
  String? _eFormType;
  String? _eFormId;
  String? _eFormCode;
  String? _fileUrl;
  num? _eFormStatus;
  EForm copyWith({
    String? eFormType,
    String? eFormId,
    String? eFormCode,
    String? fileUrl,
    num? eFormStatus,
  }) =>
      EForm(
        eFormType: eFormType ?? _eFormType,
        eFormId: eFormId ?? _eFormId,
        eFormCode: eFormCode ?? _eFormCode,
        fileUrl: fileUrl ?? _fileUrl,
        eFormStatus: eFormStatus ?? _eFormStatus,
      );
  String? get eFormType => _eFormType;
  String? get eFormId => _eFormId;
  String? get eFormCode => _eFormCode;
  String? get fileUrl => _fileUrl;
  num? get eFormStatus => _eFormStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['eFormType'] = _eFormType;
    map['eFormId'] = _eFormId;
    map['eFormCode'] = _eFormCode;
    map['fileUrl'] = _fileUrl;
    map['eFormStatus'] = _eFormStatus;
    return map;
  }
}
