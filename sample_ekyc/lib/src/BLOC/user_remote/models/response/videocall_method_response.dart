import 'dart:convert';

class VideoCallMethodResponse {
  VideoCallMethodResponse({
    this.code,
    this.data,
    this.message,
    this.messageCode,
    this.requestId,
    this.version,
  });

  final int? code;
  final VideoCallMethodData? data;
  final String? message;
  final String? messageCode;
  final String? requestId;
  final String? version;

  factory VideoCallMethodResponse.fromJson(String str) =>
      VideoCallMethodResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VideoCallMethodResponse.fromMap(Map<String, dynamic> json) =>
      VideoCallMethodResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null
            ? null
            : VideoCallMethodData.fromMap(json["data"]),
        message: json["message"] == null ? null : json["message"],
        messageCode: json["message_code"] == null ? null : json["message_code"],
        requestId: json["request_id"] == null ? null : json["request_id"],
        version: json["version"] == null ? null : json["version"],
      );

  Map<String, dynamic> toMap() => {
        "code": code == null ? null : code,
        "data": data == null ? null : data?.toMap(),
        "message": message == null ? null : message,
        "message_code": messageCode == null ? null : messageCode,
        "request_id": requestId == null ? null : requestId,
        "version": version == null ? null : version,
      };
}

class VideoCallMethodData {
  VideoCallMethodData({
    this.entries,
    this.pagination,
  });

  final List<VideoCallMethodDataEntry>? entries;
  final Pagination? pagination;

  factory VideoCallMethodData.fromJson(String str) =>
      VideoCallMethodData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VideoCallMethodData.fromMap(Map<String, dynamic> json) =>
      VideoCallMethodData(
        entries: json["entries"] == null
            ? null
            : List<VideoCallMethodDataEntry>.from(json["entries"]
                .map((x) => VideoCallMethodDataEntry.fromMap(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromMap(json["pagination"]),
      );

  Map<String, dynamic> toMap() => {
        "entries": entries == null
            ? null
            : List<dynamic>.from((entries ?? []).map((x) => x.toMap())),
        "pagination": pagination == null ? null : pagination?.toMap(),
      };
}

class VideoCallMethodDataEntry {
  VideoCallMethodDataEntry({
    this.id,
    this.name,
    this.icon,
    this.description,
    this.content,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? icon;
  final String? description;
  final String? content;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VideoCallMethodDataEntry.fromJson(String str) =>
      VideoCallMethodDataEntry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VideoCallMethodDataEntry.fromMap(Map<String, dynamic> json) =>
      VideoCallMethodDataEntry(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        icon: json["icon"] == null ? null : json["icon"],
        description: json["description"] == null ? null : json["description"],
        content: json["content"] == null ? null : json["content"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "icon": icon == null ? null : icon,
        "description": description == null ? null : description,
        "content": content == null ? null : content,
        "is_active": isActive == null ? null : isActive,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
      };
  static final zalo = VideoCallMethodDataEntry(
    id: 2,
    name: 'Zalo',
    icon: '',
    description: "",
    content: "",
    isActive: true,
  );
}

class Pagination {
  Pagination({
    this.current,
    this.pageSize,
    this.search,
    this.sorts,
    this.filters,
    this.total,
    this.totalPages,
  });

  final int? current;
  final int? pageSize;
  final String? search;
  final dynamic sorts;
  final dynamic filters;
  final int? total;
  final int? totalPages;

  factory Pagination.fromJson(String str) =>
      Pagination.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
        current: json["current"] == null ? null : json["current"],
        pageSize: json["pageSize"] == null ? null : json["pageSize"],
        search: json["search"] == null ? null : json["search"],
        sorts: json["sorts"],
        filters: json["filters"],
        total: json["total"] == null ? null : json["total"],
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
      );

  Map<String, dynamic> toMap() => {
        "current": current,
        "pageSize": pageSize,
        "search": search,
        "sorts": sorts,
        "filters": filters,
        "total": total,
        "total_pages": totalPages,
      };
}
