/// eFormConfig : 1
/// identityNumber : "string"
/// order : 0
/// hasUserPIN : true
/// isApproveAutoSign : false
/// isNotRequirePINToSign : false
/// isReceiveSystemNoti : false
/// isReceiveSignFailNoti : false
/// isEKYC : false
/// isRequiredChangePassword : true
/// id : "3a4a276a-3728-4312-9b2d-cc7db691f41f"
/// name : "string"
/// email : "string"
/// phoneNumber : "string"
/// userName : "vc.admin"
/// isLock : false
/// status : true
/// organizationId : "65a89b94-3b14-4e08-a6d6-2b3b24600722"
/// isInternalUser : true

class UserModel {
  UserModel({
    num? eFormConfig,
    String? identityNumber,
    num? order,
    bool? hasUserPIN,
    bool? isApproveAutoSign,
    bool? isNotRequirePINToSign,
    bool? isReceiveSystemNoti,
    bool? isReceiveSignFailNoti,
    bool? isEKYC,
    bool? isRequiredChangePassword,
    String? id,
    String? tempPasswordDuration,
    String? name,
    String? email,
    String? phoneNumber,
    String? userName,
    bool? isLock,
    bool? status,
    String? organizationId,
    bool? isInternalUser,
  }) {
    _eFormConfig = eFormConfig;
    _identityNumber = identityNumber;
    _order = order;
    _hasUserPIN = hasUserPIN;
    _isApproveAutoSign = isApproveAutoSign;
    _isNotRequirePINToSign = isNotRequirePINToSign;
    _isReceiveSystemNoti = isReceiveSystemNoti;
    _isReceiveSignFailNoti = isReceiveSignFailNoti;
    _isEKYC = isEKYC;
    _isRequiredChangePassword = isRequiredChangePassword;
    _tempPasswordDuration = tempPasswordDuration;
    _id = id;
    _name = name;
    _email = email;
    _phoneNumber = phoneNumber;
    _userName = userName;
    _isLock = isLock;
    _status = status;
    _organizationId = organizationId;
    _isInternalUser = isInternalUser;
  }

  UserModel.fromJson(dynamic json) {
    _eFormConfig = json['eFormConfig'];
    _identityNumber = json['identityNumber'];
    _order = json['order'];
    _hasUserPIN = json['hasUserPIN'];
    _isApproveAutoSign = json['isApproveAutoSign'];
    _isNotRequirePINToSign = json['isNotRequirePINToSign'];
    _isReceiveSystemNoti = json['isReceiveSystemNoti'];
    _isReceiveSignFailNoti = json['isReceiveSignFailNoti'];
    _isEKYC = json['isEKYC'];
    _isRequiredChangePassword = json['isRequiredChangePassword'];
    _tempPasswordDuration = json['tempPasswordDuration'];
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _phoneNumber = json['phoneNumber'];
    _userName = json['userName'];
    _isLock = json['isLock'];
    _status = json['status'];
    _organizationId = json['organizationId'];
    _isInternalUser = json['isInternalUser'];
  }
  num? _eFormConfig;
  String? _identityNumber;
  num? _order;
  bool? _hasUserPIN;
  bool? _isApproveAutoSign;
  bool? _isNotRequirePINToSign;
  bool? _isReceiveSystemNoti;
  bool? _isReceiveSignFailNoti;
  bool? _isEKYC;
  bool? _isRequiredChangePassword;
  String? _id;
  String? _tempPasswordDuration;
  String? _name;
  String? _email;
  String? _phoneNumber;
  String? _userName;
  bool? _isLock;
  bool? _status;
  String? _organizationId;
  bool? _isInternalUser;
  UserModel copyWith({
    num? eFormConfig,
    String? identityNumber,
    num? order,
    bool? hasUserPIN,
    bool? isApproveAutoSign,
    bool? isNotRequirePINToSign,
    bool? isReceiveSystemNoti,
    bool? isReceiveSignFailNoti,
    bool? isEKYC,
    bool? isRequiredChangePassword,
    String? tempPasswordDuration,
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? userName,
    bool? isLock,
    bool? status,
    String? organizationId,
    bool? isInternalUser,
  }) =>
      UserModel(
        eFormConfig: eFormConfig ?? _eFormConfig,
        identityNumber: identityNumber ?? _identityNumber,
        order: order ?? _order,
        hasUserPIN: hasUserPIN ?? _hasUserPIN,
        isApproveAutoSign: isApproveAutoSign ?? _isApproveAutoSign,
        isNotRequirePINToSign: isNotRequirePINToSign ?? _isNotRequirePINToSign,
        isReceiveSystemNoti: isReceiveSystemNoti ?? _isReceiveSystemNoti,
        isReceiveSignFailNoti: isReceiveSignFailNoti ?? _isReceiveSignFailNoti,
        isEKYC: isEKYC ?? _isEKYC,
        isRequiredChangePassword:
            isRequiredChangePassword ?? _isRequiredChangePassword,
        id: id ?? _id,
        tempPasswordDuration: tempPasswordDuration ?? _tempPasswordDuration,
        name: name ?? _name,
        email: email ?? _email,
        phoneNumber: phoneNumber ?? _phoneNumber,
        userName: userName ?? _userName,
        isLock: isLock ?? _isLock,
        status: status ?? _status,
        organizationId: organizationId ?? _organizationId,
        isInternalUser: isInternalUser ?? _isInternalUser,
      );
  num? get eFormConfig => _eFormConfig;
  String? get identityNumber => _identityNumber;
  num? get order => _order;
  bool? get hasUserPIN => _hasUserPIN;
  bool? get isApproveAutoSign => _isApproveAutoSign;
  bool? get isNotRequirePINToSign => _isNotRequirePINToSign;
  bool? get isReceiveSystemNoti => _isReceiveSystemNoti;
  bool? get isReceiveSignFailNoti => _isReceiveSignFailNoti;
  bool? get isEKYC => _isEKYC;
  bool? get isRequiredChangePassword => _isRequiredChangePassword;
  String? get tempPasswordDuration => _tempPasswordDuration;
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get userName => _userName;
  bool? get isLock => _isLock;
  bool? get status => _status;
  String? get organizationId => _organizationId;
  bool? get isInternalUser => _isInternalUser;

  set setIsEKYC(bool value) {
    _isEKYC = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['eFormConfig'] = _eFormConfig;
    map['identityNumber'] = _identityNumber;
    map['order'] = _order;
    map['hasUserPIN'] = _hasUserPIN;
    map['isApproveAutoSign'] = _isApproveAutoSign;
    map['isNotRequirePINToSign'] = _isNotRequirePINToSign;
    map['isReceiveSystemNoti'] = _isReceiveSystemNoti;
    map['isReceiveSignFailNoti'] = _isReceiveSignFailNoti;
    map['isEKYC'] = _isEKYC;
    map['isRequiredChangePassword'] = _isRequiredChangePassword;
    map['tempPasswordDuration'] = _tempPasswordDuration;
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['phoneNumber'] = _phoneNumber;
    map['userName'] = _userName;
    map['isLock'] = _isLock;
    map['status'] = _status;
    map['organizationId'] = _organizationId;
    map['isInternalUser'] = _isInternalUser;
    return map;
  }
}
