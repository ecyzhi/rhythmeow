import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rhythmeow/src/models/beatmap.dart';
import 'package:rhythmeow/src/models/song_info.dart';

class FileUtil {
  static Future<Beatmap> readBeatmap(String file) async {
    final String response =
        await rootBundle.loadString('assets/beatmaps/$file');
    final data = await json.decode(response);
    return Beatmap.fromJson(data);
  }

  static Future<List<SongInfo>> readSongInfoList() async {
    final String response =
        await rootBundle.loadString('assets/songs_info.json');
    final data = await json.decode(response);
    return List<SongInfo>.from(data.map((e) => SongInfo.fromJson(e)));
  }
}
