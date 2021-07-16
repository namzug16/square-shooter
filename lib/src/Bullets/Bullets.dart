import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'Bullets.freezed.dart';

@freezed
class Bullets with _$Bullets {
  factory Bullets({
    @Default(5) int damage,
    required double direction,
    @Default(Colors.white) Color color,
  }) = _Bullets;
}

class SimpleBullet {
  SimpleBullet({
    this.damage = 5,
    required this.direction,
    required this.color,
    required this.position,
  });

  final int damage;
  final double direction;
  final Color color;
  final Offset position;

  static const Size bulletSize = Size(30, 5);
  static const double velocity = 20.0;

  Offset bulletPosition = Offset.zero;
  void renderBullet(Canvas canvas){
    _move();
    final rect = Rect.fromLTWH(bulletPosition.dx -bulletSize.width/2,bulletPosition.dy -bulletSize.height/2, bulletSize.width, bulletSize.height);
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate((direction + pi*3/2)*-1);
    canvas.drawRect(rect, Paint()..color=color);
    canvas.restore();
  }

  void _move(){
    bulletPosition = Offset(bulletPosition.dx + velocity, bulletPosition.dy);
  }

  Rect getRect(){
    return Rect.fromLTWH(bulletPosition.dx, bulletPosition.dy, bulletSize.width, bulletSize.height);
  }

}
