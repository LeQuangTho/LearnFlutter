class Data {
  String? bucketName;
  String? objectName;
  String? fileName;
  int? fileType;

  Data({this.bucketName, this.objectName, this.fileName, this.fileType});

  @override
  String toString() {
    return 'Data(bucketName: $bucketName, objectName: $objectName, fileName: $fileName, fileType: $fileType)';
  }

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        bucketName: json['bucketName'] as String?,
        objectName: json['objectName'] as String?,
        fileName: json['fileName'] as String?,
        fileType: json['fileType'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'bucketName': bucketName,
        'objectName': objectName,
        'fileName': fileName,
        'fileType': fileType,
      };
}
