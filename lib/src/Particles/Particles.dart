import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Particle {
  Particle({
    this.isSquare = false,
    this.size = 10,
    this.color = Colors.white,
    required this.origin,
    required this.direction,
    this.initialVelocity = 20,
  });

  final bool isSquare;
  final double size;
  final Color color;
  final Offset origin;
  final double direction;
  final double initialVelocity;

  Offset _position = Offset.zero;
  double get opacity => _opacity;
  double _opacity = 1;

  void renderParticle(Canvas c) {

    _updateParticle();

    Paint paint = Paint()..color=color.withOpacity(_opacity);
    c.save();
    c.translate(origin.dx, origin.dy);
    c.rotate(direction);
    if(isSquare){
      c.drawRect(Rect.fromCircle(center: _position, radius: size), paint);
    }else{
      c.drawCircle(_position - Offset(size/2, size/2), size, paint);
    }
    c.restore();
  }

  double? _velocity;
  double _acceleration = 1;

  void _updateParticle(){
    if(_velocity == null) _velocity = initialVelocity;
    if(_velocity! > 0) _velocity = (_velocity! - _acceleration*Random().nextDouble()).clamp(0, initialVelocity);
    _position += Offset(_velocity!, 0);
    if(_opacity > 0) _opacity -= 0.05;
    if(_opacity < 0) _opacity = 0;
  }
}
