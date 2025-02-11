import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rhythmeow/src/components/components.dart';
import 'package:collection/collection.dart';
import 'package:rhythmeow/src/constants/timer_constant.dart';
import 'package:rhythmeow/src/models/beat.dart';
import 'package:rhythmeow/src/models/beatmap.dart';
import 'package:rhythmeow/src/models/hit_feedback.dart';
import 'package:rhythmeow/src/models/song_info.dart';
import 'package:rhythmeow/src/models/tapped_input.dart';
import 'package:rhythmeow/src/utils/file_util.dart';

enum PlayState {
  welcome,
  playing,
  paused,
  gameOver,
  selectSong,
  settings,
  credit,
}

class Rhythm extends FlameGame
    with
        HasCollisionDetection,
        KeyboardEvents,
        TapDetector,
        WidgetsBindingObserver {
  Rhythm();

  final HitFeedback hitFeedback = HitFeedback();
  final TappedInput tappedInput = TappedInput();
  final ValueNotifier<int> milliTime = ValueNotifier(0);
  final ValueNotifier<int> totalDuration = ValueNotifier(0);
  final ValueNotifier<int> currentDuration = ValueNotifier(0);
  double get width => size.x;
  double get height => size.y;

  double noteSpeedMultiplier = 4 / 4; // 1/4, 2/4, 4/4, 5/4, 8/4

  late PlayState _playState;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
        overlays.remove(PlayState.selectSong.name);
        overlays.remove(PlayState.playing.name);
        overlays.remove(PlayState.paused.name);
        overlays.add(playState.name);
      case PlayState.paused:
        overlays.remove(PlayState.playing.name);
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.paused.name);
        overlays.remove(PlayState.selectSong.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.add(playState.name);
      case PlayState.selectSong:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.playing.name);
        overlays.add(playState.name);
      case PlayState.gameOver:
        overlays.remove(PlayState.playing.name);
        overlays.add(playState.name);
      case PlayState.settings:
      case PlayState.credit:
    }
  }

  List<SongInfo> songInfoList = [];
  SongInfo? songInfo;
  Beatmap beatmap = Beatmap();
  AudioPlayer? audioPlayer;

  bool isEditing = false;

  Timer hitFeedbackTimer =
      Timer(TimerConstant.hitFeedbackTimerInSecond, repeat: true);
  Timer interval = Timer(TimerConstant.intervalInSecond, repeat: true);
  Timer startTimer = Timer(TimerConstant.startTimerInSecond);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    WidgetsBinding.instance.addObserver(this);

    world.add(PlayArea());
    world.add(PerfectZone(NoteInput.A));
    world.add(PerfectZone(NoteInput.S));
    world.add(PerfectZone(NoteInput.K));
    world.add(PerfectZone(NoteInput.L));
    world.add(CoolZone());

    playState = PlayState.welcome;

    songInfoList = await FileUtil.readSongInfoList();
  }

  @override
  void onDispose() {
    WidgetsBinding.instance.removeObserver(this);
    audioPlayer?.dispose();
    super.onDispose();
  }

  void initTimer() {
    hitFeedbackTimer.stop();
    interval.stop();
    startTimer.stop();

    if (isEditing) {
      hitFeedbackTimer.onTick = () {};

      interval.onTick = () {
        milliTime.value += 10;
      };
    } else {
      hitFeedbackTimer.onTick = () {
        if (hitFeedback.display != '') hitFeedback.display = '';
      };

      interval.onTick = () {
        milliTime.value += 10;
        if ((beatmap.beats?.isNotEmpty ?? false) &&
            beatmap.beats?.first.input != null &&
            (beatmap.beats?.first.timeframe ?? 0) -
                    (1000 / noteSpeedMultiplier - 1000) ==
                milliTime.value) {
          world.add(Note(NoteInput.values[beatmap.beats!.first.input!]));
          beatmap.beats?.removeAt(0);
        }
      };
    }

    startTimer.onTick = () async {
      // Temp solution: Seek to position 0:00 to restart the song
      audioPlayer?.seek(Duration.zero);
      audioPlayer?.setVolume(1);

      audioPlayer?.onPlayerComplete.listen((data) => gameOver());

      totalDuration.value =
          (await audioPlayer?.getDuration())?.inMilliseconds ?? 0;
      audioPlayer?.onPositionChanged
          .listen((data) => currentDuration.value = data.inMilliseconds);
    };
  }

  void startGame() async {
    if (playState == PlayState.playing) return;

    if (songInfo?.beatmap == null || songInfo?.song == null) return;

    // Reset
    world.removeAll(world.children.query<Note>());

    hitFeedback.score = 0;
    hitFeedback.combo = 0;
    playState = PlayState.playing;

    // read beatmap
    if (!isEditing) {
      beatmap = await FileUtil.readBeatmap(songInfo!.beatmap!);
    }

    // Temp solution: Play at volume 0 to load the file. Tried cache.load but still not in sync at start.
    audioPlayer = await FlameAudio.playLongAudio(songInfo!.song!, volume: 0);

    hitFeedbackTimer.start();
    interval.start();
    startTimer.start();
  }

  void pauseGame() {
    pauseEngine();
    audioPlayer?.pause();
    playState = PlayState.paused;
  }

  void resumeGame() {
    resumeEngine();

    // Temp solution: remove audio if there is audio playing before startTimer delay end.
    if (startTimer.isRunning()) {
      audioPlayer?.setVolume(0);
    }

    audioPlayer?.resume();
    playState = PlayState.playing;
  }

  void endGame() {
    resumeEngine();

    audioPlayer?.stop();
    FlameAudio.audioCache.clearAll();

    world.removeAll(world.children.query<Note>());

    hitFeedbackTimer.stop();
    interval.stop();
    startTimer.stop();
    hitFeedback.score = 0;
    hitFeedback.combo = 0;

    milliTime.value = 0;
    totalDuration.value = 0;
    currentDuration.value = 0;

    beatmap = Beatmap();

    playState = PlayState.selectSong;
  }

  void restartGame() {
    endGame();
    startGame();
  }

  void onSongPressed(SongInfo info) {
    songInfo = info;
    startGame();
  }

  void selectSong({bool edit = false}) {
    isEditing = edit;
    initTimer();

    playState = PlayState.selectSong;
  }

  void backToHome() {
    playState = PlayState.welcome;
  }

  void gameOver() {
    playState = PlayState.gameOver;
  }

  void exportBeatmap() async {
    await FileUtil.saveBeatmap(
      filename: songInfo?.song ?? 'rhythmeow',
      beatmap: beatmap,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    hitFeedbackTimer.update(dt);
    interval.update(dt);
    startTimer.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    if (playState == PlayState.playing) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyA:
        case LogicalKeyboardKey.keyS:
        case LogicalKeyboardKey.keyK:
        case LogicalKeyboardKey.keyL:
          if (event is KeyDownEvent) {
            handleInput(NoteInput.values.byName(event.logicalKey.keyLabel));
          } else if (event is KeyUpEvent) {
            handleInputEnd(NoteInput.values.byName(event.logicalKey.keyLabel));
          }
        case LogicalKeyboardKey.escape:
          pauseGame();
      }
    }
    return KeyEventResult.handled;
  }

  handleInput(NoteInput? input) {
    if (input == null) return;
    tappedInput.add(input);

    if (isEditing) {
      world.add(Note(input, isEditing: true));
      beatmap.beats?.add(Beat(
        timeframe: milliTime.value - 1000,
        input: NoteInput.values.indexOf(input),
        type: BeatType.hit.name,
      ));
    } else {
      world.children
          .query<Note>()
          .firstWhereOrNull((e) => e.inZone && e.noteInput == input)
          ?.hit();
    }
  }

  handleInputEnd(NoteInput? input) {
    tappedInput.remove(input);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed &&
        [PlayState.playing, PlayState.paused].contains(playState)) {
      pauseGame();
    }
  }
}
