import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Bullets/Bullets.dart';
import 'package:square_shooter/src/Bullets/LaserBeam.dart';
import 'package:square_shooter/src/Explosions/Explosion.dart';
import 'package:square_shooter/src/Player/PlayerController.dart';
import '../Extensions/OffsetExtension.dart';
import '../Extensions/RectExtensions.dart';
import 'Enemy.dart';

class EnemyController extends StateNotifier<Enemy> {
  EnemyController(this.read) : super(Enemy());

  final Reader read;

  static const double enemySize = 50;
  static const int maxVelocity = 15;
  static const int maxVelocityShooting = 10;
  static const double acceleration = 0.3;
  static const double rotationValue = pi / 40;
  static const double aimSizeStart = enemySize + 20;
  static const double aimSize = 100;

  Offset _aim = Offset.zero;
  double _aimAngle = 0;
  List<Bullet> bullets = [];
  LaserBeam? laserBeam;

  bool get gameOver => _gameOver;
  bool _gameOver = false;

  void renderEnemy(Canvas c, x) {
    final center = (state.position! + Offset(enemySize / 2, enemySize / 2));
    final angle = center.angleTo(_aim);
    _aimAngle = angle;
    _setAim();
    // _shoot();
    // if (isAlive()) {
    //   if (read(playerProvider.notifier).isAlive()) {
    //     if (!isShooting) _shoot();
    //   }
    //   _updateRotation();
    //   _move(x);
    // }
    final rect = Rect.fromLTWH(
        state.position!.dx, state.position!.dy, enemySize, enemySize);
    // * ===========================> Bullets
    if (bullets.length > 0) {
      for (var b in bullets) {
        b.renderBullet(c);
        if (b.canDamage &&
            b.getRect().outsideRegion(Rect.fromLTWH(0, 0, x.width, x.height))) {
          bullets.remove(b);
        }
        if (b.shouldBeEliminated) bullets.remove(b);
      }
    }

    // * ==========================> Enemy
    if (isAlive()) {
      c.save();
      c.translate(rect.center.dx, rect.center.dy);
      c.rotate(state.rotation!);
      c.drawRect(Offset(-enemySize / 2, -enemySize / 2) & rect.size,
          Paint()..color = state.color!);
      c.restore();
    } else {
      _destroy(c);
    }

    // * ===========================> PlayerBulletsDetection
    if (read(playerProvider.notifier).bullets.length > 0) {
      final enemyBullets = read(playerProvider.notifier).bullets;
      for (var b in enemyBullets) {
        if (b.canDamage && b.getRect().collides(rect)) {
          state = state.copyWith(
              color: Colors.redAccent, health: state.health! - b.damage);
          _colorChange();
          b.destroy();
        }
      }
    }

    // * ==========================> LaserBeam
    // _activateLaserBeam();
    if (laserBeam != null) {
      laserBeam!.renderLaserBeam(c);
    }

    // * ==========================> AimLine
    if (isAlive()) {
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

  // * ================================= >

  bool isAlive() {
    if (state.health! > 0) return true;
    return false;
  }

  Offset getCenter() {
    return (state.position! + Offset(enemySize / 2, enemySize / 2));
  }

  // * ================================= > Private
  bool isActiveLB = false;
  void _activateLaserBeam() {
    if (!isActiveLB) {
      state = state.copyWith(
          color: Colors.blueAccent, velocity: 0, direction: Offset.zero);
      laserBeam = LaserBeam(
          factor: 1,
          color: state.color!,
          direction: _aimAngle,
          origin: state.position! + Offset(enemySize / 2, enemySize / 2));
      isActiveLB = true;
    }
    // laserBeam = null;
    // isActiveLB = false;
    // _colorChange();
    //
  }

  void _setAim() {
    _aim = read(playerProvider.notifier).getCenter();
    // aim = Offset(900, 900);
  }

  bool isShooting = false;
  Timer? t;

  void _shoot() {
    if (!isShooting) isShooting = !isShooting;
    if (isShooting && t == null) {
      state = state.copyWith(color: Colors.blueAccent);
      t = Timer.periodic(Duration(milliseconds: 3000), (timer) {
        _colorChange();
        bullets.add(Bullet(
          damage: 15,
          direction: _aimAngle,
          color: Colors.blueAccent,
          position: Rect.fromLTWH(
                  state.position!.dx, state.position!.dy, enemySize, enemySize)
              .center,
        ));
      });
      // if (bullets.length > 4) t!.cancel();
    }
  }

  void _getDirection() {
    final player = read(playerProvider.notifier);
    final double? velocity = player.getVelocity();
    // if(velocity! > 5){
    //   state = state.copyWith(direction: Offset(_getRandomDir(state.direction!.dx), _getRandomDir(state.direction!.dy)));
    // }else{
    //   state = state.copyWith(direction: Offset.zero) ;
    // }
    state = state.copyWith(
        direction: Offset(_getRandomDir(state.direction!.dx),
            _getRandomDir(state.direction!.dy)));
  }

  void _move(x) {
    if (_needsToMove(x)) {
      if (read(playerProvider.notifier).isAlive()) {
        _getDirection();
      } else {
        state = state.copyWith(direction: Offset.zero);
      }
    }
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
            .clamp(
                Offset.zero, Offset(x.width - enemySize, x.height - enemySize)),
      );
    }
  }

  bool _needsToMove(x) {
    final center = _getCenter();
    final double padding = 50.0;
    if (center.dx < padding && state.direction!.dx == -1.0) return true;
    if (center.dx + padding > x.width && state.direction!.dx == 1) return true;
    if (center.dy < padding && state.direction!.dy == -1) return true;
    if (center.dy + padding > x.height && state.direction!.dy == 1) return true;
    if (state.direction!.dy == 0 && state.direction!.dx == 0) return true;
    if (!read(playerProvider.notifier).isAlive() &&
        state.direction != Offset.zero) return true;
    return false;
  }

  Offset _getCenter() {
    return (state.position! + Offset(enemySize / 2, enemySize / 2));
  }

  void _updateRotation() {
    state = state.copyWith(
        rotation: state.rotation! +
            rotationValue +
            rotationValue * state.velocity! / 5);
  }

  void _colorChange() {
    Timer(Duration(milliseconds: 64), () {
      state = state.copyWith(color: Colors.black);
    });
  }

  double _getRandomDir(double dir) {
    List<double> values = [-1, 0, 1];
    // values.remove(dir);
    return values[Random().nextInt(values.length)];
  }

  Explosion? e;
  void _destroy(Canvas c) {
    if (e == null)
      e = Explosion(
        isSquare: true,
        origin: _getCenter(),
        color: Colors.blueAccent,
        sizeParticles: 5,
        amountParticles: 100,
        velocityParticles: 40,
      );
    e!.renderExplosion(c);
    if(e!.isFinished) _gameOver = true;
  }
}

final enemyProvider = StateNotifierProvider<EnemyController, Enemy>(
    (ref) => EnemyController(ref.read));
