import 'package:flutter/material.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/rhythm.dart';

class SelectSongOverlayScreen extends StatelessWidget {
  const SelectSongOverlayScreen({
    super.key,
    required this.game,
  });

  final Rhythm game;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: playAreaColor,
      alignment: const Alignment(0, -0.15),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 50),
          Row(
            children: [
              IconButton(
                onPressed: game.backToHome,
                icon: const Icon(Icons.keyboard_backspace),
                iconSize: 60,
                color: bodyColor,
              ),
              const SizedBox(width: 80),
              Text(
                'Select Song',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
          const SizedBox(height: 50),
          Expanded(
            child: ListView.builder(
              itemCount: game.songInfoList.length,
              itemBuilder: (context, i) => InkWell(
                onTap: () => game.onSongPressed(game.songInfoList[i]),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/thumbnails/default_thumbnail.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(width: 50),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.songInfoList[i].name ?? '',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              game.songInfoList[i].singer ?? '',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
