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
import '../Extensions/DoubleExtensions.dart';

class EnemyControllerFSM extends StateNotifier<Enemy> {
  EnemyControllerFSM(Enemy state, {required this.read}) : super(state);

  final Reader read;

  PlayerControllerFSM? _player;

  bool get gameOver => _gameOver;
  bool _gameOver = false;

  bool get isHurt => _isHurt;
  bool _isHurt = false;

  MovementStates get mS => _mS;
  MovementStates _mS = MovementStates.Moving;

  AttackStates get aS => _aS;
  AttackStates _aS = AttackStates.None;

  bool get isAlive => _lS == LiveStates.Alive;
  LiveStates _lS = LiveStates.Alive;

  static const double enemySize = 50;
  static const int maxVelocity = 15;
  static const int maxVelocityShooting = 5;
  static const double acceleration = 0.5;
  static const double maxDistanceToMove = 435;
  static const double rotationValue = pi / 40;
  static const double aimSizeStart = enemySize + 20;
  static const double aimSize = 100;

  // ? ========================================================= Methods

  void init(Size size) {
    if(_player == null){
      _player = read(playerFSMProvider.notifier);
    }
    state = state.copyWith(
        position: Offset(size.width / 2 - enemySize / 2, enemySize));
  }

  void restart(Size size){
    _gameHasStarted = false;
    _e = null;
    _mS = MovementStates.Moving;
    _aS = AttackStates.None;
    _lS = LiveStates.Alive;
    state = Enemy(
      position: Offset(size.width / 2 - enemySize / 2, enemySize)
    );
  }

  bool _gameHasStarted = false;

  void startGame() {
    _gameHasStarted = true;
  }

