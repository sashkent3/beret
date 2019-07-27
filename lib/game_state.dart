import 'package:mobx/mobx.dart';
import 'dart:async';

part 'game_state.g.dart';

class GameState = _GameState with _$GameState;

abstract class _GameState with Store {
  @observable
  List log;

  @observable
  int playersNumber = 4;

  @observable
  List players = ['Коля', 'Саша', 'Мама', 'Папа'];

  @observable
  int turn = 0;
  
  @computed
  int get playerOneID => turn % playersNumber;

  @computed
  int get playerTwoID => (1 + (turn ~/ playersNumber) % (playersNumber - 1) + turn) % playersNumber;
  
  @computed
  String get playerOne => players[playerOneID];

  @observable
  String get playerTwo => players[playerTwoID];
  
  @observable
  int hatSize = 3;

  @observable
  int timer = 21;

  @observable
  List words = [['кот', 0], ['яблоко', 0], ['интернет', 0]];

  @observable
  int wordNum;

  @observable
  String word;

  @action
  void newWord() {
    wordNum = 0;
    words.shuffle();
    while(wordNum != hatSize && words[wordNum][1] == 1) {
      wordNum++;
    }
    if (wordNum != hatSize) {
      word = words[wordNum][0];
    }
  }

  @action
  void guessedRight() {
    log.add([playerOneID, playerTwoID, words[wordNum][0]]);
    words[wordNum][1] = 1;
    newWord();
  }

  @action
  void newTurn() {
    turn++;
    newWord();
  }

  @action
  void refresh() {
    words = [['кот', 0], ['яблоко', 0], ['интернет', 0]];
    turn = 0;
    log = [];
  }

  @action
  void timerStart() {
    timerTicking = true;
    Timer.periodic(Duration(seconds: 1), (Timer timeout) {
      timerSecondPass();
      if(timer == 1) {
        resetTimer();
        timeout.cancel();
      }
    });
  }

  @observable
  bool timerTicking = false;

  @action
  void timerSecondPass() {
    timer--;
  }

  @action
  void resetTimer() {
    timerTicking = false;
    timer = 21;
  }
}