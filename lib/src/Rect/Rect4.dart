import 'dart:ui';

class Rect4 {
  const Rect4.fromPoints(
      this.topLeft, this.topRight, this.bottomRight, this.bottomLeft);

  Rect4.fromList(List<Offset> list)
      : this.fromPoints(list[0], list[1], list[2], list[3]);

  final Offset topLeft;
  final Offset topRight;
  final Offset bottomRight;
  final Offset bottomLeft;

  List<Offset> get points => [topLeft, topRight, bottomRight, bottomLeft];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    return other is Rect4 &&
        other.topLeft == topLeft &&
        other.topRight == topRight &&
        other.bottomRight == bottomRight &&
        other.bottomLeft == bottomLeft;
  }

  @override
  int get hashCode => hashValues(topLeft, topRight, bottomRight, bottomLeft);

  @override
  String toString() =>
      'Rect4.fromPoints(${topLeft.toString()}, ${topRight.toString()}, ${bottomRight.toString()}, ${bottomLeft.toString()})';
}
