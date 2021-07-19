import 'dart:math';

import 'package:flutter/cupertino.dart';

class Charge {
  Charge({
    required this.radius,
    this.startAngle = 0,
    this.endAngle = 2 * pi,
    this.factor = 0.1,
    required this.origin,
    this.rotation = 0,
    required this.color,
    this.strokeWidth = 10,
  });

  final double radius;
  final double startAngle;
  final double endAngle;
  final double factor;
  final Offset origin;
  final double rotation;
  final Color color;
  final double strokeWidth;

  bool get isFinished => _isFinished;
  bool _isFinished = false;

  double? _actualAngle;

  void renderCharge(Canvas c) {
    if(_actualAngle == null) _actualAngle = startAngle;
    if(_actualAngle! < endAngle) _update();
    c.save();
    c.translate(origin.dx, origin.dy);
    c.rotate(-rotation -pi/2 + pi);
    c.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      startAngle,
      _actualAngle!,
      false,
      Paint()..color=color..style=PaintingStyle.stroke..strokeCap=StrokeCap.round..strokeWidth=strokeWidth,
    );
    c.restore();
  }

  void restart(){
    _actualAngle = startAngle;
  }

  void _update(){
    _actualAngle = _actualAngle! + factor;
    _actualAngle!.clamp(0, endAngle);
    if(_actualAngle! >= endAngle) _isFinished = true;
  }
}
