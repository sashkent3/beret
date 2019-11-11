// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GameState on _GameState, Store {
  Computed<int> _$playerOneIDComputed;

  @override
  int get playerOneID =>
      (_$playerOneIDComputed ??= Computed<int>(() => super.playerOneID)).value;
  Computed<int> _$playerTwoIDComputed;

  @override
  int get playerTwoID =>
      (_$playerTwoIDComputed ??= Computed<int>(() => super.playerTwoID)).value;
  Computed<String> _$playerOneComputed;

  @override
  String get playerOne =>
      (_$playerOneComputed ??= Computed<String>(() => super.playerOne)).value;
  Computed<String> _$playerTwoComputed;

  @override
  String get playerTwo =>
      (_$playerTwoComputed ??= Computed<String>(() => super.playerTwo)).value;

  final _$newTurnTimerCntAtom = Atom(name: '_GameState.newTurnTimerCnt');

  @override
  int get newTurnTimerCnt {
    _$newTurnTimerCntAtom.context.enforceReadPolicy(_$newTurnTimerCntAtom);
    _$newTurnTimerCntAtom.reportObserved();
    return super.newTurnTimerCnt;
  }

  @override
  set newTurnTimerCnt(int value) {
    _$newTurnTimerCntAtom.context.conditionallyRunInAction(() {
      super.newTurnTimerCnt = value;
      _$newTurnTimerCntAtom.reportChanged();
    }, _$newTurnTimerCntAtom, name: '${_$newTurnTimerCntAtom.name}_set');
  }

  final _$stateAtom = Atom(name: '_GameState.state');

  @override
  String get state {
    _$stateAtom.context.enforceReadPolicy(_$stateAtom);
    _$stateAtom.reportObserved();
    return super.state;
  }

  @override
  set state(String value) {
    _$stateAtom.context.conditionallyRunInAction(() {
      super.state = value;
      _$stateAtom.reportChanged();
    }, _$stateAtom, name: '${_$stateAtom.name}_set');
  }

  final _$logAtom = Atom(name: '_GameState.log');

  @override
  List get log {
    _$logAtom.context.enforceReadPolicy(_$logAtom);
    _$logAtom.reportObserved();
    return super.log;
  }

  @override
  set log(List value) {
    _$logAtom.context.conditionallyRunInAction(() {
      super.log = value;
      _$logAtom.reportChanged();
    }, _$logAtom, name: '${_$logAtom.name}_set');
  }

  final _$turnLogAtom = Atom(name: '_GameState.turnLog');

  @override
  List get turnLog {
    _$turnLogAtom.context.enforceReadPolicy(_$turnLogAtom);
    _$turnLogAtom.reportObserved();
    return super.turnLog;
  }

  @override
  set turnLog(List value) {
    _$turnLogAtom.context.conditionallyRunInAction(() {
      super.turnLog = value;
      _$turnLogAtom.reportChanged();
    }, _$turnLogAtom, name: '${_$turnLogAtom.name}_set');
  }

  final _$gameLogAtom = Atom(name: '_GameState.gameLog');

  @override
  List get gameLog {
    _$gameLogAtom.context.enforceReadPolicy(_$gameLogAtom);
    _$gameLogAtom.reportObserved();
    return super.gameLog;
  }

  @override
  set gameLog(List value) {
    _$gameLogAtom.context.conditionallyRunInAction(() {
      super.gameLog = value;
      _$gameLogAtom.reportChanged();
    }, _$gameLogAtom, name: '${_$gameLogAtom.name}_set');
  }

  final _$mainStateLengthAtom = Atom(name: '_GameState.mainStateLength');

  @override
  int get mainStateLength {
    _$mainStateLengthAtom.context.enforceReadPolicy(_$mainStateLengthAtom);
    _$mainStateLengthAtom.reportObserved();
    return super.mainStateLength;
  }

  @override
  set mainStateLength(int value) {
    _$mainStateLengthAtom.context.conditionallyRunInAction(() {
      super.mainStateLength = value;
      _$mainStateLengthAtom.reportChanged();
    }, _$mainStateLengthAtom, name: '${_$mainStateLengthAtom.name}_set');
  }

  final _$lastStateLengthAtom = Atom(name: '_GameState.lastStateLength');

  @override
  int get lastStateLength {
    _$lastStateLengthAtom.context.enforceReadPolicy(_$lastStateLengthAtom);
    _$lastStateLengthAtom.reportObserved();
    return super.lastStateLength;
  }

  @override
  set lastStateLength(int value) {
    _$lastStateLengthAtom.context.conditionallyRunInAction(() {
      super.lastStateLength = value;
      _$lastStateLengthAtom.reportChanged();
    }, _$lastStateLengthAtom, name: '${_$lastStateLengthAtom.name}_set');
  }

  final _$matchDifficultyAtom = Atom(name: '_GameState.matchDifficulty');

  @override
  int get matchDifficulty {
    _$matchDifficultyAtom.context.enforceReadPolicy(_$matchDifficultyAtom);
    _$matchDifficultyAtom.reportObserved();
    return super.matchDifficulty;
  }

  @override
  set matchDifficulty(int value) {
    _$matchDifficultyAtom.context.conditionallyRunInAction(() {
      super.matchDifficulty = value;
      _$matchDifficultyAtom.reportChanged();
    }, _$matchDifficultyAtom, name: '${_$matchDifficultyAtom.name}_set');
  }

  final _$playersAtom = Atom(name: '_GameState.players');

  @override
  ObservableList<Player> get players {
    _$playersAtom.context.enforceReadPolicy(_$playersAtom);
    _$playersAtom.reportObserved();
    return super.players;
  }

  @override
  set players(ObservableList<Player> value) {
    _$playersAtom.context.conditionallyRunInAction(() {
      super.players = value;
      _$playersAtom.reportChanged();
    }, _$playersAtom, name: '${_$playersAtom.name}_set');
  }

  final _$turnAtom = Atom(name: '_GameState.turn');

  @override
  int get turn {
    _$turnAtom.context.enforceReadPolicy(_$turnAtom);
    _$turnAtom.reportObserved();
    return super.turn;
  }

  @override
  set turn(int value) {
    _$turnAtom.context.conditionallyRunInAction(() {
      super.turn = value;
      _$turnAtom.reportChanged();
    }, _$turnAtom, name: '${_$turnAtom.name}_set');
  }

  final _$soundpoolAtom = Atom(name: '_GameState.soundpool');

  @override
  Soundpool get soundpool {
    _$soundpoolAtom.context.enforceReadPolicy(_$soundpoolAtom);
    _$soundpoolAtom.reportObserved();
    return super.soundpool;
  }

  @override
  set soundpool(Soundpool value) {
    _$soundpoolAtom.context.conditionallyRunInAction(() {
      super.soundpool = value;
      _$soundpoolAtom.reportChanged();
    }, _$soundpoolAtom, name: '${_$soundpoolAtom.name}_set');
  }

  final _$wordsPerPlayerAtom = Atom(name: '_GameState.wordsPerPlayer');

  @override
  int get wordsPerPlayer {
    _$wordsPerPlayerAtom.context.enforceReadPolicy(_$wordsPerPlayerAtom);
    _$wordsPerPlayerAtom.reportObserved();
    return super.wordsPerPlayer;
  }

  @override
  set wordsPerPlayer(int value) {
    _$wordsPerPlayerAtom.context.conditionallyRunInAction(() {
      super.wordsPerPlayer = value;
      _$wordsPerPlayerAtom.reportChanged();
    }, _$wordsPerPlayerAtom, name: '${_$wordsPerPlayerAtom.name}_set');
  }

  final _$timerAtom = Atom(name: '_GameState.timer');

  @override
  int get timer {
    _$timerAtom.context.enforceReadPolicy(_$timerAtom);
    _$timerAtom.reportObserved();
    return super.timer;
  }

  @override
  set timer(int value) {
    _$timerAtom.context.conditionallyRunInAction(() {
      super.timer = value;
      _$timerAtom.reportChanged();
    }, _$timerAtom, name: '${_$timerAtom.name}_set');
  }

  final _$difficultyDispersionAtom =
  Atom(name: '_GameState.difficultyDispersion');

  @override
  int get difficultyDispersion {
    _$difficultyDispersionAtom.context
        .enforceReadPolicy(_$difficultyDispersionAtom);
    _$difficultyDispersionAtom.reportObserved();
    return super.difficultyDispersion;
  }

  @override
  set difficultyDispersion(int value) {
    _$difficultyDispersionAtom.context.conditionallyRunInAction(() {
      super.difficultyDispersion = value;
      _$difficultyDispersionAtom.reportChanged();
    }, _$difficultyDispersionAtom,
        name: '${_$difficultyDispersionAtom.name}_set');
  }

  final _$wordAtom = Atom(name: '_GameState.word');

  @override
  String get word {
    _$wordAtom.context.enforceReadPolicy(_$wordAtom);
    _$wordAtom.reportObserved();
    return super.word;
  }

  @override
  set word(String value) {
    _$wordAtom.context.conditionallyRunInAction(() {
      super.word = value;
      _$wordAtom.reportChanged();
    }, _$wordAtom, name: '${_$wordAtom.name}_set');
  }

  final _$timeSpentAtom = Atom(name: '_GameState.timeSpent');

  @override
  int get timeSpent {
    _$timeSpentAtom.context.enforceReadPolicy(_$timeSpentAtom);
    _$timeSpentAtom.reportObserved();
    return super.timeSpent;
  }

  @override
  set timeSpent(int value) {
    _$timeSpentAtom.context.conditionallyRunInAction(() {
      super.timeSpent = value;
      _$timeSpentAtom.reportChanged();
    }, _$timeSpentAtom, name: '${_$timeSpentAtom.name}_set');
  }

  final _$stopwatchAtom = Atom(name: '_GameState.stopwatch');

  @override
  Stopwatch get stopwatch {
    _$stopwatchAtom.context.enforceReadPolicy(_$stopwatchAtom);
    _$stopwatchAtom.reportObserved();
    return super.stopwatch;
  }

  @override
  set stopwatch(Stopwatch value) {
    _$stopwatchAtom.context.conditionallyRunInAction(() {
      super.stopwatch = value;
      _$stopwatchAtom.reportChanged();
    }, _$stopwatchAtom, name: '${_$stopwatchAtom.name}_set');
  }

  final _$newTurnTimerAtom = Atom(name: '_GameState.newTurnTimer');

  @override
  Timer get newTurnTimer {
    _$newTurnTimerAtom.context.enforceReadPolicy(_$newTurnTimerAtom);
    _$newTurnTimerAtom.reportObserved();
    return super.newTurnTimer;
  }

  @override
  set newTurnTimer(Timer value) {
    _$newTurnTimerAtom.context.conditionallyRunInAction(() {
      super.newTurnTimer = value;
      _$newTurnTimerAtom.reportChanged();
    }, _$newTurnTimerAtom, name: '${_$newTurnTimerAtom.name}_set');
  }

  final _$soundsAtom = Atom(name: '_GameState.sounds');

  @override
  HashMap get sounds {
    _$soundsAtom.context.enforceReadPolicy(_$soundsAtom);
    _$soundsAtom.reportObserved();
    return super.sounds;
  }

  @override
  set sounds(HashMap value) {
    _$soundsAtom.context.conditionallyRunInAction(() {
      super.sounds = value;
      _$soundsAtom.reportChanged();
    }, _$soundsAtom, name: '${_$soundsAtom.name}_set');
  }

  final _$hatAtom = Atom(name: '_GameState.hat');

  @override
  Hat get hat {
    _$hatAtom.context.enforceReadPolicy(_$hatAtom);
    _$hatAtom.reportObserved();
    return super.hat;
  }

  @override
  set hat(Hat value) {
    _$hatAtom.context.conditionallyRunInAction(() {
      super.hat = value;
      _$hatAtom.reportChanged();
    }, _$hatAtom, name: '${_$hatAtom.name}_set');
  }

  final _$initSoundsAsyncAction = AsyncAction('initSounds');

  @override
  Future<void> initSounds() {
    return _$initSoundsAsyncAction.run(() => super.initSounds());
  }

  final _$_GameStateActionController = ActionController(name: '_GameState');

  @override
  void changeState(String newState) {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.changeState(newState);
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void concede() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.concede();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void guessedRight() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.guessedRight();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void error() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.error();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validateAll() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.validateAll();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newTurn() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.newTurn();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newTurnTimerSecondPass() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.newTurnTimerSecondPass();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newTurnTimerStart() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.newTurnTimerStart();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void turnStart() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.turnStart();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void timerSecondPass() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.timerSecondPass();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPlayer() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.addPlayer();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePlayer(int i) {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.removePlayer(i);
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void createHat(Dictionary dictionary) {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.createHat(dictionary);
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }
}
