import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Enemies/EnemyController.dart';
import 'package:square_shooter/src/Player/PlayerController.dart';

class GameController extends StateNotifier<bool> {
  GameController(this.read) : super(false);

  final Reader read;

  late final PlayerController _playerController;
  late final EnemyController _enemyController;

  void init() {
    _getPlayer();
    _getEnemy();
    state = !state;
  }

  final List<double> _hurtValues = [-3, -2, -1, 1, 2, 3];
  final List<double> _deathValues = [-8, -7, -6, 6, 7, 8];
  int _deathShakes = 0;

  void renderGame(Canvas c, x) {
    if (_playerController.isHurt || _enemyController.isHurt) {
      c.translate(_hurtValues[Random().nextInt(_hurtValues.length)],
          _hurtValues[Random().nextInt(_hurtValues.length)]);
    }
    if ((!_playerController.isAlive() || !_enemyController.isAlive()) &&
        _deathShakes < 20) {
      c.translate(_deathValues[Random().nextInt(_deathValues.length)],
          _deathValues[Random().nextInt(_deathValues.length)]);
      _deathShakes++;
    }
    _playerController.renderPlayer(c, x);
    _enemyController.renderEnemy(c, x);
  }

  // * ===================================> Private
  void _getPlayer() {
    _playerController = read(playerProvider.notifier);
  }

  void _getEnemy() {
    _enemyController = read(enemyProvider.notifier);
  }
}

final gameProvider = StateNotifierProvider<GameController, bool>(
    (ref) => GameController(ref.read));
