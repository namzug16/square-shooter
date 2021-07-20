import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Bullets/Bullets.dart';
import 'package:square_shooter/src/Bullets/LaserBeam.dart';
import 'package:square_shooter/src/Enemies/Enemy.dart';
import 'package:square_shooter/src/Explosions/Explosion.dart';
import 'package:square_shooter/src/Player/PlayerControllerFSM.dart';
import 'package:square_shooter/src/States/States.dart';

import '../Extensions/OffsetExtension.dart';
import '../Extensions/RectExtensions.dart';

class EnemyControllerFSM extends StateNotifier<Enemy> {
  EnemyControllerFSM(Enemy state, {required this.read}) : super(state);

  final Reader read;

  late PlayerControllerFSM _player;

  bool get gameOver => _gameOver;
  bool _gameOver = false;

  MovementStates get mS => _mS;
  MovementStates _mS = MovementStates.Moving;

  AttackStates get aS => _aS;
  AttackStates _aS = AttackStates.None;

  bool get enemyAlive => _lS == LiveStates.Alive;
  LiveStates _lS = LiveStates.Alive;

  static const double enemySize = 50;
  static const int maxVelocity = 15;
  static const int maxVelocityShooting = 5;
  static const double acceleration = 0.3;
  static const double rotationValue = pi / 40;
  static const double aimSizeStart = enemySize + 20;
  static const double aimSize = 100;

  // ? ========================================================= Methods

  void init() {
    _player = read(playerFSMProvider.notifier);
  }

  // ! =====================================> RenderObjects
  void renderEnemy(Canvas c, x) {
    _pickAState();
    _stateLogic(c, x);

    Rect rect = Rect.fromLTWH(
        state.position.dx, state.position.dy, enemySize, enemySize);

    // ? ==========================> Enemy
    if (_lS == LiveStates.Alive) {
      c.save();
      c.translate(rect.center.dx, rect.center.dy);
      c.rotate(state.rotation);
      c.drawRect(Offset(-enemySize / 2, -enemySize / 2) & rect.size,
          Paint()..color = state.color);
      c.restore();
    }

    // ? ==========================> AimLine
    if (_aS == AttackStates.Shooting && _mS == MovementStates.Moving) {
      c.save();
      final aimPaint = Paint()
        ..color = state.attackColor
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      c.drawLine(
          center +
              Offset(
                  aimSizeStart * sin(_aimAngle), aimSizeStart * cos(_aimAngle)),
          center + Offset(aimSize * sin(_aimAngle), aimSize * cos(_aimAngle)),
          aimPaint);
      c.drawLine(
        center +
            Offset(aimSizeStart * sin(_aimAngle + pi / 7),
                aimSizeStart * cos(_aimAngle + pi / 7)),
        center +
            Offset(
                aimSizeStart * sin(_aimAngle), aimSizeStart * cos(_aimAngle)),
        aimPaint,
      );
      c.drawLine(
        center +
            Offset(aimSizeStart * sin(_aimAngle - pi / 7),
                aimSizeStart * cos(_aimAngle - pi / 7)),
        center +
            Offset(
                aimSizeStart * sin(_aimAngle), aimSizeStart * cos(_aimAngle)),
        aimPaint,
      );
      c.restore();
    }

    // ? ===========================> Bullets
    if (_bullets.length > 0) {
      for (var b in _bullets) {
        b.renderBullet(c);
        if (b.canDamage &&
            b.getRect().outsideRegion(Rect.fromLTWH(0, 0, x.width, x.height))) {
          _bullets.remove(b);
        }
        if (b.shouldBeEliminated) _bullets.remove(b);
      }
    }

    // ? ===========================> LaseBeam

    if (_laserBeam != null) {
      _laserBeam!.renderLaserBeam(c);
    }

    // ? ===========================> EnemyBulletsDetection
    if (_player.bullets.length > 0) {
      final playerBullets = _player.bullets;
      for (var b in playerBullets) {
        // * ======> Damage
        if (b.canDamage && b.getRect().collides(rect)) {
          _mS = MovementStates.Stunned;
          _angleStun = b.direction;
          b.destroy();
        }
      }
    }
  }

