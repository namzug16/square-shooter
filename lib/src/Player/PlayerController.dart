import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Bullets/Bullets.dart';
import 'package:square_shooter/src/Player/Player.dart';
import '../Extensions/OffsetExtension.dart';
import '../Extensions/RectExtensions.dart';

class PlayerController extends StateNotifier<Player> {
  PlayerController() : super(Player());

  static const double playerSize = 50;
  static const int maxVelocity = 15;
  static const double acceleration = 0.3;
  static const double aimSize = 200;

  Offset aim = Offset.zero;
  double aimAngle = 0;
  List<SimpleBullet> bullets = [];

  void renderPlayer(Canvas c, x) {
    final center = (state.position! + Offset(playerSize / 2, playerSize / 2));
    final angle = center.angleTo(aim);
    aimAngle = angle;

    _move(x);
    final rect = Rect.fromLTWH(
        state.position!.dx, state.position!.dy, playerSize, playerSize);
    // print((state.position! + Offset(playerSize/2, playerSize/2)).angleToDeg(aim));
    c.save();
    c.drawRect(rect, Paint()..color = state.color!);
    c.drawLine(
        center,
        center + Offset(aimSize * sin(angle), aimSize * cos(angle)),
        Paint()..color = Colors.amberAccent);
    c.restore();

    if (bullets.length > 0) {
      for (var b in bullets) {
        b.renderBullet(c);
        if (b.getRect().outsideRegion(Rect.fromLTWH(0, 0, x.width, x.height))) {
          bullets.remove(b);
        }
      }
    }
  }

  Offset oldDirection = Offset.zero;
  Offset direction = Offset.zero;
  bool overrideDirection = false;

  void setDirection(RawKeyEvent data) {
    if (data.runtimeType.toString() == "RawKeyDownEvent") {
      switch (data.character) {
        case "a":
          if (state.direction!.dx == 0) {
            direction = Offset(-1, state.direction!.dy);
          } else if (state.direction!.dx == 1) {
            direction = Offset(0, state.direction!.dy);
            overrideDirection = true;
          }
          break;
        case "w":
          if (state.direction!.dy == 0) {
            direction = Offset(state.direction!.dx, -1);
          } else if (state.direction!.dy == 1) {
            direction = Offset(state.direction!.dx, 0);
            overrideDirection = true;
          }
          break;
        case "d":
          if (state.direction!.dx == 0) {
            direction = Offset(1, state.direction!.dy);
          } else if (state.direction!.dx == -1) {
            direction = Offset(0, state.direction!.dy);
            overrideDirection = true;
          }
          break;
        case "s":
          if (state.direction!.dy == 0) {
            direction = Offset(state.direction!.dx, 1);
          } else if (state.direction!.dy == -1) {
            direction = Offset(state.direction!.dx, 0);
            overrideDirection = true;
          }
          break;
      }
    } else {
      switch (data.logicalKey.keyLabel) {
        case "a":
          if (overrideDirection) {
            direction = Offset(1, state.direction!.dy);
            overrideDirection = false;
          } else {
            direction = Offset(0, state.direction!.dy);
          }
          break;
        case "w":
          if (overrideDirection) {
            direction = Offset(state.direction!.dx, 1);
            overrideDirection = false;
          } else {
            direction = Offset(state.direction!.dx, 0);
          }
          break;
        case "d":
          if (overrideDirection) {
            direction = Offset(-1, state.direction!.dy);
            overrideDirection = false;
          } else {
            direction = Offset(0, state.direction!.dy);
          }
          break;
        case "s":
          if (overrideDirection) {
            direction = Offset(state.direction!.dx, -1);
            overrideDirection = false;
          } else {
            direction = Offset(state.direction!.dx, 0);
          }
          break;
      }
    }

    if (direction != Offset.zero) oldDirection = direction;
    state = state.copyWith(direction: direction);
  }

  void setAim(Offset details) {
    aim = details;
  }

  void shoot() {
    bullets.add(SimpleBullet(
      direction: aimAngle,
      color: Colors.white,
      position: Rect.fromLTWH(state.position!.dx, state.position!.dy, playerSize, playerSize).center,
    ));
    print('shot');
    print(bullets.length);
  }

  // * ================================= >
  void _move(x) {
    if (state.direction! == Offset.zero) {
      if (state.velocity! > 0) {
        state = state.copyWith(
          velocity:
              (state.velocity! - acceleration).clamp(0, maxVelocity).toDouble(),
          position: (state.position! +
                  Offset(state.velocity! * oldDirection.dx,
                      state.velocity! * oldDirection.dy))
              .clamp(Offset.zero,
                  Offset(x.width - playerSize, x.height - playerSize)),
        );
      }
    } else {
      state = state.copyWith(
        velocity:
            (state.velocity! + acceleration).clamp(0, maxVelocity).toDouble(),
        position: (state.position! +
                Offset(state.velocity! * state.direction!.dx,
                    state.velocity! * state.direction!.dy))
            .clamp(Offset.zero,
                Offset(x.width - playerSize, x.height - playerSize)),
      );
    }
  }
}

final playerProvider = StateNotifierProvider<PlayerController, Player>(
    (ref) => PlayerController());
