import '../eform/eform.dart';

/// code : 200
/// message : "string"
/// traceId : "string"
/// data : {"documentId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","documentTypeCode":"string","documentTypeName":"string","identiNumber":"string","userFullName":"string","documentName":"string","documentCode":"string","filePreviewUrl":"string","documentStatus":0,"documentStatusName":"string","state":"string","stateName":"string","lastReasonReject":"string","signExpireAtDate":"string","listImagePreview":["string"],"listMetaData":[{"key":"string","value":"string"}]}

class ContractDetailResponse {
  ContractDetailResponse({
    num? code,
    String? message,
    String? traceId,
    ContractDetailResponseDataEntry? data,
  }) {
    _code = code;
    _message = message;
    _traceId = traceId;
    _data = data;
  }

  ContractDetailResponse.fromJson(dynamic json) {
    _code = json['code'];
    _message = json['message'];
    _traceId = json['traceId'];
    _data = json['data'] != null
        ? ContractDetailResponseDataEntry.fromJson(json['data'])
        : null;
  }

  num? _code;
  String? _message;
  String? _traceId;
  ContractDetailResponseDataEntry? _data;

  ContractDetailResponse copyWith({
    num? code,
    String? message,
    String? traceId,
    ContractDetailResponseDataEntry? data,
  }) =>
      ContractDetailResponse(
        code: code ?? _code,
        message: message ?? _message,
        traceId: traceId ?? _traceId,
        data: data ?? _data,
      );

  num? get code => _code;

  String? get message => _message;

  String? get traceId => _traceId;

  ContractDetailResponseDataEntry? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['message'] = _message;
    map['traceId'] = _traceId;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

  static final empty = ContractDetailResponse();
}

/// documentId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// documentTypeCode : "string"
/// documentTypeName : "string"
/// identiNumber : "string"
/// userFullName : "string"
/// documentName : "string"
/// documentCode : "string"
/// filePreviewUrl : "string"
/// documentStatus : 0
/// documentStatusName : "string"
/// state : "string"
/// stateName : "string"
/// lastReasonReject : "string"
/// signExpireAtDate : "string"
/// listImagePreview : ["string"]
/// listMetaData : [{"key":"string","value":"string"}]

class ContractDetailResponseDataEntry {
  ContractDetailResponseDataEntry(
      {String? documentId,
      String? documentTypeCode,
      String? documentTypeName,
      String? identiNumber,
      String? userFullName,
      String? documentName,
      String? documentCode,
      String? filePreviewUrl,
      num? documentStatus,
      String? documentStatusName,
      String? state,
      String? stateName,
      bool? canSign,
      String? lastReasonReject,
      String? signExpireAtDate,
      List<String>? listImagePreview,
      List<ListMetaData>? listMetaData,
      EForm? eForm}) {
    _documentId = documentId;
    _documentTypeCode = documentTypeCode;
    _documentTypeName = documentTypeName;
    _identiNumber = identiNumber;
    _userFullName = userFullName;
    _documentName = documentName;
    _documentCode = documentCode;
    _filePreviewUrl = filePreviewUrl;
    _documentStatus = documentStatus;
    _documentStatusName = documentStatusName;
    _state = state;
    _canSign = canSign;
    _stateName = stateName;
    _lastReasonReject = lastReasonReject;
    _signExpireAtDate = signExpireAtDate;
    _listImagePreview = listImagePreview;
    _listMetaData = listMetaData;
    _eForm = eForm;
  }

  ContractDetailResponseDataEntry.fromJson(dynamic json) {
    _documentId = json['documentId'];
    _documentTypeCode = json['documentTypeCode'];
    _documentTypeName = json['documentTypeName'];
    _identiNumber = json['identiNumber'];
    _canSign = json['canSign'];
    _userFullName = json['userFullName'];
    _documentName = json['documentName'];
    _documentCode = json['documentCode'];
    _filePreviewUrl = json['filePreviewUrl'];
    _documentStatus = json['documentStatus'];
    _documentStatusName = json['documentStatusName'];
    _state = json['state'];
    _stateName = json['stateName'];
    _lastReasonReject = json['lastReasonReject'];
    _signExpireAtDate = json['signExpireAtDate'];
    _eForm =
        json['eFormData'] != null ? EForm.fromJson(json['eFormData']) : null;
    _listImagePreview = json['listImagePreview'] != null
        ? json['listImagePreview'].cast<String>()
        : [];
    if (json['listMetaData'] != null) {
      _listMetaData = [];
      Map<String, String>.from(json['listMetaData']).forEach((k, v) {
        _listMetaData?.add(ListMetaData(key: k, value: v));
      });
    }
  }

