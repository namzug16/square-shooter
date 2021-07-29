import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:funvas/funvas.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/GameController.dart';
import 'package:square_shooter/src/KControls/KControls.dart';

class Game extends HookWidget {
  const Game(this.parentContext, {Key? key}) : super(key: key);

  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {

    final gameController = useProvider(gameProvider.notifier);

    useEffect((){
      gameController.init(MediaQuery.of(parentContext).size, context);
    },[]);

    return Container(
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FunvasContainer(
                funvas: GamePainterFunvas(
                  gameController: gameController,
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
  final GameController gameController;

  GamePainterFunvas({
    required this.gameController,
  });

  @override
  void u(double t) {
    c.drawPaint(Paint()..color = Colors.black);
    gameController.renderGame(c, x);
  }
}
