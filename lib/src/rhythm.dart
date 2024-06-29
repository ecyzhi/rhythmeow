import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rhythmeow/src/components/components.dart';
import 'package:rhythmeow/src/config.dart';
import 'package:collection/collection.dart';
import 'package:rhythmeow/src/constants/timer_constant.dart';
import 'package:rhythmeow/src/models/beat.dart';
import 'package:rhythmeow/src/models/beatmap.dart';
import 'package:rhythmeow/src/models/song_info.dart';
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
  Rhythm()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> combo = ValueNotifier(0);
  final ValueNotifier<String> hitFeedback = ValueNotifier('');
  final ValueNotifier<int> milliTime = ValueNotifier(0);
  final ValueNotifier<int> totalDuration = ValueNotifier(0);
  final ValueNotifier<int> currentDuration = ValueNotifier(0);
  double get width => size.x;
  double get height => size.y;

  late PlayState _playState;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
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
    world.add(PerfectZone());
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
      hitFeedbackTimer.onTick = () => hitFeedback.value = '';

      interval.onTick = () {
        milliTime.value += 10;
        if ((beatmap.beats?.isNotEmpty ?? false) &&
            beatmap.beats?.first.input != null &&
            ((beatmap.beats?.first.timeframe ?? 0) +
                    TimerConstant.delayNoteTimerInMillisecond) ==
                milliTime.value) {
          world.add(Note(NoteInput.values[beatmap.beats!.first.input!]));
          beatmap.beats?.removeAt(0);
        }
      };
    }

    startTimer.onTick = () async {
      audioPlayer?.dispose();
      audioPlayer = await FlameAudio.playLongAudio(songInfo!.song!);
      audioPlayer?.onPlayerComplete.listen((data) => pauseGame());

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

    score.value = 0;
    combo.value = 0;
    playState = PlayState.playing;

    // read beatmap
    if (!isEditing) {
      beatmap = await FileUtil.readBeatmap(songInfo!.beatmap!);
    }

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

    world.removeAll(world.children.query<Note>());

    hitFeedbackTimer.stop();
    interval.stop();
    startTimer.stop();
    score.value = 0;
    combo.value = 0;

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
    if (isEditing) {
      if (event is KeyDownEvent && playState == PlayState.playing) {
        switch (event.logicalKey) {
          case LogicalKeyboardKey.keyA:
            world.add(Note(NoteInput.A, isEditing: true));
            beatmap.beats?.add(Beat(
                timeframe: milliTime.value, input: 0, type: BeatType.hit.name));
          case LogicalKeyboardKey.keyS:
            world.add(Note(NoteInput.S, isEditing: true));
            beatmap.beats?.add(Beat(
                timeframe: milliTime.value, input: 1, type: BeatType.hit.name));
          case LogicalKeyboardKey.keyK:
            world.add(Note(NoteInput.K, isEditing: true));
            beatmap.beats?.add(Beat(
                timeframe: milliTime.value, input: 2, type: BeatType.hit.name));
          case LogicalKeyboardKey.keyL:
            world.add(Note(NoteInput.L, isEditing: true));
            beatmap.beats?.add(Beat(
                timeframe: milliTime.value, input: 3, type: BeatType.hit.name));
          case LogicalKeyboardKey.escape:
            pauseGame();
        }
      }
    } else {
      if (event is KeyDownEvent && playState == PlayState.playing) {
        switch (event.logicalKey) {
          case LogicalKeyboardKey.keyA:
            world.children
                .query<Note>()
                .firstWhereOrNull((e) => e.inZone && e.noteInput == NoteInput.A)
                ?.hit();
          case LogicalKeyboardKey.keyS:
            world.children
                .query<Note>()
                .firstWhereOrNull((e) => e.inZone && e.noteInput == NoteInput.S)
                ?.hit();
          case LogicalKeyboardKey.keyK:
            world.children
                .query<Note>()
                .firstWhereOrNull((e) => e.inZone && e.noteInput == NoteInput.K)
                ?.hit();
          case LogicalKeyboardKey.keyL:
            world.children
                .query<Note>()
                .firstWhereOrNull((e) => e.inZone && e.noteInput == NoteInput.L)
                ?.hit();
          case LogicalKeyboardKey.escape:
            pauseGame();
        }
      }
    }
    return KeyEventResult.handled;
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
