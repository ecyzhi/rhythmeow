import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rhythmeow/src/rhythm.dart';

class GameOverOverlayScreen extends StatelessWidget {
  const GameOverOverlayScreen({
    super.key,
    required this.game,
  });

  final Rhythm game;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, 0),
      padding: const EdgeInsets.all(16),
      color: Colors.black45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            game.hitFeedback.score.toString(),
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(color: Colors.white),
          ).animate().slideY(duration: 200.ms, begin: -1, end: 0),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 20),
              IconButton(
                onPressed: game.restartGame,
                icon: const Icon(Icons.replay),
                iconSize: 50,
                color: Colors.white,
              ),
              if (game.isEditing) ...[
                const SizedBox(width: 20),
                IconButton(
                  onPressed: game.exportBeatmap,
                  icon: const Icon(Icons.download),
                  iconSize: 50,
                  color: Colors.white,
                ),
              ],
              const SizedBox(width: 20),
              IconButton(
                onPressed: game.endGame,
                icon: const Icon(Icons.exit_to_app),
                iconSize: 50,
                color: Colors.white,
              ),
            ],
          ).animate().slideY(duration: 200.ms, begin: 0.2, end: 0),
        ],
      ),
    );
  }
}
