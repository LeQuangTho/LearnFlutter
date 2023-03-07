class Data {
  String? id;
  String? userId;
  String? fullName;
  String? nation;
  String? birthday;
  String? birthPlace;
  int? sex;
  String? identityNumber;
  String? issueDate;
  String? expireDate;
  String? issueBy;
  DateTime? createdDate;
  String? createdUserId;
  String? placeOfOrigin;
  String? placeOfResidence;

  Data({
    this.id,
    this.userId,
    this.fullName,
    this.nation,
    this.birthday,
    this.birthPlace,
    this.sex,
    this.identityNumber,
    this.issueDate,
    this.expireDate,
    this.issueBy,
    this.createdDate,
    this.createdUserId,
    this.placeOfOrigin,
    this.placeOfResidence,
  });

  @override
  String toString() {
    return 'Data(id: $id, userId: $userId, fullName: $fullName, nation: $nation, birthday: $birthday, birthPlace: $birthPlace, sex: $sex, identityNumber: $identityNumber, issueDate: $issueDate, expireDate: $expireDate, issueBy: $issueBy, createdDate: $createdDate, createdUserId: $createdUserId, placeOfOrigin: $placeOfOrigin, placeOfResidence: $placeOfResidence)';
  }

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'] as String?,
        userId: json['userId'] as String?,
        fullName: json['fullName'] as String?,
        nation: json['nation'] as String?,
        birthday: json['birthday'] as String?,
        birthPlace: json['birthPlace'] as String?,
        sex: json['sex'] as int?,
        identityNumber: json['identityNumber'] as String?,
        issueDate: json['issueDate'] as String?,
        expireDate: json['expireDate'] as String?,
        issueBy: json['issueBy'] as String?,
        createdDate: json['createdDate'] == null
            ? null
            : DateTime.parse(json['createdDate'] as String),
        createdUserId: json['createdUserId'] as String?,
        placeOfOrigin: json['placeOfOrigin'] as String?,
        placeOfResidence: json['placeOfResidence'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'fullName': fullName,
        'nation': nation,
        'birthday': birthday,
        'birthPlace': birthPlace,
        'sex': sex,
        'identityNumber': identityNumber,
        'issueDate': issueDate,
        'expireDate': expireDate,
        'issueBy': issueBy,
        'createdDate': createdDate?.toIso8601String(),
        'createdUserId': createdUserId,
        'placeOfOrigin': placeOfOrigin,
        'placeOfResidence': placeOfResidence,
      };

  Data copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? nation,
    String? birthday,
    String? birthPlace,
    int? sex,
    String? identityNumber,
    String? issueDate,
    String? expireDate,
    String? issueBy,
    DateTime? createdDate,
    String? createdUserId,
    String? placeOfOrigin,
    String? placeOfResidence,
  }) {
    return Data(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      nation: nation ?? this.nation,
      birthday: birthday ?? this.birthday,
      birthPlace: birthPlace ?? this.birthPlace,
      sex: sex ?? this.sex,
      identityNumber: identityNumber ?? this.identityNumber,
      issueDate: issueDate ?? this.issueDate,
      expireDate: expireDate ?? this.expireDate,
      issueBy: issueBy ?? this.issueBy,
      createdDate: createdDate ?? this.createdDate,
      createdUserId: createdUserId ?? this.createdUserId,
      placeOfOrigin: placeOfOrigin ?? this.placeOfOrigin,
      placeOfResidence: placeOfResidence ?? this.placeOfResidence,
    );
  }
}