  // ! =========================================================> StateMachine
  void _stateLogic(Canvas c, x) {
    if (_lS == LiveStates.Alive) {
      _updateRotation();
      _setAim();
      if (_mS == MovementStates.Moving) {
        state = state.copyWith(color: state.initialColor);
        _move(x);
        if (_aS == AttackStates.Shooting) {
          state = state.copyWith(
              color: state.attackColor,
              velocity:
                  state.velocity.clamp(0, maxVelocityShooting).toDouble());
          _cancelLaserBeam();
          _shoot();
        } else if (_aS == AttackStates.LaserBeam) {
          state = state.copyWith(velocity: 0, color: state.attackColor);
          _cancelShooting();
          _activateLaserBeam();
        } else {
          // cancel attacks
          _cancelLaserBeam();
          _cancelShooting();
        }
      } else {
        state = state.copyWith(color: Colors.redAccent);
        // cancel attacks in case player was attacking when stunned
        _cancelLaserBeam();
        _cancelShooting();
        _stun(c);

        _move(x);
        state = state.copyWith(velocity: state.velocity.clamp(0, 2));
      }
    } else {
      // cancel attacks in case player was attacking when died :c
      _cancelLaserBeam();
      _cancelShooting();
      _destroy(c);
    }
  }

  AttackStates? savedAttackState;

  void _setState(oldState, newState) {
    if (newState.runtimeType == MovementStates) {
      _mS = newState;
    } else if (newState.runtimeType == AttackStates) {
      _aS = newState;
      // if (oldState == AttackStates.None) {
      //   _aS = newState;
      // } else {
      //   if (oldState != AttackStates.None &&
      //       newState != AttackStates.None &&
      //       newState != oldState) {
      //     print("Invalid Change of States");
      //     print(oldState);
      //     print(newState);
      //     // we need to save the state
      //     savedAttackState = oldState;
      //   } else {
      //     if (savedAttackState != null) {
      //       _aS = savedAttackState!;
      //       savedAttackState = null;
      //     } else {
      //       _aS = newState;
      //     }
      //   }
      // }
    } else if (newState.runtimeType == LiveStates) {
      _lS = newState;
    }
  }

  void _pickAState() {
    if (_player.mS == MovementStates.Stunned) {
      if (state.velocity == 0 && state.position.distanceTo(_player.center) > 300) {
        _setState(_aS, AttackStates.LaserBeam);
        return;
      }
      _setState(_aS, AttackStates.None);
      return;
    }
    if (_aS == AttackStates.LaserBeam && !_insideAim()) {
      _setState(_aS, AttackStates.None);
      return;
    }
    if (_player.aS == AttackStates.Shooting ||
        state.position.distanceTo(_player.center) > 300) {
      _setState(_aS, AttackStates.Shooting);
      return;
    }
  }

  // ! ===============================================================> Actions

  // * Movement

  Offset? _position;
  double _distance = 0;
  double _angleMovement = 0;

  void _getScapePosition(x){
    final distanceEscape = Random().nextInt(500);
    final randBool = Random().nextBool();
    final angleNextPosition =
        randBool ? _aimAngle + pi + pi / 2 : _aimAngle + pi - pi / 2;
    final pos = Offset(
        (distanceEscape *
            sin(angleNextPosition)).clamp(0, x.width - enemySize).toDouble(),
        (distanceEscape * cos(angleNextPosition)).clamp(0, x.height - enemySize).toDouble());
    _distance = state.position.distanceTo(pos);
    _angleMovement = state.position.angleTo(pos);
    _position = pos;
  }

  void _getNextPosition(x) {
    Offset pos = Offset(
        Random()
            .nextInt(x.width - enemySize)
            .clamp(enemySize, x.width - enemySize)
            .toDouble(),
        Random()
            .nextInt(x.height - enemySize)
            .clamp(enemySize, x.width - enemySize)
            .toDouble());
    _distance = state.position.distanceTo(pos);
    _angleMovement = state.position.angleTo(pos);
    _position = pos;
  }

