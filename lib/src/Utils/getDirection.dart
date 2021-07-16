import 'dart:math';
import 'dart:ui';
import 'package:vector_math/vector_math.dart';

double getDirection(Offset center, Offset endPoint){
  final x = (center.dx - endPoint.dx);
  final y = (center.dy - endPoint.dy);
  final angle = atan2(x, y);
  return (angle*radians2Degrees);
}