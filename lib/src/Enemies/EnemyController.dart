import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Bullets/Bullets.dart';
import 'package:square_shooter/src/Player/PlayerController.dart';
import '../Extensions/OffsetExtension.dart';
import '../Extensions/RectExtensions.dart';
import 'Enemy.dart';

class EnemyController extends StateNotifier<Enemy> {
  EnemyController(this.read) : super(Enemy());

  final Reader read;

  static const double enemySize = 50;
  static const int maxVelocity = 20;
  static const double acceleration = 0.3;
  static const double rotationValue = pi/40;
  static const double aimSizeStart = enemySize + 20;
  static const double aimSize = 100;

  Offset aim = Offset.zero;
  double aimAngle = 0;
  List<Bullet> bullets = [];
  bool isShooting = false;

  void renderEnemy(Canvas c, x) {
    final center = (state.position! + Offset(enemySize / 2, enemySize / 2));
    final angle = center.angleTo(aim);
    aimAngle = angle;
    _setAim();
    _updateRotation();
    _move(x);
    if(!isShooting) _shoot();
    final rect = Rect.fromLTWH(
        state.position!.dx, state.position!.dy, enemySize, enemySize);
    // * ===========================> Bullets
    if (bullets.length > 0) {
      for (var b in bullets) {
        b.renderBullet(c);
        // if (b.getRect().outsideRegion(Rect.fromLTWH(0, 0, x.width, x.height))) {
        //   bullets.remove(b);
        // }
      }
    }

    // * ==========================> Enemy
    c.save();
    c.translate(rect.center.dx, rect.center.dy);
    c.rotate(state.rotation!);
    c.drawRect(Offset(-enemySize/2, -enemySize/2) & rect.size, Paint()..color = state.color!);
    c.restore();


    // * ==========================> AimLine
    c.save();
    final aimPaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    c.drawLine(
        center + Offset(aimSizeStart * sin(angle), aimSizeStart * cos(angle)),
        center + Offset(aimSize * sin(angle), aimSize * cos(angle)),
        aimPaint);
    c.drawLine(
      center + Offset(aimSizeStart * sin(angle+pi/7), aimSizeStart * cos(angle+pi/7)),
      center + Offset(aimSizeStart * sin(angle), aimSizeStart * cos(angle)),
      aimPaint,
    );
    c.drawLine(
      center + Offset(aimSizeStart * sin(angle-pi/7), aimSizeStart * cos(angle-pi/7)),
      center + Offset(aimSizeStart * sin(angle), aimSizeStart * cos(angle)),
      aimPaint,
    );
    c.restore();
  }

  Offset oldDirection = Offset.zero;
  Offset direction = Offset.zero;

  // * ================================= >

  void _setAim() {
    aim = read(playerProvider.notifier).getCenter();
  }

  void _shoot() {
    isShooting = true;
    Timer.periodic(Duration(milliseconds: 150), (timer) {
      state = state.copyWith(color: Colors.blueAccent);
      _colorChange();
      bullets.add(Bullet(
        direction: aimAngle,
        color: Colors.blueAccent,
        position: Rect.fromLTWH(
            state.position!.dx, state.position!.dy, enemySize, enemySize)
            .center,
      ));
      if(bullets.length > 4) timer.cancel();
    });
    Timer(Duration(seconds: 3), (){
      isShooting = false;
    });
  }

  void _getDirection() {
    final player = read(playerProvider.notifier);
    final double? velocity = player.getVelocity();
    // if(velocity! > 5){
    //   state = state.copyWith(direction: Offset(_getRandomDir(state.direction!.dx), _getRandomDir(state.direction!.dy)));
    // }else{
    //   state = state.copyWith(direction: Offset.zero) ;
    // }
    state = state.copyWith(direction: Offset(_getRandomDir(state.direction!.dx), _getRandomDir(state.direction!.dy)));

  }

  void _move(x) {
    // if(_needsToMove(x)) _getDirection();
    if (state.direction! == Offset.zero) {
      if (state.velocity! > 0) {
        state = state.copyWith(
          velocity:
          (state.velocity! - acceleration).clamp(0, maxVelocity).toDouble(),
          position: (state.position! +
              Offset(state.velocity! * oldDirection.dx,
                  state.velocity! * oldDirection.dy))
              .clamp(Offset.zero,
              Offset(x.width - enemySize, x.height - enemySize)),
        );
      }
    } else {
      state = state.copyWith(
        velocity:
        (state.velocity! + acceleration).clamp(0, maxVelocity).toDouble(),
        position: (state.position! +
            Offset(state.velocity! * state.direction!.dx,
                state.velocity! * state.direction!.dy))
            .clamp(Offset.zero,
            Offset(x.width - enemySize, x.height - enemySize)),
      );
    }
  }

  bool _needsToMove(x){
    final center = _getCenter();
    final double padding = 50.0;
    if(center.dx < padding && state.direction!.dx == -1.0) return true;
    if(center.dx + padding > x.width && state.direction!.dx == 1) return true;
    if(center.dy < padding && state.direction!.dy == -1) return true;
    if(center.dy + padding > x.height && state.direction!.dy == 1) return true;
    if(state.direction!.dy == 0 && state.direction!.dx == 0) return true;
    return false;
  }

  Offset _getCenter(){
    return (state.position! + Offset(enemySize / 2, enemySize / 2));
  }

  void _updateRotation(){
    state = state.copyWith(rotation: state.rotation! + rotationValue + rotationValue*state.velocity!/10);
  }

  void _colorChange(){
    Timer(Duration(milliseconds: 64), (){
      state = state.copyWith(color: Colors.white);
    });
  }

  double _getRandomDir(double dir){
    List<double> values = [-1 , 0, 1];
    // values.remove(dir);
    return values[Random().nextInt(values.length)];
  }

  void deleteBullet(int i){
    bullets.removeAt(i);
  }
}

final enemyProvider = StateNotifierProvider<EnemyController, Enemy>(
        (ref) => EnemyController(ref.read));
