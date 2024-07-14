import 'package:flutter/material.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/constants/timer_constant.dart';
import 'package:rhythmeow/src/rhythm.dart';

class HomeOverlayScreen extends StatelessWidget {
  const HomeOverlayScreen({
    super.key,
    required this.game,
  });

  final Rhythm game;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Container(
        color: playAreaColor,
        alignment: const Alignment(0, 0),
        padding: const EdgeInsets.all(20),
        child: Flex(
          direction: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/home_background_small.jpg',
                      width: 250,
                      height: 250,
                    ),
                    Text(
                      'Rhythmeow',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    menuButton(
                        context, Icons.play_arrow, 'PLAY', game.selectSong),
                    menuButton(context, Icons.draw, 'EDITOR',
                        () => game.selectSong(edit: true)),
                    // menuButton(context, Icons.settings, 'SETTINGS',
                    //     () => showSettings(context)),
                    // menuButton(context, Icons.emoji_people, 'CREDIT', () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget menuButton(
    BuildContext context,
    IconData icon,
    String title,
    void Function() onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(icon, size: 80, color: bodyColor),
              // const SizedBox(width: 20),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: bodyColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('SETTINGS'),
              Material(
                child: Slider(
                  value: TimerConstant.noteSpeedMultiplierOption
                      .indexOf(game.noteSpeedMultiplier)
                      .toDouble(),
                  min: 0,
                  max: 4,
                  divisions: 5,
                  onChanged: (val) {
                    game.noteSpeedMultiplier =
                        TimerConstant.noteSpeedMultiplierOption[val.round()];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
