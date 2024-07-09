import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';
import 'package:rhythmeow/src/components/components.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/rhythm.dart';

class PerfectZone extends SvgComponent with HasGameReference<Rhythm> {
  PerfectZone(
    this.noteInput,
  ) : super(
          children: [RectangleHitbox()],
        );

  final NoteInput noteInput;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    paint = Paint()
      ..colorFilter = ColorFilter.mode(
          noteColor[noteInput.index].withOpacity(0.5), BlendMode.srcIn);
    svg = await Svg.load('images/svgs/paw.svg');

    double noteWidth = game.width / 4;
    position = Vector2(noteWidth * noteInput.index,
        game.height - perfectZoneHeight - missZoneHeight);
    size = Vector2(noteWidth, noteHeight);
  }
}
