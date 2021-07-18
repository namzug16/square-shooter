import 'dart:math';
import 'dart:ui';

class LaserBeam {
  LaserBeam({
    required this.origin,
    required this.direction,
    required this.color,
    this.factor = 0.1
  });

  final Offset origin;
  final double direction;
  final Color color;
  final double factor;

  static const int damage = 999;
  static const double length = 5000;
  static const double maxWeight = 8;
  static const double radius = 50;

  double weight = 2;

  bool get isFinished => _getIsFinished();

  List<Offset> get line => _getLine();

  void renderLaserBeam(Canvas c) {
    c.save();
    c.drawCircle(origin, radius, Paint()..color=color..style=PaintingStyle.stroke..strokeWidth=5);
    c.drawLine(
        origin,
        origin + Offset(length * sin(direction), length * cos(direction)),
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = _getWeight().clamp(0, maxWeight)
          ..strokeCap = StrokeCap.round);
    c.restore();
  }


  double _getWeight(){
    return weight += factor;
  }

  List<Offset> _getLine(){
    return [origin, origin + Offset(length * sin(direction), length * cos(direction))];
  }

  bool _getIsFinished(){
    return weight > maxWeight;
  }
}
