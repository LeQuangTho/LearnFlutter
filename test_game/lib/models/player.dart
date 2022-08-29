/// position : {"x":0.1,"y":0.1}

class Player {
  Player({
    this.position,
  });

  Player.fromJson(dynamic json) {
    position =
        json['position'] != null ? Position.fromJson(json['position']) : null;
  }

  Position? position;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (position != null) {
      map['position'] = position?.toJson();
    }
    return map;
  }

  @override
  String toString() {
    return "$position";
  }
}

/// x : 0.1
/// y : 0.1

class Position {
  Position({
    this.x,
    this.y,
  });

  Position.fromJson(dynamic json) {
    x = json['x'];
    y = json['y'];
  }

  num? x;
  num? y;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['x'] = x;
    map['y'] = y;
    return map;
  }

  @override
  String toString() {
    return "{x: $x, y: $y}";
  }
}
