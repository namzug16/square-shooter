import 'dart:math';
import 'dart:ui';

extension OffsetExtension on Offset{
  Offset clamp(Offset min, Offset max){
   return Offset(this.dx.clamp(min.dx, max.dx), this.dy.clamp(min.dy, max.dy));
  }

  Offset clampFromCenter(Offset min, Offset max){
    return Offset(this.dx.clamp(min.dx, max.dx), this.dy.clamp(min.dy, max.dy));
  }

  double angleTo(Offset point){
    final x = this.dx - point.dx;
    final y = this.dy - point.dy;
    return atan2(x, y)+pi;
  }

  double angleToDeg(Offset point){
    final x = this.dx - point.dx;
    final y = this.dy - point.dy;
    return atan2(x, y)*180/pi;
  }

}