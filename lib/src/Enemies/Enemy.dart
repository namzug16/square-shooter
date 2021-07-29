import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'Enemy.freezed.dart';

@freezed
class Enemy with _$Enemy {
  factory Enemy({
    @Default(Offset(100, 100)) Offset position,
    @Default(0) double velocity,
    @Default(0) double rotation,
    @Default(Colors.white) Color color,
    @Default(Colors.white) Color initialColor,
    @Default(Colors.blueAccent) Color attackColor,
  }) = _Enemy;
}
