import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Bullets/Bullets.dart';
import 'package:square_shooter/src/Bullets/LaserBeam.dart';
import 'package:square_shooter/src/Enemies/EnemyController.dart';
import 'package:square_shooter/src/Player/Player.dart';
import '../Extensions/OffsetExtension.dart';
import '../Extensions/RectExtensions.dart';

class PlayerController extends StateNotifier<Player> {
  PlayerController(this.read) : super(Player());

  final Reader read;

  static const double playerSize = 50;
  static const int maxVelocity = 15;
  static const int maxVelocityShooting = 5;
  static const double acceleration = 0.3;
  static const double rotationValue = pi / 40;
  static const double aimSizeStart = playerSize + 20;
  static const double aimSize = 100;

  Offset aim = Offset.zero;
  double aimAngle = 0;
  List<Bullet> bullets = [];
  LaserBeam? laserBeam;

  void renderPlayer(Canvas c, x) {
    final center = getCenter();
    final angle = center.angleTo(aim);
    aimAngle = angle;
    if (isAlive()) {
      _updateRotation();
      _setAim();
      _move(x);
    }
    Rect rect = Rect.fromLTWH(
        state.position!.dx , state.position!.dy, playerSize, playerSize);
    if(isShooting) rect.scale(0.3);


    // * ===========================> Bullets
    if (bullets.length > 0) {
      for (var b in bullets) {
        b.renderBullet(c);
        if (b.canDamage && b.getRect().outsideRegion(Rect.fromLTWH(0, 0, x.width, x.height))) {
          bullets.remove(b);
        }
        if(b.shouldBeEliminated) bullets.remove(b);
      }
    }

    // * ===========================> EnemyBulletsDetection
    if (read(enemyProvider.notifier).bullets.length > 0) {
      final enemyBullets = read(enemyProvider.notifier).bullets;
      for (var b in enemyBullets) {
        // ? =============> In case bullets collide with other bullets
        for(var pb in bullets){
          if(pb.canDamage && pb.getRect().collides(b.getRect())){
            pb.destroy();
            b.destroy();
          }
          if(b.shouldBeEliminated) read(enemyProvider.notifier).bullets.remove(b);
          // if(pb.shouldBeEliminated) bullets.remove(b);
        }

        // ? ===========> Damage
        // if (b.getRect().collides(rect)) {
        //   state = state.copyWith(
        //       color: Colors.redAccent, health: state.health! - b.damage);
        //   isHurt = true;
        //   _colorChange();
        //   read(enemyProvider.notifier).bullets.remove(b);
        // }
      }
    }

    // * ==========================> LaserBeam

    if(laserBeam != null){
      laserBeam!.renderLaserBeam(c);
    }

    // * =========================> LaserBeam Enemy

    _verifyLaserBeamEnemy();

    // * ==========================> Player
    c.save();
    c.translate(rect.center.dx, rect.center.dy);
    c.rotate(state.rotation!);
    c.drawRect(Offset(-playerSize / 2, -playerSize / 2) & rect.size,
        Paint()..color = state.color!);
    c.restore();

    // * ==========================> AimLine
    if (isAlive() && isShooting) {
      c.save();
      final aimPaint = Paint()
        ..color = Colors.greenAccent
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      c.drawLine(
          center + Offset(aimSizeStart * sin(angle), aimSizeStart * cos(angle)),
          center + Offset(aimSize * sin(angle), aimSize * cos(angle)),
          aimPaint);
      c.drawLine(
        center +
            Offset(aimSizeStart * sin(angle + pi / 7),
                aimSizeStart * cos(angle + pi / 7)),
        center + Offset(aimSizeStart * sin(angle), aimSizeStart * cos(angle)),
        aimPaint,
      );
      c.drawLine(
        center +
            Offset(aimSizeStart * sin(angle - pi / 7),
                aimSizeStart * cos(angle - pi / 7)),
        center + Offset(aimSizeStart * sin(angle), aimSizeStart * cos(angle)),
        aimPaint,
      );
      c.restore();
    }
  }

  Offset oldDirection = Offset.zero;
  Offset direction = Offset.zero;
  bool overrideDirection = false;

