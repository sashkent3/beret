import 'dart:async';

import 'package:mobx/mobx.dart';

import 'dictionary.dart';
import 'hat.dart';

part 'game_state.g.dart';

class GameState = _GameState with _$GameState;

abstract class _GameState with Store {
  _GameState(final Dictionary dictionary) {
    hat = Hat(dictionary.getWords(hatSize, matchDifficulty, difficultyDispersion));
  }

  @observable
  String state = 'lobby';

  @observable
  List log = [];

  @observable
  int matchDifficulty = 50;

  @observable
  int playersNumber = 2;

  @observable
  List players = ['Первый игрок', 'Второй игрок'];

  @observable
  int turn = 0;
  
  @computed
  int get playerOneID => turn % playersNumber;

  @computed
  int get playerTwoID => (1 + (turn ~/ playersNumber) % (playersNumber - 1) + turn) % playersNumber;
  
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
    }
    else if (state == 'last') {
      log.add([
        playerOne,
        playerTwo,
        word,
        timeSpent,
        (stopwatch.elapsedMilliseconds / 100).round()
      ]);
    }
    hat.putWord(word);
    resetTimer();
    changeState('lobby');
  }

  @action
  void guessedRight() {
    if (state == 'main') {
      timeSpent = (stopwatch.elapsedMilliseconds / 100).round();
      log.add([playerOne, playerTwo, word, timeSpent, 0, 'guessed']);
    }
    else if (state == 'last') {
      log.add([
        playerOne,
        playerTwo,
        word,
        timeSpent,
        (stopwatch.elapsedMilliseconds / 100).round(),
        'guessed'
      ]);
    }
    if (hat.isEmpty() || state == 'last') {
      stopwatch.stop();
      stopwatch.reset();
      changeState('end');
    }
    else {
      word = hat.getWord();
    }
    stopwatch.reset();
  }

  @action
  void error() {
    resetTimer();
    if (state == 'main') {
      timeSpent = (stopwatch.elapsedMilliseconds / 100).round();
      log.add([playerOne, playerTwo, word, timeSpent, 0, 'failed']);
    }
    else if (state == 'last') {
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
    if (hat.isEmpty()) {
      changeState('end');
    }
    else {
      changeState('lobby');
    }
  }

  @action
  void newTurn() {
    word = hat.getWord();
    changeState('main');
    timerStart();
    turn++;
  }

  @action
  void timerStart() {
    timerTicking = true;
    stopwatch.start();
    Timer.periodic(Duration(seconds: 1), (Timer timeout) {
      timerSecondPass();
      if (timer == 0) {
        timeSpent = (stopwatch.elapsedMilliseconds / 100).round();
        stopwatch.reset();
        changeState('last');
      }
      else if (timer == -3) {
        changeState('verdict');
        stopwatch.stop();
        resetTimer();
      }
      if (!timerTicking) {
        timeout.cancel();
      }
    });
  }

  @observable
  bool timerTicking = false;

  @observable
  Hat hat;

  @action
  void timerSecondPass() {
    timer--;
  }

  @action
  void resetTimer() {
    timerTicking = false;
    timer = 20;
  }
}