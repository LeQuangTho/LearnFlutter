class Liveness {
  String? liveness;

  Liveness({this.liveness});

  Liveness.fromJson(Map<String, dynamic> json) {
    liveness = json['liveness'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['liveness'] = this.liveness;
    return data;
  }
}
