import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Enemies/EnemyControllerFSM.dart';
import 'package:square_shooter/src/Player/PlayerControllerFSM.dart';

class GameController extends StateNotifier<bool> {
  GameController(this.read) : super(false);

  final Reader read;

  late final PlayerControllerFSM _player;
  late final EnemyControllerFSM _enemy;

  void init() {
    _getEnemy();
    _getPlayer();
    _player.init();
    _enemy.init();
    state = !state;
  }

  final List<double> _hurtValues = [-3, -2, -1, 1, 2, 3];
  final List<double> _deathValues = [-8, -7, -6, 6, 7, 8];
  int _deathShakes = 0;

  void renderGame(Canvas c, x) {
    // * ================================> Shakes
    if (_player.isHurt || _enemy.isHurt) {
      c.translate(_hurtValues[Random().nextInt(_hurtValues.length)],
          _hurtValues[Random().nextInt(_hurtValues.length)]);
    }

    if((!_player.isAlive || !_enemy.isAlive) && _deathShakes < 61){
      c.translate(_deathValues[Random().nextInt(_deathValues.length)],
          _deathValues[Random().nextInt(_deathValues.length)]);
      _deathShakes++;
    }

    _player.renderPlayer(c, x);
    // _player.renderAngleFinding(c, x);
    _enemy.renderEnemy(c, x);
    // _enemy.renderStates(c);
    // _enemy.renderTrajectory(c);
    // _enemy.renderDogeAngles(c);
    // _enemy.renderSafeArea(c);
  }

  // * ===================================> Private
  void _getPlayer() {
    _player = read(playerFSMProvider.notifier);
  }

  void _getEnemy() {
    _enemy = read(enemyFSMProvider.notifier);
  }
}

final gameProvider = StateNotifierProvider<GameController, bool>(
    (ref) => GameController(ref.read));
