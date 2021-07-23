
import 'dart:math';

extension DoubleExtensions on double{

  double normalizeAngle(){
    double? factor;
    if(this > 2*pi){
      final div = this/2*pi;
      factor = div - div.floor();
    }
    if(factor == null){
      return this;
    }
    return factor*pi*2;
  }

}