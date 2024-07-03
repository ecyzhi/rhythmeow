import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:rhythmeow/src/components/components.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/constants/audio_constant.dart';
import 'package:rhythmeow/src/rhythm.dart';

enum NoteInput { A, S, K, L }

enum Zone { cool, perfect, miss }

class Note extends RectangleComponent
    with CollisionCallbacks, HasGameReference<Rhythm> {
  Note(
    this.noteInput, {
    this.seqNo = 0,
    this.isEditing = false,
  }) : super(
          paint: Paint()..color = noteColor[noteInput.index],
          children: [RectangleHitbox()],
        );

  final NoteInput noteInput;
  final double seqNo;
  final bool isEditing;
  bool inZone = false;
  Zone zone = Zone.miss;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    double noteWidth = (game.width - (noteGap * 4)) / 4;
    position = Vector2(
        (noteWidth * noteInput.index) +
            (0.5 * noteGap) +
            (noteInput.index * noteGap),
        isEditing ? game.height - perfectZoneHeight : 0);
    size = Vector2(noteWidth, noteHeight);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isEditing) {
      position.y -=
          (game.height - (perfectZoneHeight / 2)) * noteSpeedMultiplier * dt;

      if (position.y < -noteHeight) {
        removeFromParent();
      }
    } else {
      position.y +=
          (game.height - (perfectZoneHeight / 2)) * noteSpeedMultiplier * dt;

      if (position.y >= game.height) {
        removeFromParent();
        game.hitFeedback.display = 'Miss';
        game.hitFeedback.combo = 0;
        game.hitFeedbackTimer.reset();
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    inZone = true;

    if (other is CoolZone) {
      zone = Zone.cool;
    } else if (other is PerfectZone) {
      zone = Zone.perfect;
    }
  }

  void hit() {
    if (zone == Zone.cool) {
      game.hitFeedback.score += 1;
      game.hitFeedback.display = 'Cool';
    } else if (zone == Zone.perfect) {
      game.hitFeedback.score += 2;
      game.hitFeedback.display = 'Perfect';
    }
    game.hitFeedback.combo++;
    game.hitFeedbackTimer.reset();
    FlameAudio.play(AudioEffect.hit, volume: 0.2);
    add(RemoveEffect());
  }
}
