class EkycEformCTSData {
  String? eFormType;
  String? name;
  String? documentCode;
  String? fileUrl;
  String? identityNumber;
  String? timeCTS;

  EkycEformCTSData(
      {this.eFormType,
      this.documentCode,
      this.fileUrl,
      this.name,
      this.identityNumber,
      this.timeCTS});

  @override
  String toString() {
    return 'Data(eFormType: $eFormType, documentCode: $documentCode, fileUrl: $fileUrl)';
  }

  factory EkycEformCTSData.fromJson(Map<String, dynamic> json) =>
      EkycEformCTSData(
        eFormType: json['eFormType'] as String?,
        name: json['name'] as String?,
        timeCTS: json['timeCTS'] as String?,
        identityNumber: json['identityNumber'] as String?,
        documentCode: json['documentCode'] as String?,
        fileUrl: json['fileUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'eFormType': eFormType,
        'name': name,
        'timeCTS': timeCTS,
        'identityNumber': identityNumber,
        'documentCode': documentCode,
        'fileUrl': fileUrl,
      };

  EkycEformCTSData copyWith(
      {String? eFormType,
      String? documentCode,
      String? fileUrl,
      String? identityNumber,
      String? timeCTS,
      String? name}) {
    return EkycEformCTSData(
      eFormType: eFormType ?? this.eFormType,
      documentCode: documentCode ?? this.documentCode,
      fileUrl: fileUrl ?? this.fileUrl,
      identityNumber: identityNumber ?? this.identityNumber,
      name: name ?? this.name,
      timeCTS: timeCTS ?? this.timeCTS,
    );
  }
}
