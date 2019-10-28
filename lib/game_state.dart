import 'dart:async';

import 'package:mobx/mobx.dart';

import 'dictionary.dart';
import 'hat.dart';

part 'game_state.g.dart';

class GameState = _GameState with _$GameState;

abstract class _GameState with Store {
  _GameState(final Dictionary dictionary) {
    hat = Hat(
        dictionary.getWords(hatSize, matchDifficulty, difficultyDispersion));
  }

  @computed
  int get playersNumber => players.length;

  @observable
  String state = 'lobby';

  @observable
  List log = [];

  @observable
  int matchDifficulty = 50;

  @observable
  List players = ['Игрок 1', 'Игрок 2'];

  @observable
  int turn = 0;

  @computed
  int get playerOneID => turn % playersNumber;

  @computed
  int get playerTwoID =>
      (1 + (turn ~/ playersNumber) % (playersNumber - 1) + turn) %
          playersNumber;

  @computed
  String get playerOne => players[playerOneID];

  @computed
  String get playerTwo => players[playerTwoID];

  @observable
  int hatSize = 4;

  @observable
  int timer = 20;

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
      log.add([playerOne, playerTwo, word, timeSpent, 0]);
    } else if (state == 'last' || state == 'verdict') {
      log.add([
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
      log.add([playerOne, playerTwo, word, timeSpent, 0, 'guessed']);
    } else if (state == 'last' || state == 'verdict') {
      log.add([
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
      log.add([playerOne, playerTwo, word, timeSpent, 0, 'failed']);
    } else if (state == 'last' || state == 'verdict') {
      log.add([
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
    if (players.length == players
        .toSet()
        .length && !players.contains('')) {
      return true;
    } else {
      return false;
    }
  }

  @action
  void newTurn() {
    word = hat.getWord();
    changeState('main');
    timerStart();
  }

  @action
  void timerStart() {
    stopwatch.start();
    Timer.periodic(Duration(seconds: 1), (Timer timeout) {
      timerSecondPass();
      if (state != 'main' && state != 'last') {
        timeout.cancel();
        timer = 20;
      } else if (timer == 0) {
        timeSpent = (stopwatch.elapsedMilliseconds / 100).round();
        stopwatch.reset();
        changeState('last');
      } else if (timer == -3) {
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
    players.add('Игрок $playersNumber');
  }

  @action
  void removePlayer(int i) {
    players.removeAt(i);
  }
}
