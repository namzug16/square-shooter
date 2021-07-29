import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'Player.freezed.dart';

@freezed
class Player with _$Player {
  factory Player({@Default(Offset(300, 300)) Offset position,
                  @Default(Offset.zero) Offset direction,
                  @Default(0) double velocity,
                  @Default(0) double rotation,
                  @Default(Colors.white) Color color,
                  @Default(Colors.white) Color initialColor,
                  @Default(Colors.greenAccent) Color attackColor,}) = _Player;

}