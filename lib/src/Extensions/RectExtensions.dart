
import 'dart:ui';

extension RectExtensions on Rect{

  bool outsideRegion(Rect region){
    final List<Offset> points = [region.topLeft, region.topRight, region.bottomRight, region.bottomLeft];
    // * ===============> topRight
    if(this.topRight.dx < points[0].dx) return true;
    if(this.topRight.dy < points[0].dy) return true;
    if(this.topRight.dx > points[1].dx) return true;
    if(this.topRight.dy < points[1].dy) return true;
    if(this.topRight.dx > points[2].dx) return true;
    if(this.topRight.dy > points[2].dy) return true;
    if(this.topRight.dx < points[3].dx) return true;
    if(this.topRight.dy > points[3].dy) return true;
    // * ===============> bottomRight
    if(this.bottomRight.dx < points[0].dx) return true;
    if(this.bottomRight.dy < points[0].dy) return true;
    if(this.bottomRight.dx > points[1].dx) return true;
    if(this.bottomRight.dy < points[1].dy) return true;
    if(this.bottomRight.dx > points[2].dx) return true;
    if(this.bottomRight.dy > points[2].dy) return true;
    if(this.bottomRight.dx < points[3].dx) return true;
    if(this.bottomRight.dy > points[3].dy) return true;
    // * ===============> topLeft
    if(this.topLeft.dx < points[0].dx) return true;
    if(this.topLeft.dy < points[0].dy) return true;
    if(this.topLeft.dx > points[1].dx) return true;
    if(this.topLeft.dy < points[1].dy) return true;
    if(this.topLeft.dx > points[2].dx) return true;
    if(this.topLeft.dy > points[2].dy) return true;
    if(this.topLeft.dx < points[3].dx) return true;
    if(this.topLeft.dy > points[3].dy) return true;
    // * ===============> bottomLeft
    if(this.bottomLeft.dx < points[0].dx) return true;
    if(this.bottomLeft.dy < points[0].dy) return true;
    if(this.bottomLeft.dx > points[1].dx) return true;
    if(this.bottomLeft.dy < points[1].dy) return true;
    if(this.bottomLeft.dx > points[2].dx) return true;
    if(this.bottomLeft.dy > points[2].dy) return true;
    if(this.bottomLeft.dx < points[3].dx) return true;
    if(this.bottomLeft.dy > points[3].dy) return true;

    return false;
  }

}