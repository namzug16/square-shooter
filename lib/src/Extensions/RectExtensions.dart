
import 'dart:ui';

extension RectExtensions on Rect{

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

  bool overlaps(Rect other) {
    if (right <= other.left || other.right <= left)
      return false;
    if (bottom <= other.top || other.bottom <= top)
      return false;
    return true;
  }
}