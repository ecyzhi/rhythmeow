import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/rhythm.dart';

class PerfectZone extends RectangleComponent with HasGameReference<Rhythm> {
  PerfectZone()
      : super(
          paint: Paint()..color = perfectZoneColor,
          children: [RectangleHitbox()],
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, perfectZoneHeight);
    position = Vector2(0, game.height - perfectZoneHeight);
  }
}
