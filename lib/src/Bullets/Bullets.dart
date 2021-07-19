import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:square_shooter/src/Explosions/Explosion.dart';
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

  static const double bulletSize = 15.0; // 5
  static const double velocity = 25.0; // 50

  Offset _bulletPosition = Offset.zero;
  bool _shouldDestroy = false;

  bool get canDamage => !_shouldDestroy;
  bool get shouldBeEliminated => _shouldBeEliminated;
  bool _shouldBeEliminated = false;

  void renderBullet(Canvas c) {
    Offset pos = Offset.zero;
    if(!_shouldDestroy){
    _move();
    pos = _getPosition();
    }
    if (!_shouldDestroy) {
      c.save();
      c.drawCircle(pos, bulletSize, Paint()..color = color);
      c.restore();
    }else{
      _explode(c);
    }
  }

  Rect getRect() {
    return Rect.fromCircle(center: _getPosition(), radius: bulletSize);
  }

  void destroy() {
    _shouldDestroy = true;
  }

  // * ===============> Private

  Explosion? e;
  void _explode(Canvas c){
    if(e == null) e = Explosion(isSquare: false, origin: _getPosition(), color: color, amountParticles: 50, sizeParticles: 2);
    e!.renderExplosion(c);
    if(e!.isFinished) _shouldBeEliminated = true;
  }

  void _move() {
    _bulletPosition = Offset(_bulletPosition.dx + velocity, _bulletPosition.dy);
  }

  Offset _getPosition() {
    return _bulletPosition.rotateWithPivot(
        Offset(position.dx - bulletSize / 2, position.dy - bulletSize / 2),
        pi / 2 - direction);
  }
}
