class EkycCreateEformResponse {
  String? eFormType;
  String? documentCode;
  String? fileUrl;

  EkycCreateEformResponse({this.eFormType, this.documentCode, this.fileUrl});

  @override
  String toString() {
    return 'Data(eFormType: $eFormType, documentCode: $documentCode, fileUrl: $fileUrl)';
  }

  factory EkycCreateEformResponse.fromJson(Map<String, dynamic> json) =>
      EkycCreateEformResponse(
        eFormType: json['eFormType'] as String?,
        documentCode: json['documentCode'] as String?,
        fileUrl: json['fileUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'eFormType': eFormType,
        'documentCode': documentCode,
        'fileUrl': fileUrl,
      };

  EkycCreateEformResponse copyWith({
    String? eFormType,
    String? documentCode,
    String? fileUrl,
  }) {
    return EkycCreateEformResponse(
      eFormType: eFormType ?? this.eFormType,
      documentCode: documentCode ?? this.documentCode,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}
