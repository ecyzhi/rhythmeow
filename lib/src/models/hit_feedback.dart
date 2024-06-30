import 'package:flutter/foundation.dart';

class HitFeedback with ChangeNotifier {
  int _score = 0;
  int _combo = 0;
  String _display = '';

  int get score => _score;
  set score(val) {
    _score = val;
    notifyListeners();
  }

  int get combo => _combo;
  set combo(val) {
    _combo = val;
    notifyListeners();
  }

  String get display => _display;
  set display(val) {
    _display = val;
  }
}
