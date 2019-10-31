import 'dart:async';
import 'dart:collection';

import 'package:mobx/mobx.dart';

import 'dictionary.dart';
import 'hat.dart';
import 'player.dart';

part 'game_state.g.dart';

class GameState = _GameState with _$GameState;

abstract class _GameState with Store {
  _GameState(prefs) {
    matchDifficulty = prefs.getInt('matchDifficulty');
    wordsPerPlayer = prefs.getInt('wordsPerPlayer');
    difficultyDispersion = prefs.getInt('difficultyDispersion');
    lastStateLength = prefs.getInt('lastStateLength');
    mainStateLength = prefs.getInt('mainStateLength');
  }

  @observable
  String state = 'start';

  @observable
  List log = [];

  @observable
  List turnLog = [];

  @observable
  int mainStateLength = 20;

  @observable
  int lastStateLength = 3;

  @observable
  int matchDifficulty = 50;

  @observable
  ObservableList<Player> players =
  ObservableList.of([Player('Игрок 1'), Player('Игрок 2')]);

  @observable
  int turn = 0;

  @computed
  int get playerOneID => turn % players.length;

  @computed
  int get playerTwoID =>
      (1 + (turn ~/ players.length) % (players.length - 1) + turn) %
          players.length;

  @computed
  String get playerOne => players[playerOneID].name;

  @computed
  String get playerTwo => players[playerTwoID].name;

  @observable
  int wordsPerPlayer = 10;

  @observable
  int timer;

  @observable
  int difficultyDispersion = 5;

  @observable
  String word;

  @observable
  int timeSpent;

  @observable
  Stopwatch stopwatch = Stopwatch();

  @action
  void changeState(String newState) {
    state = newState;
  }

  @action
  void concede() {
    if (state == 'main') {
      timeSpent = (stopwatch.elapsedMilliseconds / 100).round();
      turnLog.add([playerOne, playerTwo, word, timeSpent, 0]);
    } else if (state == 'last' || state == 'verdict') {
      turnLog.add([
        playerOne,
        playerTwo,
        word,
        timeSpent,
        (stopwatch.elapsedMilliseconds / 100).round()
      ]);
    }
    hat.putWord(word);
    turn++;
    changeState('lobby');
  }

  @action
  void guessedRight() {
    if (state == 'main') {
      timeSpent = (stopwatch.elapsedMilliseconds / 100).round();
      turnLog.add([playerOne, playerTwo, word, timeSpent, 0, 'guessed']);
    } else if (state == 'last' || state == 'verdict') {
      turnLog.add([
        playerOne,
        playerTwo,
        word,
        timeSpent,
        (stopwatch.elapsedMilliseconds / 100).round(),
        'guessed'
      ]);
    }
    if (hat.isEmpty()) {
      stopwatch.stop();
      changeState('end');
    } else if (state == 'last' || state == 'verdict') {
      stopwatch.stop();
      turn++;
      changeState('lobby');
    } else {
      word = hat.getWord();
    }
    stopwatch.reset();
  }

  @action
  void error() {
    if (state == 'main') {
      timeSpent = (stopwatch.elapsedMilliseconds / 100).round();
      turnLog.add([playerOne, playerTwo, word, timeSpent, 0, 'failed']);
    } else if (state == 'last' || state == 'verdict') {
      turnLog.add([
        playerOne,
        playerTwo,
        word,
        timeSpent,
        (stopwatch.elapsedMilliseconds / 100).round(),
        'failed'
      ]);
    }
    stopwatch.stop();
    stopwatch.reset();
    turn++;
    if (hat.isEmpty()) {
      changeState('end');
    } else {
      changeState('lobby');
    }
  }

  @action
  bool validateAll() {
    HashSet validationSet = HashSet.of(players.map((player) => player.name));
    if (validationSet.contains('') || validationSet.length != players.length) {
      return false;
    }
    return true;
  }

  @action
  void newTurn() {
    word = hat.getWord();
    changeState('main');
    turnStart();
  }

  @action
  void turnStart() {
    stopwatch.start();
    turnLog = [];
    Timer.periodic(Duration(seconds: 1), (Timer timeout) {
      timerSecondPass();
      if (state != 'main' && state != 'last') {
        timeout.cancel();
        timer = mainStateLength;
      } else if (timer == 0) {
        timeSpent = (stopwatch.elapsedMilliseconds / 100).round();
        stopwatch.reset();
        changeState('last');
      }
      if (timer == -lastStateLength) {
        changeState('verdict');
        stopwatch.stop();
      }
    });
  }

  @observable
  Hat hat;

  @action
  void timerSecondPass() {
    timer--;
  }

  @action
  void addPlayer() {
    players.add(Player('Игрок ${players.length + 1}'));
  }

  @action
  void removePlayer(int i) {
    players.removeAt(i);
  }

  @action
  void createHat(Dictionary dictionary) {
    hat = Hat(dictionary.getWords(wordsPerPlayer * players.length,
        matchDifficulty, difficultyDispersion));
  }
}
