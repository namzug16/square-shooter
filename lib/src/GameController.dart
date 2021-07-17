import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Enemies/EnemyController.dart';
import 'package:square_shooter/src/Player/PlayerController.dart';

class GameController extends StateNotifier<bool>{
  GameController(this.read): super(false);

  final Reader read;

  late final PlayerController _playerController;
  late final EnemyController _enemyController;

  void init(){
    _getPlayer();
    _getEnemy();
    state = !state;
  }

  void renderGame(Canvas c, x){
    _playerController.renderPlayer(c, x);
    _enemyController.renderEnemy(c, x);
  }

  void _getPlayer(){
    _playerController = read(playerProvider.notifier);
  }

  void _getEnemy(){
    _enemyController = read(enemyProvider.notifier);
  }

}

final gameProvider = StateNotifierProvider<GameController, bool>((ref) => GameController(ref.read));