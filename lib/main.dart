import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rhythmeow/src/widgets/game_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const GameApp());
}
