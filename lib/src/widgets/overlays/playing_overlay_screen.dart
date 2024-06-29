import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/rhythm.dart';

class PlayingOverlayScreen extends StatelessWidget {
  const PlayingOverlayScreen({
    super.key,
    required this.game,
  });

  final Rhythm game;

  @override
  Widget build(BuildContext context) {
    AnimationController? hitFeedbackController;
    AnimationController? comboController;

    return Container(
      alignment: const Alignment(0, -0.15),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: game.pauseGame,
                  icon: const Icon(Icons.pause),
                  iconSize: 60,
                  color: bodyColor,
                ),
                ValueListenableBuilder<int>(
                    valueListenable: game.score,
                    builder: (context, score, child) {
                      return Text(
                        'Score\n$score',
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.right,
                      );
                    }),
              ],
            ),
          ),
          Expanded(
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<String>(
                    valueListenable: game.hitFeedback,
                    builder: (context, hitFeedback, child) {
                      hitFeedbackController?.reset();
                      hitFeedbackController?.forward();

                      return Text(
                        hitFeedback,
                        style: Theme.of(context).textTheme.headlineLarge,
                      )
                          .animate(
                            onInit: (controller) =>
                                hitFeedbackController = controller,
                          )
                          .slideY(duration: 100.ms, begin: -0.5, end: 0)
                          .then()
                          .fade(delay: 300.ms, duration: 100.ms, end: 0);
                    }),
                ValueListenableBuilder<int>(
                    valueListenable: game.combo,
                    builder: (context, combo, child) {
                      comboController?.reset();
                      comboController?.forward();

                      return Text(
                        combo == 0 ? '' : combo.toString(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      )
                          .animate(
                            onPlay: (controller) =>
                                comboController = controller,
                          )
                          .scaleXY(duration: 100.ms, begin: 0.8)
                          .then()
                          .fade(delay: 700.ms, duration: 500.ms, end: 0);
                    }),
              ],
            )),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ValueListenableBuilder<int>(
                valueListenable: game.milliTime,
                builder: (context, milliTime, child) {
                  return Text(
                    milliTime.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.right,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
