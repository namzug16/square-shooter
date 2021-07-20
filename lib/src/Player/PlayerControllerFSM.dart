import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Bullets/Bullets.dart';
import 'package:square_shooter/src/Bullets/LaserBeam.dart';
import 'package:square_shooter/src/Enemies/EnemyControllerFSM.dart';
import 'package:square_shooter/src/Explosions/Explosion.dart';
import 'package:square_shooter/src/Player/Player.dart';
import 'package:square_shooter/src/States/States.dart';

import '../Extensions/OffsetExtension.dart';
import '../Extensions/RectExtensions.dart';

class PlayerControllerFSM extends StateNotifier<Player> {
  PlayerControllerFSM(this.read) : super(Player());

  final Reader read;

  late EnemyControllerFSM _enemy;

  bool get gameOver => _gameOver;
  bool _gameOver = false;

  MovementStates get mS => _mS;
  MovementStates _mS = MovementStates.Moving;

  AttackStates get aS => _aS;
  AttackStates _aS = AttackStates.None;

  bool get isAlive => _lS == LiveStates.Alive;
  LiveStates _lS = LiveStates.Alive;

  static const double playerSize = 50;
  static const int maxVelocity = 15;
  static const int maxVelocityShooting = 5;
  static const double acceleration = 0.3;
  static const double rotationValue = pi / 40;
  static const double aimSizeStart = playerSize + 20;
  static const double aimSize = 100;

  // ? ========================================================= Methods

  void init() {
    _enemy = read(enemyFSMProvider.notifier);
  }

