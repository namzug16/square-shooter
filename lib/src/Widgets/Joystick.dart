import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:funvas/funvas.dart';

class Joystick extends HookWidget {
  final Function(Offset details) move;
  final VoidCallback stop;

  const Joystick({required this.move, required this.stop, Key? key})
      : super(key: key);

  static Size size = Size(100, 100);

  void updateMove(Offset delta) {
    final double x = delta.dx.clamp(-1, 1);
    final double y = delta.dy.clamp(-1, 1);
    move(Offset(x, y));
  }

  @override
  Widget build(BuildContext context) {
    // final dragDetails = useState<Offset>(Offset(100, 50));
    final dragDetails = useState<DragUpdateDetails>(
        DragUpdateDetails(globalPosition: Offset.zero));
    final isMoving = useState<bool>(false);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: GestureDetector(
        onTapDown: (details) {
          isMoving.value = true;
          dragDetails.value = details as DragUpdateDetails;
        },
        onPanStart: (details) {
          !isMoving.value ? isMoving.value = true : isMoving.value;
        },
        onPanUpdate: (DragUpdateDetails details) {
          dragDetails.value = details;
          updateMove(details.delta);
        },
        onPanEnd: (details) {
          isMoving.value = false;
          stop();
        },
        onTapUp: (details) {
          isMoving.value ? isMoving.value = false : isMoving.value;
          stop();
        },
        child: FunvasContainer(
          funvas: JoystickFunvas(
            d: dragDetails.value,
            isMoving: isMoving.value,
            move: move,
          ),
        ),
      ),
    );
  }
}

class JoystickFunvas extends Funvas {
  JoystickFunvas({
    required this.d,
    required this.isMoving,
    required this.move,
  });

  final Function(Offset details) move;
  final DragUpdateDetails d;
  final bool isMoving;

  @override
  void u(double t) {
    final clipRect = Rect.fromLTWH(0, 0, x.width, x.height);
    c.clipRRect(RRect.fromRectAndRadius(clipRect, Radius.circular(100)));
    c.drawPaint(Paint()..color = Colors.black87);

    final Offset center = Offset(x.width / 2, x.height / 2);
    late Offset position;

    if (isMoving) {
      position = Offset(d.localPosition.dx.clamp(0, x.width),
          d.localPosition.dy.clamp(0, x.height));

      final double dx = d.delta.dx.clamp(-1, 1);
      final double dy = d.delta.dy.clamp(-1, 1);
      move(Offset(dx, dy));
    } else {
      position = Offset(x.width / 2, x.height / 2);
      move(Offset.zero);
    }

    final linePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    c.drawLine(center, position, linePaint);
  }
}
