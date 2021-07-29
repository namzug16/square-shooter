

import 'dart:ui';

import 'package:flutter/material.dart';

extension CanvasExtensions on Canvas{

  void drawCenteredText(String text, TextStyle style, Size canvasSize, [double? maxWidth]){
    final center = Offset(canvasSize.width/2, canvasSize.height/2);
    final TextPainter tp = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: style,
      )
    )..layout(maxWidth: maxWidth ?? double.infinity);
    final offset = center - Offset(tp.width/2, tp.height/2);
    tp.paint(this, offset);
  }

}