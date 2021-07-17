import 'dart:math';
import 'dart:ui';

extension OffsetExtension on Offset{
  Offset clamp(Offset min, Offset max){
   return Offset(dx.clamp(min.dx, max.dx), dy.clamp(min.dy, max.dy));
  }

  Offset clampFromCenter(Offset min, Offset max){
    return Offset(dx.clamp(min.dx, max.dx), dy.clamp(min.dy, max.dy));
  }

  Offset rotateWithPivot(Offset pivot, double radians){
    final p = pivot.dx;
    final q = pivot.dy;
    return Offset(
        (dx*cos(radians) - dy*sin(radians) + p),
        (dx*sin(radians) + dy*cos(radians) + q)
    );
  }

  double angleTo(Offset point){
    final x = dx - point.dx;
    final y = dy - point.dy;
    final double a = (-atan2(y, x) + 3*pi/2);
    return a;
  }

  double angleToDeg(Offset point){
    final x = dx - point.dx;
    final y = dy - point.dy;
    final double a = (-atan2(y, x) + 3*pi/2);
    return a*180/pi;
  }

}