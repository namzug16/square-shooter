import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Enemies/EnemyControllerFSM.dart';
import 'package:square_shooter/src/Player/PlayerControllerFSM.dart';
import 'package:square_shooter/src/Widgets/Charge.dart';

import '../src/Extensions/CanvasExtensions.dart';

class GameController extends StateNotifier<bool> {
  GameController(this.read) : super(true);

  final Reader read;

  late final PlayerControllerFSM _player;
  late final EnemyControllerFSM _enemy;
  BuildContext? _context;

  bool get gameHasBeenInitialized => _gameHasBeenInitialized;
  bool _gameHasBeenInitialized = false;

  void init(Size size, BuildContext context) {
    state = true;
    if (!_gameHasBeenInitialized) {
      _gameHasBeenInitialized = !_gameHasBeenInitialized;
      _getEnemy();
      _getPlayer();
      _player.init(size);
      _enemy.init(size);
    }
    _context = context;
  }

  void restart(Size size) {
    _enemy.restart(size);
    _player.restart(size);
    _deathShakes = 0;
    _charge = null;
    _count = 0;
    _shouldCount = true;
    _shouldStartGame = false;
    _context = null;
    _goTSize = 0;
    state = false;
  }

  void _closeGame() {
    Navigator.of(_context!).maybePop();
  }

  final List<double> _hurtValues = [-3, -2, -1, 1, 2, 3];
  final List<double> _deathValues = [-8, -7, -6, 6, 7, 8];
  int _deathShakes = 0;

  bool _shouldStartGame = false;

  void renderGame(Canvas c, x) {
    if (_shouldCount) {
      _startCountDown(c, x);
    } else {
      if (!_shouldStartGame) {
        _shouldStartGame = true;
        _startGame();
      }
    }

    // * ================================> Shakes
    if (_player.isHurt || _enemy.isHurt) {
      c.translate(_hurtValues[Random().nextInt(_hurtValues.length)],
          _hurtValues[Random().nextInt(_hurtValues.length)]);
    }

    if ((!_player.isAlive || !_enemy.isAlive) && _deathShakes < 61) {
      c.translate(_deathValues[Random().nextInt(_deathValues.length)],
          _deathValues[Random().nextInt(_deathValues.length)]);
      _deathShakes++;
    }

    _player.renderPlayer(c, x);
    _enemy.renderEnemy(c, x);
    // _enemy.renderTrajectory(c);

    // * == Game Over
    if (!_player.isAlive && _deathShakes > 60) {
      _gameOver(false, c, x);
    } else if (!_enemy.isAlive && _deathShakes > 60) {
      _gameOver(true, c, x);
    }

    if (!state) c.drawPaint(Paint()..color = Colors.black);
  }

  // * ===================================> Private

  void _startGame() {
    _player.startGame();
    _enemy.startGame();
  }

  final List<String> _numbers = ["1", "2", "3"];
  final TextStyle _style = TextStyle(color: Colors.white, fontSize: 100);
  Charge? _charge;
  int _count = 0;
  bool _shouldCount = true;

  void _startCountDown(Canvas c, x) {
    if (_charge == null) {
      _charge = Charge(
          radius: 200,
          origin: Offset(x.width / 2, x.height / 2),
          color: Colors.white,
          rotation: pi);
    }
    if (_charge!.isFinished && _count < 2) {
      _count++;
      _charge!.restart();
    } else if (_charge!.isFinished && _count == 2) {
      _shouldCount = false;
    }
    c.save();
    _charge!.renderCharge(c);
    c.drawCenteredText(_numbers[_count], _style, Size(x.width, x.height));
    c.restore();
  }

  double _goTSize = 0;
  final int _maxSizeText = 200;
  void _gameOver(bool isWinner, Canvas c, x) {
    final style = TextStyle(
        color: Colors.white, fontSize: _goTSize, fontWeight: FontWeight.w900);
    if (_goTSize < _maxSizeText+1) {
      _goTSize++;
      if (_goTSize == _maxSizeText+1) {
        _closeGame();
        restart(Size(x.width, x.height));
      }
    }
    c.save();
    c.drawCenteredText(
        isWinner ? "You Win" : "You lose", style, Size(x.width, x.height));
    c.restore();
  }

  void _getPlayer() {
    _player = read(playerFSMProvider.notifier);
  }

  void _getEnemy() {
    _enemy = read(enemyFSMProvider.notifier);
  }
}

final gameProvider = StateNotifierProvider<GameController, bool>(
    (ref) => GameController(ref.read));
