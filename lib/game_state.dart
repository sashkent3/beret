import 'dart:async';

import 'package:mobx/mobx.dart';

import 'dictionary.dart';
import 'hat.dart';

part 'game_state.g.dart';

class GameState = _GameState with _$GameState;

abstract class _GameState with Store {
  @observable
  List log;

  @observable
  int matchDifficulty = 50;

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

  @computed
  String get playerTwo => players[playerTwoID];
  
  @observable
  int hatSize = 3;

  @observable
  int timer = 20;

  @observable
  List words = [];

  @observable
  int difficultyDispersion = 5;

  @observable
  String word;

  @action
  void guessedRight() {
    log.add([playerOneID, playerTwoID, word]);
    word = hat.getWord();
  }

  @action
  void newTurn() {
    word = hat.getWord();
    timerStart();
    turn++;
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

  @observable
  bool loading = false;

  @observable
  Dictionary dictionary = Dictionary();

  @action
  Future<void> loadDictionary() async {
    if (!(dictionary.loaded) && !(loading)) {
      loading = true;
      await dictionary.load();
      loading = false;
    }
  }

  @action
  void newGame() {
    turn = 0;
    log = [];
    hat = Hat(dictionary.getWords(hatSize, matchDifficulty, difficultyDispersion));
  }
}