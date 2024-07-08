import 'package:flutter/material.dart';
import 'package:rhythmeow/src/components/components.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/rhythm.dart';

class Touchpad extends StatelessWidget {
  const Touchpad({super.key, required this.game});
  final Rhythm game;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: NoteInput.values.map((e) => buildTapArea(e)).toList(),
    );
  }

  Expanded buildTapArea(NoteInput e) {
    NoteInput? input;
    return Expanded(
      child: GestureDetector(
        onPanDown: (_) {
          input = e;
          game.handleInput(e);
        },
        onPanUpdate: (details) {
          double noteWidth = game.width / 4;
          NoteInput? newInput;
          if (details.globalPosition.dx >= noteWidth * 3) {
            newInput = NoteInput.L;
          } else if (details.globalPosition.dx >= noteWidth * 2) {
            newInput = NoteInput.K;
          } else if (details.globalPosition.dx >= noteWidth) {
            newInput = NoteInput.S;
          } else if (details.globalPosition.dx >= 0) {
            newInput = NoteInput.A;
          }

          if (input == null && newInput != null) {
            input = newInput;
            game.handleInput(input!);
          }
          if (newInput != input) {
            game.handleInput(newInput);
            game.handleInputEnd(input);
            input = newInput;
          }
        },
        onPanEnd: (details) {
          game.handleInputEnd(input);
        },
        child: ListenableBuilder(
            listenable: game.tappedInput,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: (game.tappedInput.tapped[e] ?? 0) > 0
                      ? const LinearGradient(
                          colors: inputGradient,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                ),
              );
            }),
      ),
    );
  }
}
