import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Bullets/Bullets.dart';

class BulletsController extends StateNotifier<Bullets> {
  BulletsController({
    required this.color,
    this.damage,
  }) : super(Bullets(
          direction: 1.5,
          color: color,
          damage: damage ?? 5,
        ));
  final Color color;
  final int? damage;


  static const Size bulletSize = Size(30, 5);
  static const double velocity = 20.0;

  void renderBullet(Canvas canvas){
    final rect = Rect.fromLTWH(0, 0, bulletSize.width, bulletSize.height);
   canvas.save();
   canvas.drawRect(rect, Paint()..color=color);
   canvas.restore();

  }
}
