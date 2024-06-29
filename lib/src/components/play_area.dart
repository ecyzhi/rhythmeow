import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/rhythm.dart';

class PlayArea extends RectangleComponent with HasGameReference<Rhythm> {
  PlayArea()
      : super(
          paint: Paint()..color = playAreaColor,
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
