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
      children: NoteInput.values
          .map((e) => Expanded(
                child: InkWell(
                  onTapDown: (_) => game.handleInput(e),
                  onTapUp: (_) => game.handleInputEnd(e),
                  child: ListenableBuilder(
                      listenable: game.tappedInput,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: game.tappedInput.tapped.contains(e)
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
              ))
          .toList(),
    );
  }
}
