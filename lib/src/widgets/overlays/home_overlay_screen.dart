import 'package:flutter/material.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/rhythm.dart';

class HomeOverlayScreen extends StatelessWidget {
  const HomeOverlayScreen({
    super.key,
    required this.game,
  });

  final Rhythm game;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: playAreaColor,
      alignment: const Alignment(0, -0.15),
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rhythm',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 250),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                menuButton(context, Icons.play_arrow, 'PLAY', game.selectSong),
                menuButton(context, Icons.draw, 'EDITOR',
                    () => game.selectSong(edit: true)),
                // menuButton(context, Icons.settings, 'SETTINGS', () {}),
                // menuButton(context, Icons.emoji_people, 'CREDIT', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget menuButton(
    BuildContext context,
    IconData icon,
    String title,
    void Function() onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(icon, size: 80, color: bodyColor),
              // const SizedBox(width: 20),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: bodyColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