  void _move(x) {
    if (_position == null || state.velocity == 0) _getNextPosition(x);

    if (state.position.distanceTo(_position!) < _distance / 2) {
      state = state.copyWith(
        velocity:
            (state.velocity - acceleration).clamp(0, maxVelocity).toDouble(),
        position: (state.position +
                Offset(state.velocity * sin(_angleMovement),
                    state.velocity * cos(_angleMovement)))
            .clamp(
                Offset.zero, Offset(x.width - enemySize, x.height - enemySize)),
      );
    } else {
      state = state.copyWith(
        velocity:
            (state.velocity + acceleration).clamp(0, maxVelocity).toDouble(),
        position: (state.position +
                Offset(state.velocity * sin(_angleMovement),
                    state.velocity * cos(_angleMovement)))
            .clamp(
                Offset.zero, Offset(x.width - enemySize, x.height - enemySize)),
      );
    }
  }

  void _updateRotation() {
    state = state.copyWith(
        rotation: state.rotation +
            rotationValue +
            rotationValue * state.velocity / 5);
  }

  // * Attacks && Aim
  Offset _aim = Offset.zero;
  double _aimAngle = 0;

  List<Bullet> get bullets => _bullets;
  List<Bullet> _bullets = [];

  LaserBeam? get laserBeam => _laserBeam;
  LaserBeam? _laserBeam;

  void _setAim() {
    _aim = _player.center;
    _aimAngle = state.position.angleTo(_aim);
  }

  Timer? _t;

  void _shoot() {
    if (_t == null) {
      _t = Timer.periodic(Duration(milliseconds: 500), (timer) {
        _bullets.add(Bullet(
          direction: _aimAngle,
          color: state.attackColor,
          position: Rect.fromLTWH(
                  state.position.dx, state.position.dy, enemySize, enemySize)
              .center,
        ));
      });
    }
  }

  void _cancelShooting() {
    if (_t != null && _t!.isActive) {
      _t!.cancel();
      _t = null;
    }
  }

  void _activateLaserBeam() {
    if (_laserBeam == null) {
      _laserBeam = LaserBeam(
          factor: 0.25,
          color: state.color,
          direction: _aimAngle,
          origin: state.position + Offset(enemySize / 2, enemySize / 2));
    }
  }

  void _cancelLaserBeam() {
    _laserBeam = null;
  }

  bool _insideAim() {
    final playerRect = _player.rect;
    final line = laserBeam!.line;
    return playerRect.intersectsLine(line[0], line[1]);
  }

  // * Position && Velocity

  Offset get center => _getCenter();

  Offset _getCenter() {
    return (state.position + Offset(enemySize / 2, enemySize / 2));
  }

  double get velocity => _getVelocity();

  double _getVelocity() {
    return state.velocity;
  }

  // * Debugging

  void renderHitBox(Canvas c) {
    final rect = Rect.fromLTWH(
        state.position.dx, state.position.dy, enemySize, enemySize);
    c.drawRect(rect, Paint()..color = Colors.lightBlueAccent.withOpacity(0.3));
  }

  // * Stun

  int _stunFramesCount = 0;
  double _angleStun = 0;
  double _stunDistance = 10;

  void _stun(Canvas c) {
    // TODO: fix amount of damage
    state = state.copyWith(health: state.health - 5);
    c.save();
    c.drawCircle(
        state.position + Offset(enemySize / 2, enemySize / 2),
        enemySize,
        Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * pi);
    c.restore();
    _stunFramesCount++;
    if (_stunFramesCount < 10) {
      state = state.copyWith(
          velocity: state.velocity.clamp(0, 2),
          position: state.position +
              Offset(_stunDistance * sin(_angleStun),
                  _stunDistance * cos(_angleStun)));
    } else {
      state = state.copyWith(velocity: state.velocity.clamp(0, 2));
    }
    if (_stunFramesCount == 60) {
      _stunFramesCount = 0;
      _mS = MovementStates.Moving;
    }
  }

  // * Death animation

  Explosion? _e;

  void _destroy(Canvas c) {
    if (_e == null) {
      _e = Explosion(
        isSquare: true,
        origin: center,
        color: Colors.greenAccent,
        sizeParticles: 5,
        amountParticles: 100,
        velocityParticles: 40,
      );
    }
    _e!.renderExplosion(c);
    if (_e!.isFinished) _gameOver = true;
  }
}

final enemyFSMProvider = StateNotifierProvider<EnemyControllerFSM, Enemy>(
    (ref) => EnemyControllerFSM(Enemy(), read: ref.read));
