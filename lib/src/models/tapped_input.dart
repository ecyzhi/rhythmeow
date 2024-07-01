import 'package:flutter/foundation.dart';
import 'package:rhythmeow/src/components/components.dart';

class TappedInput with ChangeNotifier {
  final List<NoteInput> _tapped = [];
  List<NoteInput> get tapped => _tapped;

  void add(NoteInput input) {
    _tapped.add(input);
    notifyListeners();
  }

  void remove(NoteInput input) {
    _tapped.remove(input);
    notifyListeners();
  }
}
