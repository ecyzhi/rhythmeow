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
      alignment: const Alignment(0, 0),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: game.backToHome,
                icon: const Icon(Icons.keyboard_backspace),
                iconSize: 30,
                color: bodyColor,
              ),
              const SizedBox(width: 20),
              Text(
                'Select Song',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: game.songInfoList.length,
              itemBuilder: (context, i) => InkWell(
                onTap: () => game.onSongPressed(game.songInfoList[i]),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/thumbnails/default_thumbnail.png',
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.songInfoList[i].name ?? '',
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              game.songInfoList[i].singer ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
