import 'package:rhythmeow/src/models/beat.dart';

class Beatmap {
  List<Beat>? beats;

  Beatmap({
    beats,
  }) {
    this.beats = beats ?? [];
  }

  factory Beatmap.fromJson(List<dynamic> json) => Beatmap(
        beats: List<Beat>.from(json.map((e) => Beat.fromJson(e))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['beats'] = beats?.map((e) => e.toJson()).toList();
    return data;
  }
}
