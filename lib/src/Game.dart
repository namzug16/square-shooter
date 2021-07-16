import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:funvas/funvas.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/KControls/KControls.dart';
import 'package:square_shooter/src/Player/PlayerController.dart';

class Game extends HookWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerController = useProvider(playerProvider.notifier);

    return Container(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FunvasContainer(
              funvas: GamePainterFunvas(
                playerController: playerController,
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

  GamePainterFunvas({
    required this.playerController,
  });

  @override
  void u(double t) {
    c.drawPaint(Paint()..color = Colors.black87);
    playerController.renderPlayer(c, x);
  }
}
