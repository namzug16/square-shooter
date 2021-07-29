import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FunvasContainer(
        funvas: BackgroundFunvas(),
      ),
    );
  }
}

class BackgroundFunvas extends Funvas {

  final double size = 500;

  @override
  void u(double t) {
    final center = Offset(x.width/2, x.height/2);
    c.save();
    c.translate(center.dx, center.dy);
    c.rotate(t);
    c.drawRect(Rect.fromLTWH(-size/2, -size/2, size, size), Paint()..color=Colors.white70);
    c.restore();
    c.save();
    c.translate(center.dx, center.dy);
    c.rotate(t*0.8);
    c.drawRect(Rect.fromLTWH(-size/2, -size/2, size, size), Paint()..color=Colors.white70);
    c.restore();
    c.save();
    c.translate(center.dx, center.dy);
    c.rotate(t*0.6);
    c.drawRect(Rect.fromLTWH(-size/2, -size/2, size, size), Paint()..color=Colors.white70);
    c.restore();
    c.save();
    c.translate(center.dx, center.dy);
    c.rotate(t*0.4);
    c.drawRect(Rect.fromLTWH(-size/2, -size/2, size, size), Paint()..color=Colors.white70);
    c.restore();
    c.save();
    c.translate(center.dx, center.dy);
    c.rotate(t*0.2);
    c.drawRect(Rect.fromLTWH(-size/2, -size/2, size, size), Paint()..color=Colors.white70);
    c.restore();
  }
}
