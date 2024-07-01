import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/rhythm.dart';
import 'package:rhythmeow/src/widgets/touchpad.dart';

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
      alignment: const Alignment(0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            height: 10,
            child: ValueListenableBuilder<int>(
                valueListenable: game.totalDuration,
                builder: (context, totalDuration, child) {
                  return ValueListenableBuilder<int>(
                      valueListenable: game.currentDuration,
                      builder: (context, currentDuration, child) {
                        double value = totalDuration == 0
                            ? 0
                            : currentDuration / totalDuration;
                        return LinearProgressIndicator(value: value);
                      });
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: game.milliTime,
                  builder: (context, milliTime, child) {
                    DateTime time =
                        DateTime.fromMillisecondsSinceEpoch(milliTime).toUtc();
                    String timestamp =
                        '${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}.${time.millisecond}';

                    return Text(
                      timestamp,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.right,
                    );
                  },
                ),
                Center(
                  child: ListenableBuilder(
                    listenable: game.hitFeedback,
                    builder: (context, child) {
                      return Text(
                        game.hitFeedback.score.toString(),
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.right,
                      );
                    },
                  ),
                ),
                IconButton(
                  onPressed: game.pauseGame,
                  icon: const Icon(Icons.pause),
                  iconSize: 60,
                  color: bodyColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Touchpad(game: game),
                Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListenableBuilder(
                      listenable: game.hitFeedback,
                      builder: (context, child) {
                        hitFeedbackController?.reset();
                        hitFeedbackController?.forward();

                        return Text(
                          game.hitFeedback.display,
                          style: Theme.of(context).textTheme.headlineLarge,
                        )
                            .animate(
                              onInit: (controller) =>
                                  hitFeedbackController = controller,
                            )
                            .slideY(duration: 100.ms, begin: -0.5, end: 0)
                            .then()
                            .fade(delay: 300.ms, duration: 100.ms, end: 0);
                      },
                    ),
                    ListenableBuilder(
                      listenable: game.hitFeedback,
                      builder: (context, child) {
                        comboController?.reset();
                        comboController?.forward();

                        return Text(
                          game.hitFeedback.combo == 0
                              ? ''
                              : game.hitFeedback.combo.toString(),
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                            .animate(
                              onPlay: (controller) =>
                                  comboController = controller,
                            )
                            .scaleXY(duration: 100.ms, begin: 0.8)
                            .then()
                            .fade(delay: 700.ms, duration: 500.ms, end: 0);
                      },
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
