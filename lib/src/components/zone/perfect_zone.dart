import 'dart:async';
import 'dart:ui' as ui;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/rhythm.dart';

class PerfectZone extends RectangleComponent with HasGameReference<Rhythm> {
  PerfectZone()
      : super(
          // paint: Paint()..color = perfectZoneColor,
          children: [RectangleHitbox()],
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    super.paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        const Offset(0, perfectZoneHeight),
        perfectZoneGradient,
        [0, 0.5, 1],
      );
    size = Vector2(game.width, perfectZoneHeight);
    position = Vector2(0, game.height - perfectZoneHeight);
  }
}
