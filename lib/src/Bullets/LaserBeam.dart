import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:square_shooter/src/Explosions/Explosion.dart';
import 'package:square_shooter/src/Widgets/Charge.dart';

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

  static const double length = 5000;
  static const double maxWeight = 2*pi;
  static const double radius = 50;

  double _weight = 0;
  Charge? charge;
  Explosion? e;

  bool get isFinished => _getIsFinished();

  List<Offset> get line => _getLine();

  void renderLaserBeam(Canvas c) {
    if(charge == null) charge = Charge(radius: radius, origin: origin, color: color, strokeWidth: 2*pi, rotation: direction);
    if(e == null) e = Explosion(isSquare: false, origin: origin, color: Colors.redAccent, amountParticles: 50, sizeParticles: 5);
    if(_weight < maxWeight) _getWeight();

    if(!isFinished) charge!.renderCharge(c);
    c.save();
    if(isFinished){
    c.drawCircle(origin, radius, Paint()..color=Colors.redAccent..style=PaintingStyle.stroke..strokeWidth=2*pi);
    }
    c.drawLine(
        origin,
        origin + Offset(length * sin(direction), length * cos(direction)),
        Paint()
          ..color = isFinished ? Colors.redAccent : color
          ..style = PaintingStyle.stroke
          ..strokeWidth = _weight
          ..strokeCap = StrokeCap.round);
    c.restore();

    if(isFinished) e!.renderExplosion(c);
  }


  double _getWeight(){
    return _weight += factor;
  }

  List<Offset> _getLine(){
    return [origin, origin + Offset(length * sin(direction), length * cos(direction))];
  }

  bool _getIsFinished(){
    return _weight > maxWeight;
  }
}
