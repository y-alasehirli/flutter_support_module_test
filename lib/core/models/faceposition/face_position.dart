class FaceCoordinate {
  int? height;
  int? width;
  int? x;
  int? y;

  FaceCoordinate({this.height, this.width, this.x, this.y});

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'width': width,
      'x': x,
      'y': y,
    };
  }

  factory FaceCoordinate.fromMap(Map<String, dynamic> map) {
    return FaceCoordinate(
      height: map['height']?.toInt(),
      width: map['width']?.toInt(),
      x: map['x']?.toInt(),
      y: map['y']?.toInt(),
    );
  }
}