  // ! =====================================> RenderObjects
  void renderEnemy(Canvas c, x) {
    _pickAState();
    _detectLaserBeamEnemy();
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
    if (_aS == AttackStates.Shooting &&
        _mS != MovementStates.Stunned &&
        _lS == LiveStates.Alive &&
        _gameHasStarted) {
      c.save();
      final aimPaint = Paint()
        ..color = state.attackColor
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      final a = pi / 2 - _aimAngle;
      c.drawLine(center + Offset(aimSizeStart * sin(a), aimSizeStart * cos(a)),
          center + Offset(aimSize * sin(a), aimSize * cos(a)), aimPaint);
      c.drawLine(
        center +
            Offset(
                aimSizeStart * sin(a + pi / 7), aimSizeStart * cos(a + pi / 7)),
        center + Offset(aimSizeStart * sin(a), aimSizeStart * cos(a)),
        aimPaint,
      );
      c.drawLine(
        center +
            Offset(
                aimSizeStart * sin(a - pi / 7), aimSizeStart * cos(a - pi / 7)),
        center + Offset(aimSizeStart * sin(a), aimSizeStart * cos(a)),
        aimPaint,
      );
      c.restore();
    }

    // ? ===========================> Bullets
    if (_bullets.length > 0) {
      for (var b in _bullets) {
        b.renderBullet(c);
        if (b.canDamage &&
            b.rect.outsideRegion(Rect.fromLTWH(0, 0, x.width, x.height))) {
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
    if (_player!.bullets.length > 0) {
      final playerBullets = _player!.bullets;
      for (var b in playerBullets) {
        // * ======> Damage
        if (b.canDamage && b.rect.collides(rect)) {
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
      if (_gameHasStarted) {
        _getPossibleCollision();
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
        } else if (_mS == MovementStates.Escaping) {
          state = state.copyWith(color: state.initialColor);
          _cancelLaserBeam();
          if (_aS == AttackStates.Shooting) {
            state = state.copyWith(
                color: state.attackColor,
                velocity:
                    state.velocity.clamp(0, maxVelocityShooting).toDouble());
            _cancelLaserBeam();
            _shoot();
          }
          _move(x);
        } else if (_mS == MovementStates.Stunned) {
          state = state.copyWith(color: Colors.redAccent);
          // cancel attacks in case player was attacking when stunned
          _cancelLaserBeam();
          _cancelShooting();
          _stun(c);

          _move(x);
          state = state.copyWith(velocity: state.velocity.clamp(0, 2));
        }
      }
    } else {
      // cancel attacks in case player was attacking when died :c
      _cancelLaserBeam();
      _cancelShooting();
      _destroy(c);
    }
  }

  void _setState(oldState, newState) {
    if (newState.runtimeType == MovementStates) {
      if (oldState == MovementStates.Moving &&
          newState == MovementStates.Escaping) {
        state = state.copyWith(velocity: (maxVelocity).toDouble());
      } else if (oldState == MovementStates.Escaping &&
          newState == MovementStates.Moving) {
        state = state.copyWith(velocity: 0);
      }
      _mS = newState;
    } else if (newState.runtimeType == AttackStates) {
      _aS = newState;
    } else if (newState.runtimeType == LiveStates) {
      _lS = newState;
    }
  }

  int _frameCountForNewState = 100;
  bool _randBoolForNewState = true;

  void _setFrameCount() {
    _frameCountForNewState = Random().nextInt(80);
  }

  void _setBoolState() {
    _randBoolForNewState = Random().nextBool();
  }

  void _pickAState() {
    if (!_player!.isAlive) {
      _setState(_aS, AttackStates.None);
      return;
    }
    if (_player!.aS == AttackStates.LaserBeam && !_enemyInsideAim()) {
      _aS = AttackStates.LaserBeam;
      return;
    }
    if (state.position.distanceTo(_player!.center) > 200 &&
        _player!.aS != AttackStates.Shooting &&
        _player!.mS != MovementStates.Stunned) {
      if (_randBoolForNewState && _frameCountForNewState > 0) {
        _setState(_aS, AttackStates.Shooting);
      } else {
        _setState(_aS, AttackStates.None);
      }
      _frameCountForNewState--;
      if (_frameCountForNewState == 0) {
        _setFrameCount();
        _setBoolState();
      }
      return;
    }
    if (_player!.aS == AttackStates.Shooting &&
        state.position.distanceTo(_player!.center) > 100) {
      _setState(_aS, AttackStates.Shooting);
      return;
    }
    if (_aS == AttackStates.LaserBeam && !_playerInsideAim()) {
      _setState(_aS, AttackStates.None);
      return;
    }
    if (_player!.mS == MovementStates.Stunned) {
      if (state.position.distanceTo(_player!.center) > 150) {
        _setState(_aS, AttackStates.LaserBeam);
        return;
      }
      _setState(_aS, AttackStates.None);
      return;
    }
  }

  // ! ===============================================================> Actions

  // * Movement

  Offset? _position;
  double _distance = 0;
  double _angleMovement = 0;

  bool _scapeDir = true;
  final double _distanceEscape = 200;

  void _getNextPosition(x) {
    Offset pos = Offset(x.width / 2, x.height / 2);
    final padding = enemySize * 2;
    if (_mS == MovementStates.Escaping) {
      pos = Offset(
        (state.position.dx +
                _distanceEscape *
                    sin(pi / 2 - _aimAngle + (_scapeDir ? pi / 2 : -pi / 2)))
            .clamp(padding, x.width - padding)
            .toDouble(),
        (state.position.dy +
                _distanceEscape *
                    cos(pi / 2 - _aimAngle + (_scapeDir ? pi / 2 : -pi / 2)))
            .clamp(padding, x.height - padding)
            .toDouble(),
      );
    } else {
      pos = Offset(
          Random()
              .nextInt(x.width - padding)
              .clamp(padding, x.width - padding)
              .toDouble(),
          Random()
              .nextInt(x.height - padding)
              .clamp(padding, x.height - padding)
              .toDouble());
    }
    _isAccelerating = true;
    _distance = center.distanceTo(pos);
    // if(_distance < enemySize) _getNextPosition(x);
    _angleMovement = pi / 2 - center.angleTo(pos);
    _position = pos;
  }

  bool _isAccelerating = true;

  void _move(x) {
    if (_position == null ||
        _mS == MovementStates.Escaping ||
        state.velocity == 0) _getNextPosition(x);

    if (_distance > enemySize) {
      if ((state.position.distanceTo(_position!) <=
          (_distance < maxDistanceToMove
              ? (_distance / 2).ceilToDouble()
              : maxDistanceToMove / 2))) {
        _isAccelerating = false;
      }
      if (!_isAccelerating || _mS == MovementStates.Escaping) {
        state = state.copyWith(
          velocity:
              (state.velocity - acceleration).clamp(0, maxVelocity).toDouble(),
          position: (state.position +
                  Offset(state.velocity * sin(_angleMovement),
                      state.velocity * cos(_angleMovement)))
              .clamp(Offset.zero,
                  Offset(x.width - enemySize, x.height - enemySize)),
        );
      } else {
        state = state.copyWith(
          velocity:
              (state.velocity + acceleration).clamp(0, maxVelocity).toDouble(),
          position: (state.position +
                  Offset(state.velocity * sin(_angleMovement),
                      state.velocity * cos(_angleMovement)))
              .clamp(Offset.zero,
                  Offset(x.width - enemySize, x.height - enemySize)),
        );
      }
    } else {
      state = state.copyWith(velocity: 0);
    }
  }

  void _updateRotation() {
    state = state.copyWith(
        rotation: state.rotation +
            rotationValue +
            rotationValue * state.velocity / 5);
  }

  double _safeDistance = 150;
  double? _savedDirectionForRecognitionBullet;

  void _getPossibleCollision() {
    if (_mS != MovementStates.Stunned) {
      final Rect _safeArea =
          Rect.fromCircle(center: center, radius: _safeDistance);
      if (_player!.bullets.length > 0) {
        for (var b in _player!.bullets) {
          if (b.rect.collides(_safeArea)) {
            if (_savedDirectionForRecognitionBullet == null ||
                b.direction != _savedDirectionForRecognitionBullet) {
              _setState(_mS, MovementStates.Escaping);
              _savedDirectionForRecognitionBullet = b.direction;
              final a = (_aimAngle + pi).normalizeAngle();
              if (b.direction < a) {
                // it can still improve
                _scapeDir = true;
              } else {
                _scapeDir = false;
              }
            }
            return;
          }
        }
      }
      if (_mS == MovementStates.Escaping) {
        _setState(_mS, MovementStates.Moving);
      }
    }
  }

  // * Attacks && Aim
  Offset _aim = Offset.zero;
  double _aimAngle = 0;

  List<Bullet> get bullets => _bullets;
  List<Bullet> _bullets = [];

  LaserBeam? get laserBeam => _laserBeam;
  LaserBeam? _laserBeam;

  void _setAim() {
    _aim = _player!.center;
    _aimAngle = center.angleTo(_aim);
  }

  Timer? _t;

  void _shoot() {
    if (_t == null) {
      _t = Timer.periodic(Duration(milliseconds: 200), (timer) {
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
          direction: pi / 2 - _aimAngle,
          origin: state.position + Offset(enemySize / 2, enemySize / 2));
    }
  }

  void _cancelLaserBeam() {
    _laserBeam = null;
  }

  bool _playerInsideAim() {
    final playerRect = _player!.rect;
    if (laserBeam != null) {
      final line = laserBeam!.line;
      return playerRect.intersectsLine(line[0], line[1]);
    } else {
      return false;
    }
  }

  bool _enemyInsideAim() {
    if (_player!.aS == AttackStates.LaserBeam) {
      final rect = Rect.fromLTWH(
          state.position.dx, state.position.dy, enemySize, enemySize);
      if (_player!.laserBeam != null) {
        final line = _player!.laserBeam!.line;
        if (rect.intersectsLine(line[0], line[1])) {
          return true;
        }
      }
    }
    return false;
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

  void renderTrajectory(Canvas c) {
    if (_position != null) {
      c.save();
      c.drawLine(center, _position!, Paint()..color = Colors.pinkAccent);
      c.restore();
    }
  }

  void renderDogeAngles(Canvas c) {
    c.save();
    c.drawLine(
        center,
        center +
            Offset(_distanceEscape * sin(pi / 2 - _aimAngle + pi / 2),
                _distanceEscape * cos(pi / 2 - _aimAngle + pi / 2)),
        Paint()..color = Colors.blueAccent);
    c.restore();
    c.save();
    c.drawLine(
        center,
        center +
            Offset(_distanceEscape * sin(pi / 2 - _aimAngle - pi / 2),
                _distanceEscape * cos(pi / 2 - _aimAngle - pi / 2)),
        Paint()..color = Colors.redAccent);
    c.restore();
    c.save();
    c.drawLine(
        center,
        center +
            Offset(_distanceEscape * sin(pi / 2 - _aimAngle),
                _distanceEscape * cos(pi / 2 - _aimAngle)),
        Paint()..color = Colors.blueAccent);
    c.restore();
  }

  void renderSafeArea(Canvas c) {
    c.save();
    c.drawRect(Rect.fromCircle(center: center, radius: _safeDistance),
        Paint()..color = Colors.blueAccent.withOpacity(0.3));
    c.restore();
  }

  void renderStates(Canvas c) {
    final TextPainter mTP = TextPainter(
      text: TextSpan(
        text: _mS.toString(),
        style: TextStyle(color: Colors.pink, fontSize: 15),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final TextPainter aTP = TextPainter(
      text: TextSpan(
        text: _aS.toString(),
        style: TextStyle(color: Colors.pink, fontSize: 15),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    c.save();
    mTP.paint(c,
        Offset(state.position.dx, state.position.dy - mTP.height - aTP.height));
    aTP.paint(c, Offset(state.position.dx, state.position.dy - aTP.height));
    c.restore();
  }

  // * Stun

  int _stunFramesCount = 0;
  double _angleStun = 0;
  double _stunDistance = 5;

  void _stun(Canvas c) {
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
      _isHurt = true;
      state = state.copyWith(
          velocity: state.velocity.clamp(0, 2),
          position: state.position +
              Offset(_stunDistance * sin(_angleStun),
                  _stunDistance * cos(_angleStun)));
    } else {
      _isHurt = false;
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
        color: state.attackColor,
        sizeParticles: 5,
        amountParticles: 100,
        velocityParticles: 40,
      );
    }
    _e!.renderExplosion(c);
  }

  void _detectLaserBeamEnemy() {
    if (_player!.laserBeam != null) {
      if (_player!.aS == AttackStates.LaserBeam &&
          _player!.laserBeam!.isFinished) {
        final rect = Rect.fromLTWH(
            state.position.dx, state.position.dy, enemySize, enemySize);
        final line = _player!.laserBeam!.line;
        if (rect.intersectsLine(line[0], line[1])) {
          _lS = LiveStates.Dead;
        }
      }
    }
  }
}

final enemyFSMProvider = StateNotifierProvider<EnemyControllerFSM, Enemy>(
    (ref) => EnemyControllerFSM(Enemy(), read: ref.read));