  void setDirection(RawKeyEvent data) {
    if(!isActiveLB){
      if (data.runtimeType.toString() == "RawKeyDownEvent") {
        switch (data.character) {
          case "a":
            if (state.direction!.dx == 0) {
              direction = Offset(-1, state.direction!.dy);
            } else if (state.direction!.dx == 1) {
              direction = Offset(0, state.direction!.dy);
              overrideDirection = true;
            }
            break;
          case "w":
            if (state.direction!.dy == 0) {
              direction = Offset(state.direction!.dx, -1);
            } else if (state.direction!.dy == 1) {
              direction = Offset(state.direction!.dx, 0);
              overrideDirection = true;
            }
            break;
          case "d":
            if (state.direction!.dx == 0) {
              direction = Offset(1, state.direction!.dy);
            } else if (state.direction!.dx == -1) {
              direction = Offset(0, state.direction!.dy);
              overrideDirection = true;
            }
            break;
          case "s":
            if (state.direction!.dy == 0) {
              direction = Offset(state.direction!.dx, 1);
            } else if (state.direction!.dy == -1) {
              direction = Offset(state.direction!.dx, 0);
              overrideDirection = true;
            }
            break;
        }
      } else {
        switch (data.logicalKey.keyLabel) {
          case "a":
            if (overrideDirection) {
              direction = Offset(1, state.direction!.dy);
              overrideDirection = false;
            } else {
              direction = Offset(0, state.direction!.dy);
            }
            break;
          case "w":
            if (overrideDirection) {
              direction = Offset(state.direction!.dx, 1);
              overrideDirection = false;
            } else {
              direction = Offset(state.direction!.dx, 0);
            }
            break;
          case "d":
            if (overrideDirection) {
              direction = Offset(-1, state.direction!.dy);
              overrideDirection = false;
            } else {
              direction = Offset(0, state.direction!.dy);
            }
            break;
          case "s":
            if (overrideDirection) {
              direction = Offset(state.direction!.dx, -1);
              overrideDirection = false;
            } else {
              direction = Offset(state.direction!.dx, 0);
            }
            break;
        }
      }
    }else{
      direction = Offset.zero;
    }

    if (direction != Offset.zero) oldDirection = direction;
    state = state.copyWith(direction: direction);
  }

  bool isShooting = false;
  Timer? t;
  void shoot(RawKeyEvent data) {
    if (data.character != null) {
      print('shoot');
      if (!isShooting) isShooting = !isShooting;
      if (isShooting && t == null) {
        state = state.copyWith(color: Colors.greenAccent);
        t = Timer.periodic(Duration(milliseconds: 500), (timer) {
          if (isAlive()) {
            bullets.add(Bullet(
              direction: aimAngle,
              color: Colors.greenAccent,
              position: Rect.fromLTWH(state.position!.dx, state.position!.dy,
                  playerSize, playerSize)
                  .center,
            ));
          }
        });
      }
    } else {
      if(t!.isActive) {
        t!.cancel();
        t = null;
      }
      _colorChange();
      isShooting = false;
    }
  }

  bool isActiveLB = false;
  void activateLaserBeam(RawKeyEvent data){

    if(data.character != null && !isActiveLB){
      state = state.copyWith(color: Colors.greenAccent, velocity: 0, direction: Offset.zero);
      laserBeam = LaserBeam(color: state.color!, direction: aimAngle, origin: state.position! + Offset(playerSize/2, playerSize/2));
      isActiveLB = true;
    }else if(data.character == null){
      laserBeam = null;
      isActiveLB = false;
      _colorChange();
    }
  }

  Offset getCenter() {
    return (state.position! + Offset(playerSize / 2, playerSize / 2));
  }

  double getVelocity() {
    return state.velocity!;
  }

  bool isAlive() {
    if (state.health! > 0) return true;
    return false;
  }

  void renderHitBox(Canvas c){
    final rect = Rect.fromLTWH(state.position!.dx, state.position!.dy, playerSize, playerSize);
    c.drawRect(rect, Paint()..color=Colors.lightBlueAccent.withOpacity(0.3));
  }

  // * ================================= >

  void _verifyLaserBeamEnemy(){
    if(read(enemyProvider.notifier).isActiveLB && read(enemyProvider.notifier).laserBeam!.isFinished){
      final rect = Rect.fromLTWH(state.position!.dx, state.position!.dy, playerSize, playerSize);
      final line = read(enemyProvider.notifier).laserBeam!.line;
      if(rect.intersectsLine(line[0], line[1])){
        state = state.copyWith(health: 0);
      }
    }
  }

  void _setAim() {
    aim = read(enemyProvider.notifier).getCenter();
  }

  void _move(x) {
    if (state.direction! == Offset.zero) {
      if (state.velocity! > 0) {
        state = state.copyWith(
          velocity: isShooting
              ? (state.velocity! - acceleration)
                  .clamp(0, maxVelocityShooting)
                  .toDouble()
              : (state.velocity! - acceleration)
                  .clamp(0, maxVelocity)
                  .toDouble(),
          position: (state.position! +
                  Offset(state.velocity! * oldDirection.dx,
                      state.velocity! * oldDirection.dy))
              .clamp(Offset.zero,
                  Offset(x.width - playerSize, x.height - playerSize)),
        );
      }
    } else {
      state = state.copyWith(
        velocity: isShooting
            ? (state.velocity! + acceleration).clamp(0, maxVelocityShooting).toDouble()
            : (state.velocity! + acceleration).clamp(0, maxVelocity).toDouble(),
        position: (state.position! +
                Offset(state.velocity! * state.direction!.dx,
                    state.velocity! * state.direction!.dy))
            .clamp(Offset.zero,
                Offset(x.width - playerSize, x.height - playerSize)),
      );
    }
  }

  void _updateRotation() {
    state = state.copyWith(
        rotation: state.rotation! +
            rotationValue +
            rotationValue * state.velocity! / 5);
  }

  bool isHurt = false;

  void _colorChange() {
    Timer(Duration(milliseconds: 100), () {
      state = state.copyWith(color: Colors.white);
      if (isHurt) isHurt = !isHurt;
    });
  }
}

final playerProvider = StateNotifierProvider<PlayerController, Player>(
    (ref) => PlayerController(ref.read));