  String? _documentId;
  String? _documentTypeCode;
  String? _documentTypeName;
  String? _identiNumber;
  String? _userFullName;
  String? _documentName;
  bool? _canSign;
  String? _documentCode;
  String? _filePreviewUrl;
  num? _documentStatus;
  String? _documentStatusName;
  String? _state;
  String? _stateName;
  String? _lastReasonReject;
  String? _signExpireAtDate;
  List<String>? _listImagePreview;
  List<ListMetaData>? _listMetaData;
  EForm? _eForm;

  ContractDetailResponseDataEntry copyWith(
          {String? documentId,
          String? documentTypeCode,
          String? documentTypeName,
          String? identiNumber,
          String? userFullName,
          String? documentName,
          String? documentCode,
          bool? canSign,
          String? filePreviewUrl,
          num? documentStatus,
          String? documentStatusName,
          String? state,
          String? stateName,
          String? lastReasonReject,
          String? signExpireAtDate,
          List<String>? listImagePreview,
          List<ListMetaData>? listMetaData,
          EForm? eForm}) =>
      ContractDetailResponseDataEntry(
        documentId: documentId ?? _documentId,
        documentTypeCode: documentTypeCode ?? _documentTypeCode,
        documentTypeName: documentTypeName ?? _documentTypeName,
        identiNumber: identiNumber ?? _identiNumber,
        userFullName: userFullName ?? _userFullName,
        documentName: documentName ?? _documentName,
        canSign: canSign ?? _canSign,
        documentCode: documentCode ?? _documentCode,
        filePreviewUrl: filePreviewUrl ?? _filePreviewUrl,
        documentStatus: documentStatus ?? _documentStatus,
        documentStatusName: documentStatusName ?? _documentStatusName,
        state: state ?? _state,
        stateName: stateName ?? _stateName,
        lastReasonReject: lastReasonReject ?? _lastReasonReject,
        signExpireAtDate: signExpireAtDate ?? _signExpireAtDate,
        listImagePreview: listImagePreview ?? _listImagePreview,
        listMetaData: listMetaData ?? _listMetaData,
        eForm: eForm ?? _eForm,
      );

  String? get documentId => _documentId;

  String? get documentTypeCode => _documentTypeCode;

  String? get documentTypeName => _documentTypeName;

  String? get identiNumber => _identiNumber;

  String? get userFullName => _userFullName;

  String? get documentName => _documentName;

  bool? get canSign => _canSign;

  String? get documentCode => _documentCode;

  String? get filePreviewUrl => _filePreviewUrl;

  num? get documentStatus => _documentStatus;

  String? get documentStatusName => _documentStatusName;

  String? get state => _state;

  String? get stateName => _stateName;

  String? get lastReasonReject => _lastReasonReject;

  String? get signExpireAtDate => _signExpireAtDate;

  List<String>? get listImagePreview => _listImagePreview;

  List<ListMetaData>? get listMetaData => _listMetaData;

  EForm? get eForm => _eForm;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['documentId'] = _documentId;
    map['documentTypeCode'] = _documentTypeCode;
    map['documentTypeName'] = _documentTypeName;
    map['canSign'] = _canSign;
    map['identiNumber'] = _identiNumber;
    map['userFullName'] = _userFullName;
    map['documentName'] = _documentName;
    map['documentCode'] = _documentCode;
    map['filePreviewUrl'] = _filePreviewUrl;
    map['documentStatus'] = _documentStatus;
    map['documentStatusName'] = _documentStatusName;
    map['state'] = _state;
    map['stateName'] = _stateName;
    map['lastReasonReject'] = _lastReasonReject;
    map['signExpireAtDate'] = _signExpireAtDate;
    map['listImagePreview'] = _listImagePreview;
    map['eFormData'] = _eForm;
    if (_listMetaData != null) {
      map['listMetaData'] = _listMetaData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// key : "string"
/// value : "string"

class ListMetaData {
  ListMetaData({
    String? key,
    String? value,
  }) {
    _key = key;
    _value = value;
  }

  ListMetaData.fromJson(dynamic json) {
    _key = json['key'];
    _value = json['value'];
  }

  String? _key;
  String? _value;

  ListMetaData copyWith({
    String? key,
    String? value,
  }) =>
      ListMetaData(
        key: key ?? _key,
        value: value ?? _value,
      );

  String? get key => _key;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = _key;
    map['value'] = _value;
    return map;
  }
}
