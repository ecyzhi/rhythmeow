class TimerConstant {
  static const hitFeedbackTimerInSecond = 0.5;
  static const intervalInSecond = 0.01;

  /// Delay song start. Default 3 seconds once they enter into the playing state from selecting song.
  static const startTimerInSecond = 3.0;

  /// This is so that the note will fall in perfect zone correctly with the startTimer in place.
  /// If noteSpeed changed, this will need to be changed as well.
  /// When noteSpeed = 700, without delay note reaching perfect zone approx. = 2080
  /// 3000 - 2080 = 920ms
  // static const delayNoteTimerInMillisecond = 920;
  static const delayNoteTimerInMillisecond = -2080;
}