  // ! =====================================> RenderObjects
  void renderPlayer(Canvas c, x) {
    _stateLogic(c, x);

    Rect rect = Rect.fromLTWH(
        state.position.dx, state.position.dy, playerSize, playerSize);

    // ? ==========================> Player
    if (_lS == LiveStates.Alive) {
      c.save();
      c.translate(rect.center.dx, rect.center.dy);
      c.rotate(state.rotation);
      c.drawRect(Offset(-playerSize / 2, -playerSize / 2) & rect.size,
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
    if (_enemy.bullets.length > 0) {
      final enemyBullets = _enemy.bullets;
      for (var b in enemyBullets) {
        // * =======> In case bullets collide with other bullets
        for (var pb in bullets) {
          if (b.canDamage &&
              pb.canDamage &&
              pb.getRect().collides(b.getRect())) {
            pb.destroy();
            b.destroy();
          }
        }

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
          _shoot();
        } else if (_aS == AttackStates.LaserBeam) {
          state = state.copyWith(velocity: 0, color: state.attackColor);
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
      if (oldState == AttackStates.None) {
        _aS = newState;
      } else {
        if (oldState != AttackStates.None &&
            newState != AttackStates.None &&
            newState != oldState) {
          print("Invalid Change of States");
          print(oldState);
          print(newState);
          // we need to save the state
          savedAttackState = oldState;
        } else {
          if (savedAttackState != null) {
            _aS = savedAttackState!;
            savedAttackState = null;
          } else {
            _aS = newState;
          }
        }
      }
    } else if (newState.runtimeType == LiveStates) {
      _lS = newState;
    }
  }

  // ! ===============================================================> Actions

  Offset _oldDirection = Offset.zero;
  Offset _direction = Offset.zero;
  bool _overrideDirection = false;

  // * KInput
  void kInput(RawKeyEvent data) {
    if (data.logicalKey.keyLabel == "k") {
      if (data.runtimeType.toString() == "RawKeyDownEvent") {
        _setState(_aS, AttackStates.Shooting);
      } else {
        _setState(_aS, AttackStates.None);
      }
    } else if (data.logicalKey.keyLabel == "l") {
      if (data.runtimeType.toString() == "RawKeyDownEvent") {
        _setState(_aS, AttackStates.LaserBeam);
      } else {
        _setState(_aS, AttackStates.None);
      }
    } else {
      _setDirection(data);
    }
  }

  // * Movement

  void _setDirection(RawKeyEvent data) {
    if (data.runtimeType.toString() == "RawKeyDownEvent") {
      switch (data.character) {
        case "a":
          if (state.direction.dx == 0) {
            _direction = Offset(-1, state.direction.dy);
          } else if (state.direction.dx == 1) {
            _direction = Offset(0, state.direction.dy);
            _overrideDirection = true;
          }
          break;
        case "w":
          if (state.direction.dy == 0) {
            _direction = Offset(state.direction.dx, -1);
          } else if (state.direction.dy == 1) {
            _direction = Offset(state.direction.dx, 0);
            _overrideDirection = true;
          }
          break;
        case "d":
          if (state.direction.dx == 0) {
            _direction = Offset(1, state.direction.dy);
          } else if (state.direction.dx == -1) {
            _direction = Offset(0, state.direction.dy);
            _overrideDirection = true;
          }
          break;
        case "s":
          if (state.direction.dy == 0) {
            _direction = Offset(state.direction.dx, 1);
          } else if (state.direction.dy == -1) {
            _direction = Offset(state.direction.dx, 0);
            _overrideDirection = true;
          }
          break;
      }
    } else {
      switch (data.logicalKey.keyLabel) {
        case "a":
          if (_overrideDirection) {
            _direction = Offset(1, state.direction.dy);
            _overrideDirection = false;
          } else {
            _direction = Offset(0, state.direction.dy);
          }
          break;
        case "w":
          if (_overrideDirection) {
            _direction = Offset(state.direction.dx, 1);
            _overrideDirection = false;
          } else {
            _direction = Offset(state.direction.dx, 0);
          }
          break;
        case "d":
          if (_overrideDirection) {
            _direction = Offset(-1, state.direction.dy);
            _overrideDirection = false;
          } else {
            _direction = Offset(0, state.direction.dy);
          }
          break;
        case "s":
          if (_overrideDirection) {
            _direction = Offset(state.direction.dx, -1);
            _overrideDirection = false;
          } else {
            _direction = Offset(state.direction.dx, 0);
          }
          break;
      }
    }

    if (_direction != Offset.zero) _oldDirection = _direction;
    state = state.copyWith(direction: _direction);
  }

  void _move(x) {
    if (state.direction == Offset.zero) {
      if (state.velocity > 0) {
        state = state.copyWith(
          velocity:
              (state.velocity - acceleration).clamp(0, maxVelocity).toDouble(),
          position: (state.position +
                  Offset(state.velocity * _oldDirection.dx,
                      state.velocity * _oldDirection.dy))
              .clamp(Offset.zero,
                  Offset(x.width - playerSize, x.height - playerSize)),
        );
      }
    } else {
      state = state.copyWith(
        velocity:
            (state.velocity + acceleration).clamp(0, maxVelocity).toDouble(),
        position: (state.position +
                Offset(state.velocity * state.direction.dx,
                    state.velocity * state.direction.dy))
            .clamp(Offset.zero,
                Offset(x.width - playerSize, x.height - playerSize)),
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
    _aim = _enemy.center;
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
                  state.position.dx, state.position.dy, playerSize, playerSize)
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
          factor: 0.2,
          color: state.color,
          direction: _aimAngle,
          origin: state.position + Offset(playerSize / 2, playerSize / 2));
    }
  }

  void _cancelLaserBeam() {
    _laserBeam = null;
  }

  // * Position && Velocity

  Offset get center => _getCenter();

  Offset _getCenter() {
    return (state.position + Offset(playerSize / 2, playerSize / 2));
  }

  double get velocity => _getVelocity();

  double _getVelocity() {
    return state.velocity;
  }

  Rect get rect => _getRect();
  Rect _getRect(){
    return Rect.fromLTWH(state.position.dx, state.position.dy, playerSize, playerSize);
  }

  // * Debugging

  void renderHitBox(Canvas c) {
    final rect = Rect.fromLTWH(
        state.position.dx, state.position.dy, playerSize, playerSize);
    c.drawRect(rect, Paint()..color = Colors.lightBlueAccent.withOpacity(0.3));
  }

  // * Stun

  int _stunFramesCount = 0;
  double _angleStun = 0;
  // double _stunDistance = 10;
  double _stunDistance = 0;

  void _stun(Canvas c) {
    // TODO: fix amount of damage
    // state = state.copyWith(health: state.health - 5);
    c.save();
    c.drawCircle(
        state.position + Offset(playerSize / 2, playerSize / 2),
        playerSize,
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

final playerFSMProvider = StateNotifierProvider<PlayerControllerFSM, Player>(
    (ref) => PlayerControllerFSM(ref.read));
