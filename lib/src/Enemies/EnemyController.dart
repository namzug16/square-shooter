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
    if (isAlive()) {
      if (read(playerProvider.notifier).isAlive()) {
        _checkCanShoot();
      }
      _updateRotation();
      _move(x);
    }
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
    // if (read(playerProvider.notifier).bullets.length > 0) {
    //   final playerBullets = read(playerProvider.notifier).bullets;
    //   for (var b in playerBullets) {
    //     if (b.canDamage && b.getRect().collides(rect)) {
    //       state = state.copyWith(
    //           color: Colors.redAccent, health: state.health! - b.damage);
    //       _isHurt = true;
    //       _colorChange();
    //       b.destroy();
    //     }
    //   }
    // }

    // * ==========================> LaserBeam
    // _activateLaserBeam();
    if (laserBeam != null) {
      laserBeam!.renderLaserBeam(c);
    }

    // * =========================> LaserBeam Player

    _verifyLaserBeamPlayer();

    // * ==========================> AimLine
    if (isAlive() && _isShooting) {
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

  Offset _oldDirection = Offset.zero;
  Offset _direction = Offset.zero;

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

  void _verifyLaserBeamPlayer(){
    if(read(playerProvider.notifier).isActiveLB && read(playerProvider.notifier).laserBeam!.isFinished){
      final rect = Rect.fromLTWH(state.position!.dx, state.position!.dy, enemySize, enemySize);
      final line = read(playerProvider.notifier).laserBeam!.line;
      if(rect.intersectsLine(line[0], line[1])){
        state = state.copyWith(health: 0);
      }
    }
  }

  void _setAim() {
    _aim = read(playerProvider.notifier).getCenter();
    // aim = Offset(900, 900);
  }

  bool _isShooting = false;
  bool _canShoot = false;
  Timer? _t;

  void _checkCanShoot(){
    if(read(playerProvider.notifier).isShooting){
      _canShoot = true;
      _shoot();
    }else{
      _stopShooting();
    }
  }

  void _stopShooting(){
    if(_canShoot) _canShoot = !_canShoot;
    if( _t != null && _t!.isActive) _t!.cancel(); _t = null;
    if(_isShooting) _isShooting = !_isShooting;
  }

  void _shoot() {
    if ( _canShoot && !_isShooting) _isShooting = !_isShooting;
    if ( _canShoot && _isShooting && _t == null) {
      state = state.copyWith(color: Colors.blueAccent);
      _t = Timer.periodic(Duration(milliseconds: 500), (timer) {
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

  void _move(x) {
    if (_needsToMove(x)) {
      if (read(playerProvider.notifier).isAlive()) {
        _getDirection();
      } else {
        state = state.copyWith(direction: Offset.zero);
      }
    }

    // * ==========> Acceleration and Deceleration

    if (state.direction! == Offset.zero) {
      if (state.velocity! > 0) {
        state = state.copyWith(
          velocity:
              (state.velocity! - acceleration).clamp(0, maxVelocity).toDouble(),
          position: (state.position! +
                  Offset(state.velocity! * _oldDirection.dx,
                      state.velocity! * _oldDirection.dy))
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

  void _getDirection() {
    state = state.copyWith(
        direction: Offset(_getRandomDir(state.direction!.dx),
            _getRandomDir(state.direction!.dy)));
  }

  bool _needsToMove(x) {
    final center = _getCenter();
    final double padding = 100.0;

    return false;
  }

  double _getRandomDir(double dir) {
    List<double> values = [-1, 0, 1];
    return values[Random().nextInt(values.length)];
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

  bool get isHurt => _isHurt;
  bool _isHurt = false;

  void _colorChange() {
    Timer(Duration(milliseconds: 100), () {
      state = state.copyWith(color: Colors.black);
      if (_isHurt) _isHurt = !_isHurt;
    });
  }

  Explosion? _e;
  void _destroy(Canvas c) {
    if (_e == null)
      _e = Explosion(
        isSquare: true,
        origin: _getCenter(),
        color: Colors.blueAccent,
        sizeParticles: 5,
        amountParticles: 100,
        velocityParticles: 40,
      );
    _e!.renderExplosion(c);
    if(_e!.isFinished) _gameOver = true;
  }
}

final enemyProvider = StateNotifierProvider<EnemyController, Enemy>(
    (ref) => EnemyController(ref.read));
