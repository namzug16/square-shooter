import 'dart:math';
import 'dart:ui';

extension OffsetExtension on Offset{

  double distanceTo(Offset other){
    final x = (dx - other.dx);
    final y = (dy - other.dy);
    return sqrt(pow(x, 2) + pow(y, 2));
  }

  Offset? lineIntersection(Offset l1p2, Offset l2p1, Offset l2p2){
   final numerator = (dx - l1p2.dx)*(l2p1.dy - l2p2.dy) - (dy - l1p2.dy)*(l2p1.dx - l2p2.dx);

   final dT = (dx - l2p1.dx)*(l2p1.dy - l2p2.dy) - (dy - l2p1.dy)*(l2p1.dx - l2p2.dx);

   if(numerator > 0 && dT < 0) return null;
   if(numerator < 0 && dT > 0) return null;

   final t = dT / numerator;

   if(t < 0 || t > 1) return null;

   final dU = (l1p2.dx - dx)*(dy - l2p1.dy) - (l1p2.dy - dy)*(dx - l2p1.dx);

   if(numerator > 0 && dU < 0) return null;
   if(numerator < 0 && dU > 0) return null;

   final u = dU / numerator;

   if(u < 0 || u > 1) return null;

   final p1 = dx + t*(l1p2.dx - dx);
   final p2 = dy + t*(l1p2.dy - dy);

   return Offset(p1, p2);
  }

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

  double angleTo(Offset other){
    final p1 = Offset(dx + 100, dy);
    final angle1 = atan2(p1.dy - dy, p1.dx - dx);
    final angle2 = atan2(other.dy - dy, other.dx - dx);
    final angle = angle1 - angle2;
    if(angle < 0){
      return -angle;
    }else{
      return -angle+2*pi;
    }
    // final x = dx - other.dx;
    // final y = dy - other.dy;
    // final double a = (-atan2(y, x) + 3*pi/2);
    // return a;
  }

}