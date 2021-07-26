// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GameState on _GameState, Store {
  Computed<String>? _$playerOneComputed;

  @override
  String get playerOne => (_$playerOneComputed ??=
          Computed<String>(() => super.playerOne, name: '_GameState.playerOne'))
      .value;
  Computed<String>? _$playerTwoComputed;

  @override
  String get playerTwo => (_$playerTwoComputed ??=
          Computed<String>(() => super.playerTwo, name: '_GameState.playerTwo'))
      .value;

  final _$newTurnTimerCntAtom = Atom(name: '_GameState.newTurnTimerCnt');

  @override
  int get newTurnTimerCnt {
    _$newTurnTimerCntAtom.reportRead();
    return super.newTurnTimerCnt;
  }

  @override
  set newTurnTimerCnt(int value) {
    _$newTurnTimerCntAtom.reportWrite(value, super.newTurnTimerCnt, () {
      super.newTurnTimerCnt = value;
    });
  }

  final _$stateAtom = Atom(name: '_GameState.state');

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

  final _$logAtom = Atom(name: '_GameState.log');

  @override
  List<dynamic> get log {
    _$logAtom.reportRead();
    return super.log;
  }

  @override
  set log(List<dynamic> value) {
    _$logAtom.reportWrite(value, super.log, () {
      super.log = value;
    });
  }

  final _$turnLogAtom = Atom(name: '_GameState.turnLog');

  @override
  List<dynamic> get turnLog {
    _$turnLogAtom.reportRead();
    return super.turnLog;
  }

  @override
  set turnLog(List<dynamic> value) {
    _$turnLogAtom.reportWrite(value, super.turnLog, () {
      super.turnLog = value;
    });
  }

  final _$gameLogAtom = Atom(name: '_GameState.gameLog');

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

  final _$mainStateLengthAtom = Atom(name: '_GameState.mainStateLength');

  @override
  int? get mainStateLength {
    _$mainStateLengthAtom.reportRead();
    return super.mainStateLength;
  }

  @override
  set mainStateLength(int? value) {
    _$mainStateLengthAtom.reportWrite(value, super.mainStateLength, () {
      super.mainStateLength = value;
    });
  }

  final _$lastStateLengthAtom = Atom(name: '_GameState.lastStateLength');

  @override
  int? get lastStateLength {
    _$lastStateLengthAtom.reportRead();
    return super.lastStateLength;
  }

  @override
  set lastStateLength(int? value) {
    _$lastStateLengthAtom.reportWrite(value, super.lastStateLength, () {
      super.lastStateLength = value;
    });
  }

  final _$matchDifficultyAtom = Atom(name: '_GameState.matchDifficulty');

  @override
  int? get matchDifficulty {
    _$matchDifficultyAtom.reportRead();
    return super.matchDifficulty;
  }

  @override
  set matchDifficulty(int? value) {
    _$matchDifficultyAtom.reportWrite(value, super.matchDifficulty, () {
      super.matchDifficulty = value;
    });
  }

  final _$fixTeamsAtom = Atom(name: '_GameState.fixTeams');

  @override
  bool? get fixTeams {
    _$fixTeamsAtom.reportRead();
    return super.fixTeams;
  }

  @override
  set fixTeams(bool? value) {
    _$fixTeamsAtom.reportWrite(value, super.fixTeams, () {
      super.fixTeams = value;
    });
  }

  final _$playersAtom = Atom(name: '_GameState.players');

  @override
  ObservableList<Player> get players {
    _$playersAtom.reportRead();
    return super.players;
  }

  @override
  set players(ObservableList<Player> value) {
    _$playersAtom.reportWrite(value, super.players, () {
      super.players = value;
    });
  }

  final _$turnAtom = Atom(name: '_GameState.turn');

  @override
  int get turn {
    _$turnAtom.reportRead();
    return super.turn;
  }

  @override
  set turn(int value) {
    _$turnAtom.reportWrite(value, super.turn, () {
      super.turn = value;
    });
  }

  final _$audioPlayerAtom = Atom(name: '_GameState.audioPlayer');

  @override
  AudioCache get audioPlayer {
    _$audioPlayerAtom.reportRead();
    return super.audioPlayer;
  }

  @override
  set audioPlayer(AudioCache value) {
    _$audioPlayerAtom.reportWrite(value, super.audioPlayer, () {
      super.audioPlayer = value;
    });
  }

  final _$playerOneIDAtom = Atom(name: '_GameState.playerOneID');

  @override
  int get playerOneID {
    _$playerOneIDAtom.reportRead();
    return super.playerOneID;
  }

  @override
  set playerOneID(int value) {
    _$playerOneIDAtom.reportWrite(value, super.playerOneID, () {
      super.playerOneID = value;
    });
  }

  final _$playerTwoIDAtom = Atom(name: '_GameState.playerTwoID');

  @override
  int get playerTwoID {
    _$playerTwoIDAtom.reportRead();
    return super.playerTwoID;
  }

  @override
  set playerTwoID(int value) {
    _$playerTwoIDAtom.reportWrite(value, super.playerTwoID, () {
      super.playerTwoID = value;
    });
  }

  final _$wordsPerPlayerAtom = Atom(name: '_GameState.wordsPerPlayer');

  @override
  int get wordsPerPlayer {
    _$wordsPerPlayerAtom.reportRead();
    return super.wordsPerPlayer;
  }

  @override
  set wordsPerPlayer(int value) {
    _$wordsPerPlayerAtom.reportWrite(value, super.wordsPerPlayer, () {
      super.wordsPerPlayer = value;
    });
  }

  final _$timerAtom = Atom(name: '_GameState.timer');

  @override
  int? get timer {
    _$timerAtom.reportRead();
    return super.timer;
  }

  @override
  set timer(int? value) {
    _$timerAtom.reportWrite(value, super.timer, () {
      super.timer = value;
    });
  }

  final _$difficultyDispersionAtom =
      Atom(name: '_GameState.difficultyDispersion');

  @override
  int get difficultyDispersion {
    _$difficultyDispersionAtom.reportRead();
    return super.difficultyDispersion;
  }

  @override
  set difficultyDispersion(int value) {
    _$difficultyDispersionAtom.reportWrite(value, super.difficultyDispersion,
        () {
      super.difficultyDispersion = value;
    });
  }

  final _$wordAtom = Atom(name: '_GameState.word');

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

  final _$timeSpentAtom = Atom(name: '_GameState.timeSpent');

  @override
  int? get timeSpent {
    _$timeSpentAtom.reportRead();
    return super.timeSpent;
  }

  @override
  set timeSpent(int? value) {
    _$timeSpentAtom.reportWrite(value, super.timeSpent, () {
      super.timeSpent = value;
    });
  }

  final _$stopwatchAtom = Atom(name: '_GameState.stopwatch');

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

  final _$newTurnTimerAtom = Atom(name: '_GameState.newTurnTimer');

  @override
  Timer? get newTurnTimer {
    _$newTurnTimerAtom.reportRead();
    return super.newTurnTimer;
  }

  @override
  set newTurnTimer(Timer? value) {
    _$newTurnTimerAtom.reportWrite(value, super.newTurnTimer, () {
      super.newTurnTimer = value;
    });
  }

  final _$soundsAtom = Atom(name: '_GameState.sounds');

  @override
  HashMap<dynamic, dynamic>? get sounds {
    _$soundsAtom.reportRead();
    return super.sounds;
  }

  @override
  set sounds(HashMap<dynamic, dynamic>? value) {
    _$soundsAtom.reportWrite(value, super.sounds, () {
      super.sounds = value;
    });
  }

  final _$hatAtom = Atom(name: '_GameState.hat');

  @override
  Hat? get hat {
    _$hatAtom.reportRead();
    return super.hat;
  }

  @override
  set hat(Hat? value) {
    _$hatAtom.reportWrite(value, super.hat, () {
      super.hat = value;
    });
  }

  final _$_GameStateActionController = ActionController(name: '_GameState');

  @override
  int getPlayerOneId() {
    final _$actionInfo = _$_GameStateActionController.startAction(
        name: '_GameState.getPlayerOneId');
    try {
      return super.getPlayerOneId();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  int getPlayerTwoId() {
    final _$actionInfo = _$_GameStateActionController.startAction(
        name: '_GameState.getPlayerTwoId');
    try {
      return super.getPlayerTwoId();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeState(String newState) {
    final _$actionInfo = _$_GameStateActionController.startAction(
        name: '_GameState.changeState');
    try {
      return super.changeState(newState);
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void concede() {
    final _$actionInfo =
        _$_GameStateActionController.startAction(name: '_GameState.concede');
    try {
      return super.concede();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void guessedRight() {
    final _$actionInfo = _$_GameStateActionController.startAction(
        name: '_GameState.guessedRight');
    try {
      return super.guessedRight();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void error() {
    final _$actionInfo =
        _$_GameStateActionController.startAction(name: '_GameState.error');
    try {
      return super.error();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validateAll() {
    final _$actionInfo = _$_GameStateActionController.startAction(
        name: '_GameState.validateAll');
    try {
      return super.validateAll();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newTurn() {
    final _$actionInfo =
        _$_GameStateActionController.startAction(name: '_GameState.newTurn');
    try {
      return super.newTurn();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newTurnTimerSecondPass() {
    final _$actionInfo = _$_GameStateActionController.startAction(
        name: '_GameState.newTurnTimerSecondPass');
    try {
      return super.newTurnTimerSecondPass();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newTurnTimerStart() {
    final _$actionInfo = _$_GameStateActionController.startAction(
        name: '_GameState.newTurnTimerStart');
    try {
      return super.newTurnTimerStart();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void turnStart() {
    final _$actionInfo =
        _$_GameStateActionController.startAction(name: '_GameState.turnStart');
    try {
      return super.turnStart();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void timerSecondPass() {
    final _$actionInfo = _$_GameStateActionController.startAction(
        name: '_GameState.timerSecondPass');
    try {
      return super.timerSecondPass();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPlayer() {
    final _$actionInfo =
        _$_GameStateActionController.startAction(name: '_GameState.addPlayer');
    try {
      return super.addPlayer();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePlayer(int i) {
    final _$actionInfo = _$_GameStateActionController.startAction(
        name: '_GameState.removePlayer');
    try {
      return super.removePlayer(i);
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void createHat(Dictionary dictionary) {
    final _$actionInfo =
        _$_GameStateActionController.startAction(name: '_GameState.createHat');
    try {
      return super.createHat(dictionary);
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
newTurnTimerCnt: ${newTurnTimerCnt},
state: ${state},
log: ${log},
turnLog: ${turnLog},
gameLog: ${gameLog},
mainStateLength: ${mainStateLength},
lastStateLength: ${lastStateLength},
matchDifficulty: ${matchDifficulty},
fixTeams: ${fixTeams},
players: ${players},
turn: ${turn},
audioPlayer: ${audioPlayer},
playerOneID: ${playerOneID},
playerTwoID: ${playerTwoID},
wordsPerPlayer: ${wordsPerPlayer},
timer: ${timer},
difficultyDispersion: ${difficultyDispersion},
word: ${word},
timeSpent: ${timeSpent},
stopwatch: ${stopwatch},
newTurnTimer: ${newTurnTimer},
sounds: ${sounds},
hat: ${hat},
playerOne: ${playerOne},
playerTwo: ${playerTwo}
    ''';
  }
}
