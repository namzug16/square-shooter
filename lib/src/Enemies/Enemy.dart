import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'Enemy.freezed.dart';

@freezed
class Enemy with _$Enemy {
  factory Enemy({
    @Default(Offset(600, 300)) Offset? position,
    @Default(Offset(-1, 0)) Offset? direction,
    @Default(0) double? velocity,
    @Default(0) double? rotation,
    @Default(100) int? health,
    @Default(Colors.black) Color? color,
  }) = _Enemy;
}
