// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GameState on GameStateBase, Store {
  Computed<String>? _$playerOneComputed;

  @override
  String get playerOne =>
      (_$playerOneComputed ??= Computed<String>(() => super.playerOne,
              name: 'GameStateBase.playerOne'))
          .value;
  Computed<String>? _$playerTwoComputed;

  @override
  String get playerTwo =>
      (_$playerTwoComputed ??= Computed<String>(() => super.playerTwo,
              name: 'GameStateBase.playerTwo'))
          .value;

  late final _$newTurnTimerCntAtom =
      Atom(name: 'GameStateBase.newTurnTimerCnt', context: context);

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

  late final _$stateAtom = Atom(name: 'GameStateBase.state', context: context);

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

  late final _$logAtom = Atom(name: 'GameStateBase.log', context: context);

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

  late final _$turnLogAtom =
      Atom(name: 'GameStateBase.turnLog', context: context);

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

  late final _$gameLogAtom =
      Atom(name: 'GameStateBase.gameLog', context: context);

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

  late final _$mainStateLengthAtom =
      Atom(name: 'GameStateBase.mainStateLength', context: context);

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

  late final _$lastStateLengthAtom =
      Atom(name: 'GameStateBase.lastStateLength', context: context);

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

  late final _$matchDifficultyAtom =
      Atom(name: 'GameStateBase.matchDifficulty', context: context);

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

  late final _$fixTeamsAtom =
      Atom(name: 'GameStateBase.fixTeams', context: context);

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

  late final _$playersAtom =
      Atom(name: 'GameStateBase.players', context: context);

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

  late final _$turnAtom = Atom(name: 'GameStateBase.turn', context: context);

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

  late final _$audioPlayerAtom =
      Atom(name: 'GameStateBase.audioPlayer', context: context);

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

  late final _$playerOneIDAtom =
      Atom(name: 'GameStateBase.playerOneID', context: context);

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

  late final _$playerTwoIDAtom =
      Atom(name: 'GameStateBase.playerTwoID', context: context);

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

  late final _$wordsPerPlayerAtom =
      Atom(name: 'GameStateBase.wordsPerPlayer', context: context);

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

  late final _$timerAtom = Atom(name: 'GameStateBase.timer', context: context);

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

  late final _$difficultyDispersionAtom =
      Atom(name: 'GameStateBase.difficultyDispersion', context: context);

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

  late final _$wordAtom = Atom(name: 'GameStateBase.word', context: context);

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

  late final _$timeSpentAtom =
      Atom(name: 'GameStateBase.timeSpent', context: context);

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

  late final _$stopwatchAtom =
      Atom(name: 'GameStateBase.stopwatch', context: context);

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

  late final _$newTurnTimerAtom =
      Atom(name: 'GameStateBase.newTurnTimer', context: context);

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

  late final _$soundsAtom =
      Atom(name: 'GameStateBase.sounds', context: context);

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

  late final _$hatAtom = Atom(name: 'GameStateBase.hat', context: context);

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

  late final _$GameStateBaseActionController =
      ActionController(name: 'GameStateBase', context: context);

  @override
  int getPlayerOneId() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.getPlayerOneId');
    try {
      return super.getPlayerOneId();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  int getPlayerTwoId() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.getPlayerTwoId');
    try {
      return super.getPlayerTwoId();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeState(String newState) {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.changeState');
    try {
      return super.changeState(newState);
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void concede() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.concede');
    try {
      return super.concede();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void guessedRight() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.guessedRight');
    try {
      return super.guessedRight();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void error() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.error');
    try {
      return super.error();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validateAll() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.validateAll');
    try {
      return super.validateAll();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newTurn() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.newTurn');
    try {
      return super.newTurn();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newTurnTimerSecondPass() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.newTurnTimerSecondPass');
    try {
      return super.newTurnTimerSecondPass();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newTurnTimerStart() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.newTurnTimerStart');
    try {
      return super.newTurnTimerStart();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void turnStart() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.turnStart');
    try {
      return super.turnStart();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void timerSecondPass() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.timerSecondPass');
    try {
      return super.timerSecondPass();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPlayer() {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.addPlayer');
    try {
      return super.addPlayer();
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePlayer(int i) {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.removePlayer');
    try {
      return super.removePlayer(i);
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void createHat(Dictionary dictionary) {
    final _$actionInfo = _$GameStateBaseActionController.startAction(
        name: 'GameStateBase.createHat');
    try {
      return super.createHat(dictionary);
    } finally {
      _$GameStateBaseActionController.endAction(_$actionInfo);
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
