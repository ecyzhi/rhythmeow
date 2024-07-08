import 'package:flutter/foundation.dart';
import 'package:rhythmeow/src/components/components.dart';

class TappedInput with ChangeNotifier {
  final Map<NoteInput, int> _tapped = {
    NoteInput.A: 0,
    NoteInput.S: 0,
    NoteInput.K: 0,
    NoteInput.L: 0,
  };
  Map<NoteInput, int> get tapped => _tapped;

  void add(NoteInput input) {
    if (_tapped[input] != null) {
      _tapped[input] = _tapped[input]! + 1;
      notifyListeners();
    }
  }

  void remove(NoteInput? input) {
    if (input == null) return;
    if (_tapped[input] != null && _tapped[input] != 0) {
      _tapped[input] = _tapped[input]! - 1;
      notifyListeners();
    }
  }

  void removeOther(NoteInput? input) {
    _tapped.forEach((key, value) {
      if (key != input && _tapped[key] != null && _tapped[key] != 0) {
        _tapped[key] = _tapped[key]! - 1;
      }
    });
    notifyListeners();
  }
}
