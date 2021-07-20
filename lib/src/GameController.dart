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

    _player.renderPlayer(c, x);
    _enemy.renderEnemy(c, x);
    // // * =================> Shakes
    //
    // if (_playerController.isHurt || _enemyController.isHurt) {
    //   c.translate(_hurtValues[Random().nextInt(_hurtValues.length)],
    //       _hurtValues[Random().nextInt(_hurtValues.length)]);
    // }
    //
    // if ( (_playerController.laserBeam != null && _playerController.laserBeam!.isFinished)
    // || (_enemyController.laserBeam != null && _enemyController.laserBeam!.isFinished)){
    //   c.translate(_hurtValues[Random().nextInt(_hurtValues.length)],
    //       _hurtValues[Random().nextInt(_hurtValues.length)]);
    // }
    //
    // if ((!_playerController.isAlive() || !_enemyController.isAlive()) &&
    //     _deathShakes < 20) {
    //   c.translate(_deathValues[Random().nextInt(_deathValues.length)],
    //       _deathValues[Random().nextInt(_deathValues.length)]);
    //   _deathShakes++;
    // }

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
