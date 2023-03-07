/// id : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// title : "string"
/// content : "string"
/// notificationType : "string"
/// referenceType : 0
/// referenceId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// description : "string"
/// createdDate : "2022-11-28T04:20:14.993Z"
/// createdUserId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// modifiedDate : "2022-11-28T04:20:14.993Z"
/// modifiedUserId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// userId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// device : "string"
/// isRead : true

class NotificationData {
  NotificationData({
      String? id, 
      String? title, 
      String? content, 
      String? notificationType, 
      num? referenceType, 
      String? referenceId, 
      String? description, 
      String? createdDate, 
      String? createdUserId, 
      String? modifiedDate, 
      String? modifiedUserId, 
      String? userId, 
      String? device, 
      bool? isRead,}){
    _id = id;
    _title = title;
    _content = content;
    _notificationType = notificationType;
    _referenceType = referenceType;
    _referenceId = referenceId;
    _description = description;
    _createdDate = createdDate;
    _createdUserId = createdUserId;
    _modifiedDate = modifiedDate;
    _modifiedUserId = modifiedUserId;
    _userId = userId;
    _device = device;
    _isRead = isRead;
}

  NotificationData.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _content = json['content'];
    _notificationType = json['notificationType'];
    _referenceType = json['referenceType'];
    _referenceId = json['referenceId'];
    _description = json['description'];
    _createdDate = json['createdDate'];
    _createdUserId = json['createdUserId'];
    _modifiedDate = json['modifiedDate'];
    _modifiedUserId = json['modifiedUserId'];
    _userId = json['userId'];
    _device = json['device'];
    _isRead = json['isRead'];
  }
  String? _id;
  String? _title;
  String? _content;
  String? _notificationType;
  num? _referenceType;
  String? _referenceId;
  String? _description;
  String? _createdDate;
  String? _createdUserId;
  String? _modifiedDate;
  String? _modifiedUserId;
  String? _userId;
  String? _device;
  bool? _isRead;
NotificationData copyWith({  String? id,
  String? title,
  String? content,
  String? notificationType,
  num? referenceType,
  String? referenceId,
  String? description,
  String? createdDate,
  String? createdUserId,
  String? modifiedDate,
  String? modifiedUserId,
  String? userId,
  String? device,
  bool? isRead,
}) => NotificationData(  id: id ?? _id,
  title: title ?? _title,
  content: content ?? _content,
  notificationType: notificationType ?? _notificationType,
  referenceType: referenceType ?? _referenceType,
  referenceId: referenceId ?? _referenceId,
  description: description ?? _description,
  createdDate: createdDate ?? _createdDate,
  createdUserId: createdUserId ?? _createdUserId,
  modifiedDate: modifiedDate ?? _modifiedDate,
  modifiedUserId: modifiedUserId ?? _modifiedUserId,
  userId: userId ?? _userId,
  device: device ?? _device,
  isRead: isRead ?? _isRead,
);
  String? get id => _id;
  String? get title => _title;
  String? get content => _content;
  String? get notificationType => _notificationType;
  num? get referenceType => _referenceType;
  String? get referenceId => _referenceId;
  String? get description => _description;
  String? get createdDate => _createdDate;
  String? get createdUserId => _createdUserId;
  String? get modifiedDate => _modifiedDate;
  String? get modifiedUserId => _modifiedUserId;
  String? get userId => _userId;
  String? get device => _device;
  bool? get isRead => _isRead;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['content'] = _content;
    map['notificationType'] = _notificationType;
    map['referenceType'] = _referenceType;
    map['referenceId'] = _referenceId;
    map['description'] = _description;
    map['createdDate'] = _createdDate;
    map['createdUserId'] = _createdUserId;
    map['modifiedDate'] = _modifiedDate;
    map['modifiedUserId'] = _modifiedUserId;
    map['userId'] = _userId;
    map['device'] = _device;
    map['isRead'] = _isRead;
    return map;
  }

}