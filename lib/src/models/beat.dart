enum BeatType { hit, holdStart, holdEnd }

class Beat {
  final int? timeframe;
  final int? input;
  final String? type;

  Beat({
    this.timeframe,
    this.input,
    this.type,
  });

  factory Beat.fromJson(dynamic json) => Beat(
        timeframe: json['timeframe'],
        input: json['input'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timeframe'] = timeframe;
    data['input'] = input;
    data['type'] = type;
    return data;
  }
}
