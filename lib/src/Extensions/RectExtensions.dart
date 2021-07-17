
import 'dart:ui';

extension RectExtensions on Rect{

  Rect scale(double scale){
    return Rect.fromCenter(center: center, width: width*scale, height: height*scale);
  }

  bool outsideRegion1(Rect region){
    final List<Offset> points = [region.topLeft, region.topRight, region.bottomRight, region.bottomLeft];
    // * ===============> topRight
    if(topRight.dy < points[0].dy) return true;
    if(topRight.dx < points[0].dx) return true;
    if(topRight.dx > points[1].dx) return true;
    if(topRight.dy < points[1].dy) return true;
    if(topRight.dx > points[2].dx) return true;
    if(topRight.dy > points[2].dy) return true;
    if(topRight.dx < points[3].dx) return true;
    if(topRight.dy > points[3].dy) return true;
    // * ===============> bottomRight
    if(bottomRight.dx < points[0].dx) return true;
    if(bottomRight.dy < points[0].dy) return true;
    if(bottomRight.dx > points[1].dx) return true;
    if(bottomRight.dy < points[1].dy) return true;
    if(bottomRight.dx > points[2].dx) return true;
    if(bottomRight.dy > points[2].dy) return true;
    if(bottomRight.dx < points[3].dx) return true;
    if(bottomRight.dy > points[3].dy) return true;
    // * ===============> topLeft
    if(topLeft.dx < points[0].dx) return true;
    if(topLeft.dy < points[0].dy) return true;
    if(topLeft.dx > points[1].dx) return true;
    if(topLeft.dy < points[1].dy) return true;
    if(topLeft.dx > points[2].dx) return true;
    if(topLeft.dy > points[2].dy) return true;
    if(topLeft.dx < points[3].dx) return true;
    if(topLeft.dy > points[3].dy) return true;
    // * ===============> bottomLeft
    if(bottomLeft.dx < points[0].dx) return true;
    if(bottomLeft.dy < points[0].dy) return true;
    if(bottomLeft.dx > points[1].dx) return true;
    if(bottomLeft.dy < points[1].dy) return true;
    if(bottomLeft.dx > points[2].dx) return true;
    if(bottomLeft.dy > points[2].dy) return true;
    if(bottomLeft.dx < points[3].dx) return true;
    if(bottomLeft.dy > points[3].dy) return true;

    return false;
  }


  bool outsideRegion(Rect region){
    if(right >= region.right || right <= region.left || left <= region.left || left >= region.right){
      return true;
    }
    if(top <= region.top || bottom >= region.bottom){
      return true;
    }
    return false;
  }

  bool overlaps(Rect other) {
    if (right <= other.left || other.right <= left)
      return false;
    if (bottom <= other.top || other.bottom <= top)
      return false;
    return true;
  }
}