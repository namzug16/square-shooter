import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:funvas/funvas.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Enemies/EnemyController.dart';
import 'package:square_shooter/src/KControls/KControls.dart';
import 'package:square_shooter/src/Player/PlayerController.dart';
import 'package:square_shooter/src/Rect/Rect4.dart';
import '../src/Extensions/CanvasExtensions.dart';

class Game extends HookWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerController = useProvider(playerProvider.notifier);
    final enemyController = useProvider(enemyProvider.notifier);
    return Container(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FunvasContainer(
              funvas: GamePainterFunvas(
                playerController: playerController,
                enemyController: enemyController,
              ),
            ),
          ),
          KControls(),
        ],
      ),
    );
  }
}

class GamePainterFunvas extends Funvas {
  final PlayerController playerController;
  final EnemyController enemyController;

  GamePainterFunvas({
    required this.playerController,
    required this.enemyController,
  });

  double l = 250;
  double t = 300;
  double w = 300;
  double h = 50;
  double m = 0;
  double angle = 0.5;

  Offset _getCenter() {
    return Offset(m + l - w / 2, t - h / 2,);
  }

  Offset _getRotatedCenterWithPivot(Offset point , Offset pivot, double rotation){
    final x = point.dx;
    final y = point.dy;
    final p = pivot.dx;
    final q = pivot.dy;
    return Offset(
        ((x)*C(rotation) - (y)*S(rotation) + p),
        ((x)*S(rotation) + (y)*C(rotation) + q));
  }

  void initial() {
    final center = _getCenter();
    c.save();
    c.drawCircle( center, 15, Paint()..color = Colors.white);
    c.restore();
    final newCenter = _getRotatedCenterWithPivot(Offset(m , 0), Offset(center.dx - m, center.dy), angle);
    c.save();
    c.drawRect(Rect.fromCircle(center: newCenter, radius: 15), Paint()..color = Colors.amberAccent);
    c.restore();
    c.save();
    c.translate(center.dx - m, center.dy);
    c.rotate(angle);
    c.drawCircle( Offset(m , 0), 15, Paint()..color = Colors.white);
    c.restore();
  }

  @override
  void u(double t) {
    c.drawPaint(Paint()..color = Colors.black87);
    // m += 5;
    // initial();
    playerController.renderPlayer(c, x);
    // enemyController.renderEnemy(c, x);
  }
}
