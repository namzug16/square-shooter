
import 'dart:ui';
import 'package:square_shooter/src/Rect/Rect4.dart';

extension CanvasExtension on Canvas {

  void drawRect4(Rect4 rect4, Paint paint){
    final points = rect4.points;
    final path = Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..lineTo(points[3].dx, points[3].dy)
      ..lineTo(points[0].dx, points[0].dy);
    this.drawPath(path, paint);
  }

}