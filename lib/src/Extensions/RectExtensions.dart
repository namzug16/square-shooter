import 'dart:ui';
import './OffsetExtension.dart';

extension RectExtensions on Rect{

  bool intersectsLine(Offset p1, Offset p2){
    final List<List<Offset>> sides = [
      [topLeft, topRight],
      [topRight, bottomRight],
      [bottomRight, bottomLeft],
      [bottomLeft, topLeft],
    ];
    for(var side in sides){
      final Offset? intersection =  side[0].lineIntersection(side[1], p1, p2);
      if(intersection != null) return true;
    }
    return false;
  }

  Rect scale(double scale){
    return Rect.fromCenter(center: center, width: width*scale, height: height*scale);
  }

  bool outsideRegion(Rect region){
    if(right >= region.right || left <= region.left){
      return true;
    }
    if(top <= region.top || bottom >= region.bottom){
      return true;
    }
    return false;
  }

  bool collides(Rect other){
    final Rect intersection = this.intersect(other);
    if(intersection.width > 0 && intersection.height > 0) return true;
    return false;
  }
}