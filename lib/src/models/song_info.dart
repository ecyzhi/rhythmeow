class SongInfo {
  final String? name;
  final String? singer;
  final String? beatmap;
  final String? song;
  final String? thumbnail;
  final String? description;

  SongInfo({
    this.name,
    this.singer,
    this.beatmap,
    this.song,
    this.thumbnail,
    this.description,
  });

  factory SongInfo.fromJson(Map<String, dynamic> json) => SongInfo(
        name: json['name'],
        singer: json['singer'],
        beatmap: json['beatmap'],
        song: json['song'],
        thumbnail: json['thumbnail'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['singer'] = singer;
    data['beatmap'] = beatmap;
    data['song'] = song;
    data['thumbnail'] = thumbnail;
    data['description'] = description;
    return data;
  }
}
