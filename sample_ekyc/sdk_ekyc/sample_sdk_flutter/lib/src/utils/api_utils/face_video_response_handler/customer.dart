class Customer {
  String? id;
  String? userId;
  String? name;
  // Null? phoneNumber;
  // Null? cif;
  String? cardId;
  String? profileImageUrl;
  _Metadata? metadata;
  String? created;
  String? updatedAt;

  Customer(
      {this.id,
      this.userId,
      this.name,
      // this.phoneNumber,
      // this.cif,
      this.cardId,
      this.profileImageUrl,
      this.metadata,
      this.created,
      this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    name = json['name'].toString();
    // phoneNumber = json['phone_number'];
    // cif = json['cif'];
    cardId = json['card_id'].toString();
    profileImageUrl = json['profile_image_url'].toString();
    metadata = json['metadata'] != null
        ? new _Metadata.fromJson(json['metadata'])
        : null;
    created = json['created'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    // data['phone_number'] = this.phoneNumber;
    // data['cif'] = this.cif;
    data['card_id'] = this.cardId;
    data['profile_image_url'] = this.profileImageUrl;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['created'] = this.created;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class _Metadata {
  String? source;

  _Metadata({this.source});

  _Metadata.fromJson(Map<String, dynamic> json) {
    source = json['source'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    return data;
  }
}
