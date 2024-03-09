// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deathmatch_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeathmatchState on DeathmatchStateBase, Store {
  late final _$stopwatchAtom =
      Atom(name: 'DeathmatchStateBase.stopwatch', context: context);

  @override
  Stopwatch get stopwatch {
    _$stopwatchAtom.reportRead();
    return super.stopwatch;
  }

  @override
  set stopwatch(Stopwatch value) {
    _$stopwatchAtom.reportWrite(value, super.stopwatch, () {
      super.stopwatch = value;
    });
  }

  late final _$diffAndTimeVisibilityAtom =
      Atom(name: 'DeathmatchStateBase.diffAndTimeVisibility', context: context);

  @override
  ObservableList<bool> get diffAndTimeVisibility {
    _$diffAndTimeVisibilityAtom.reportRead();
    return super.diffAndTimeVisibility;
  }

  @override
  set diffAndTimeVisibility(ObservableList<bool> value) {
    _$diffAndTimeVisibilityAtom.reportWrite(value, super.diffAndTimeVisibility,
        () {
      super.diffAndTimeVisibility = value;
    });
  }

  late final _$gameLogAtom =
      Atom(name: 'DeathmatchStateBase.gameLog', context: context);

  @override
  Map<dynamic, dynamic> get gameLog {
    _$gameLogAtom.reportRead();
    return super.gameLog;
  }

  @override
  set gameLog(Map<dynamic, dynamic> value) {
    _$gameLogAtom.reportWrite(value, super.gameLog, () {
      super.gameLog = value;
    });
  }

  late final _$audioPlayerAtom =
      Atom(name: 'DeathmatchStateBase.audioPlayer', context: context);

  @override
  AudioPlayer get audioPlayer {
    _$audioPlayerAtom.reportRead();
    return super.audioPlayer;
  }

  @override
  set audioPlayer(AudioPlayer value) {
    _$audioPlayerAtom.reportWrite(value, super.audioPlayer, () {
      super.audioPlayer = value;
    });
  }

  late final _$dictionaryAtom =
      Atom(name: 'DeathmatchStateBase.dictionary', context: context);

  @override
  Dictionary? get dictionary {
    _$dictionaryAtom.reportRead();
    return super.dictionary;
  }

  @override
  set dictionary(Dictionary? value) {
    _$dictionaryAtom.reportWrite(value, super.dictionary, () {
      super.dictionary = value;
    });
  }

  late final _$rngAtom =
      Atom(name: 'DeathmatchStateBase.rng', context: context);

  @override
  Random get rng {
    _$rngAtom.reportRead();
    return super.rng;
  }

  @override
  set rng(Random value) {
    _$rngAtom.reportWrite(value, super.rng, () {
      super.rng = value;
    });
  }

  late final _$wordAtom =
      Atom(name: 'DeathmatchStateBase.word', context: context);

  @override
  String? get word {
    _$wordAtom.reportRead();
    return super.word;
  }

  @override
  set word(String? value) {
    _$wordAtom.reportWrite(value, super.word, () {
      super.word = value;
    });
  }

  late final _$difficultyAtom =
      Atom(name: 'DeathmatchStateBase.difficulty', context: context);

  @override
  int get difficulty {
    _$difficultyAtom.reportRead();
    return super.difficulty;
  }

  @override
  set difficulty(int value) {
    _$difficultyAtom.reportWrite(value, super.difficulty, () {
      super.difficulty = value;
    });
  }

  late final _$additionalTimeAtom =
      Atom(name: 'DeathmatchStateBase.additionalTime', context: context);

  @override
  int get additionalTime {
    _$additionalTimeAtom.reportRead();
    return super.additionalTime;
  }

  @override
  set additionalTime(int value) {
    _$additionalTimeAtom.reportWrite(value, super.additionalTime, () {
      super.additionalTime = value;
    });
  }

  late final _$partnerAtom =
      Atom(name: 'DeathmatchStateBase.partner', context: context);

  @override
  String? get partner {
    _$partnerAtom.reportRead();
    return super.partner;
  }

  @override
  set partner(String? value) {
    _$partnerAtom.reportWrite(value, super.partner, () {
      super.partner = value;
    });
  }

  late final _$scoreAtom =
      Atom(name: 'DeathmatchStateBase.score', context: context);

  @override
  int get score {
    _$scoreAtom.reportRead();
    return super.score;
  }

  @override
  set score(int value) {
    _$scoreAtom.reportWrite(value, super.score, () {
      super.score = value;
    });
  }

  late final _$mainTimerAtom =
      Atom(name: 'DeathmatchStateBase.mainTimer', context: context);

  @override
  int get mainTimer {
    _$mainTimerAtom.reportRead();
    return super.mainTimer;
  }

  @override
  set mainTimer(int value) {
    _$mainTimerAtom.reportWrite(value, super.mainTimer, () {
      super.mainTimer = value;
    });
  }

  late final _$addTimerAtom =
      Atom(name: 'DeathmatchStateBase.addTimer', context: context);

  @override
  int get addTimer {
    _$addTimerAtom.reportRead();
    return super.addTimer;
  }

  @override
  set addTimer(int value) {
    _$addTimerAtom.reportWrite(value, super.addTimer, () {
      super.addTimer = value;
    });
  }

  late final _$stateAtom =
      Atom(name: 'DeathmatchStateBase.state', context: context);

  @override
  String get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(String value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$matchTimerAtom =
      Atom(name: 'DeathmatchStateBase.matchTimer', context: context);

  @override
  Timer? get matchTimer {
    _$matchTimerAtom.reportRead();
    return super.matchTimer;
  }

  @override
  set matchTimer(Timer? value) {
    _$matchTimerAtom.reportWrite(value, super.matchTimer, () {
      super.matchTimer = value;
    });
  }

  late final _$gameLogSentAtom =
      Atom(name: 'DeathmatchStateBase.gameLogSent', context: context);

  @override
  bool get gameLogSent {
    _$gameLogSentAtom.reportRead();
    return super.gameLogSent;
  }

  @override
  set gameLogSent(bool value) {
    _$gameLogSentAtom.reportWrite(value, super.gameLogSent, () {
      super.gameLogSent = value;
    });
  }

  late final _$startingCountdownAtom =
      Atom(name: 'DeathmatchStateBase.startingCountdown', context: context);

  @override
  int get startingCountdown {
    _$startingCountdownAtom.reportRead();
    return super.startingCountdown;
  }

  @override
  set startingCountdown(int value) {
    _$startingCountdownAtom.reportWrite(value, super.startingCountdown, () {
      super.startingCountdown = value;
    });
  }

  late final _$countdownTimerAtom =
      Atom(name: 'DeathmatchStateBase.countdownTimer', context: context);

  @override
  Timer? get countdownTimer {
    _$countdownTimerAtom.reportRead();
    return super.countdownTimer;
  }

  @override
  set countdownTimer(Timer? value) {
    _$countdownTimerAtom.reportWrite(value, super.countdownTimer, () {
      super.countdownTimer = value;
    });
  }

  late final _$DeathmatchStateBaseActionController =
      ActionController(name: 'DeathmatchStateBase', context: context);

  @override
  void toggleVisibility(int idx) {
    final _$actionInfo = _$DeathmatchStateBaseActionController.startAction(
        name: 'DeathmatchStateBase.toggleVisibility');
    try {
      return super.toggleVisibility(idx);
    } finally {
      _$DeathmatchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startBlinking(int idx) {
    final _$actionInfo = _$DeathmatchStateBaseActionController.startAction(
        name: 'DeathmatchStateBase.startBlinking');
    try {
      return super.startBlinking(idx);
    } finally {
      _$DeathmatchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void guessedRight() {
    final _$actionInfo = _$DeathmatchStateBaseActionController.startAction(
        name: 'DeathmatchStateBase.guessedRight');
    try {
      return super.guessedRight();
    } finally {
      _$DeathmatchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void timerTick() {
    final _$actionInfo = _$DeathmatchStateBaseActionController.startAction(
        name: 'DeathmatchStateBase.timerTick');
    try {
      return super.timerTick();
    } finally {
      _$DeathmatchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setState(String newState) {
    final _$actionInfo = _$DeathmatchStateBaseActionController.startAction(
        name: 'DeathmatchStateBase.setState');
    try {
      return super.setState(newState);
    } finally {
      _$DeathmatchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void concede() {
    final _$actionInfo = _$DeathmatchStateBaseActionController.startAction(
        name: 'DeathmatchStateBase.concede');
    try {
      return super.concede();
    } finally {
      _$DeathmatchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startMatch() {
    final _$actionInfo = _$DeathmatchStateBaseActionController.startAction(
        name: 'DeathmatchStateBase.startMatch');
    try {
      return super.startMatch();
    } finally {
      _$DeathmatchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startingCountdownTick() {
    final _$actionInfo = _$DeathmatchStateBaseActionController.startAction(
        name: 'DeathmatchStateBase.startingCountdownTick');
    try {
      return super.startingCountdownTick();
    } finally {
      _$DeathmatchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startCountdown() {
    final _$actionInfo = _$DeathmatchStateBaseActionController.startAction(
        name: 'DeathmatchStateBase.startCountdown');
    try {
      return super.startCountdown();
    } finally {
      _$DeathmatchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetMatchTimer() {
    final _$actionInfo = _$DeathmatchStateBaseActionController.startAction(
        name: 'DeathmatchStateBase.resetMatchTimer');
    try {
      return super.resetMatchTimer();
    } finally {
      _$DeathmatchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
stopwatch: ${stopwatch},
diffAndTimeVisibility: ${diffAndTimeVisibility},
gameLog: ${gameLog},
audioPlayer: ${audioPlayer},
dictionary: ${dictionary},
rng: ${rng},
word: ${word},
difficulty: ${difficulty},
additionalTime: ${additionalTime},
partner: ${partner},
score: ${score},
mainTimer: ${mainTimer},
addTimer: ${addTimer},
state: ${state},
matchTimer: ${matchTimer},
gameLogSent: ${gameLogSent},
startingCountdown: ${startingCountdown},
countdownTimer: ${countdownTimer}
    ''';
  }
}
