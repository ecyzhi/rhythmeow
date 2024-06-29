import 'dart:convert';
import 'package:universal_html/html.dart';

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

  static Future<void> saveBeatmap({
    String filename = 'rhythmeow',
    Beatmap? beatmap,
  }) async {
    if (beatmap?.beats == null) return;

    // prepare
    filename = filename.replaceFirst('.mp3', '');
    String encodedBeatmap = jsonEncode(beatmap?.beats);
    final bytes = utf8.encode(encodedBeatmap);
    final blob = Blob([bytes]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = document.createElement('a') as AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$filename.json';
    document.body?.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    document.body?.children.remove(anchor);
    Url.revokeObjectUrl(url);
  }
}
