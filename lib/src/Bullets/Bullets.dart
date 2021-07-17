import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../Extensions/OffsetExtension.dart';


class Bullet {
  Bullet({
    this.damage = 5,
    required this.direction,
    required this.color,
    required this.position,
  });

  final int damage;
  final double direction;
  final Color color;
  final Offset position;

  static const double bulletSize = 5.0;
  static const double velocity = 15.0;

  Offset bulletPosition = Offset.zero;
  void renderBullet(Canvas canvas){
    _move();
    final pos = _getPosition();
    canvas.save();
    canvas.drawCircle(pos, bulletSize, Paint()..color=color);
    canvas.restore();
  }

  void _move(){
    bulletPosition = Offset(bulletPosition.dx + velocity, bulletPosition.dy);
  }

  Rect  getRect(){
    return Rect.fromCircle(center: _getPosition(), radius: bulletSize);
  }

  Offset _getPosition(){
    return bulletPosition.rotateWithPivot(Offset(position.dx - bulletSize/2, position.dy - bulletSize/2),pi/2 - direction);
  }

}
