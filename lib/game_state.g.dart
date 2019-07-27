// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

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

  final _$playersNumberAtom = Atom(name: '_GameState.playersNumber');

  @override
  int get playersNumber {
    _$playersNumberAtom.context.enforceReadPolicy(_$playersNumberAtom);
    _$playersNumberAtom.reportObserved();
    return super.playersNumber;
  }

  @override
  set playersNumber(int value) {
    _$playersNumberAtom.context.conditionallyRunInAction(() {
      super.playersNumber = value;
      _$playersNumberAtom.reportChanged();
    }, _$playersNumberAtom, name: '${_$playersNumberAtom.name}_set');
  }

  final _$playersAtom = Atom(name: '_GameState.players');

  @override
  List get players {
    _$playersAtom.context.enforceReadPolicy(_$playersAtom);
    _$playersAtom.reportObserved();
    return super.players;
  }

  @override
  set players(List value) {
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

  final _$hatSizeAtom = Atom(name: '_GameState.hatSize');

  @override
  int get hatSize {
    _$hatSizeAtom.context.enforceReadPolicy(_$hatSizeAtom);
    _$hatSizeAtom.reportObserved();
    return super.hatSize;
  }

  @override
  set hatSize(int value) {
    _$hatSizeAtom.context.conditionallyRunInAction(() {
      super.hatSize = value;
      _$hatSizeAtom.reportChanged();
    }, _$hatSizeAtom, name: '${_$hatSizeAtom.name}_set');
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

  final _$wordsAtom = Atom(name: '_GameState.words');

  @override
  List get words {
    _$wordsAtom.context.enforceReadPolicy(_$wordsAtom);
    _$wordsAtom.reportObserved();
    return super.words;
  }

  @override
  set words(List value) {
    _$wordsAtom.context.conditionallyRunInAction(() {
      super.words = value;
      _$wordsAtom.reportChanged();
    }, _$wordsAtom, name: '${_$wordsAtom.name}_set');
  }

  final _$wordNumAtom = Atom(name: '_GameState.wordNum');

  @override
  int get wordNum {
    _$wordNumAtom.context.enforceReadPolicy(_$wordNumAtom);
    _$wordNumAtom.reportObserved();
    return super.wordNum;
  }

  @override
  set wordNum(int value) {
    _$wordNumAtom.context.conditionallyRunInAction(() {
      super.wordNum = value;
      _$wordNumAtom.reportChanged();
    }, _$wordNumAtom, name: '${_$wordNumAtom.name}_set');
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

  final _$timerTickingAtom = Atom(name: '_GameState.timerTicking');

  @override
  bool get timerTicking {
    _$timerTickingAtom.context.enforceReadPolicy(_$timerTickingAtom);
    _$timerTickingAtom.reportObserved();
    return super.timerTicking;
  }

  @override
  set timerTicking(bool value) {
    _$timerTickingAtom.context.conditionallyRunInAction(() {
      super.timerTicking = value;
      _$timerTickingAtom.reportChanged();
    }, _$timerTickingAtom, name: '${_$timerTickingAtom.name}_set');
  }

  final _$_GameStateActionController = ActionController(name: '_GameState');

  @override
  void newWord() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.newWord();
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
  void newTurn() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.newTurn();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void refresh() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.refresh();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void timerStart() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.timerStart();
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
  void resetTimer() {
    final _$actionInfo = _$_GameStateActionController.startAction();
    try {
      return super.resetTimer();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }
}
