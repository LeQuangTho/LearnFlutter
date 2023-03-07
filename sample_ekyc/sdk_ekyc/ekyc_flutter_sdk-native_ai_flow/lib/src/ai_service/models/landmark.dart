class Landmark {
  double x;
  double y;
  Landmark(this.x, this.y);
  void convert_to_real_size(double width, double height) {
    this.x = x * width;
    this.y = y * height;
  }

  static Landmark fromMap(Map<String, dynamic> map) {
    return new Landmark(map['x'], map['y']);
  }
}
