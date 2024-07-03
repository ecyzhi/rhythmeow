import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:rhythmeow/src/rhythm.dart';
import 'package:rhythmeow/src/widgets/overlays/overlays.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final Rhythm game;

  @override
  void initState() {
    super.initState();
    game = Rhythm();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.yatraOneTextTheme().apply(
          bodyColor: bodyColor,
          displayColor: displayColor,
        ),
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: bgGradientColor,
            ),
          ),
          child: SafeArea(
            child: GameWidget(
              game: game,
              overlayBuilderMap: {
                PlayState.welcome.name: (context, _) =>
                    HomeOverlayScreen(game: game),
                PlayState.playing.name: (context, _) =>
                    PlayingOverlayScreen(game: game),
                PlayState.paused.name: (context, _) =>
                    PauseOverlayScreen(game: game),
                PlayState.selectSong.name: (context, _) =>
                    SelectSongOverlayScreen(game: game),
                PlayState.gameOver.name: (context, _) =>
                    GameOverOverlayScreen(game: game),
              },
            ),
          ),
        ),
      ),
    );
  }
}
