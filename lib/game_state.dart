import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mobx/mobx.dart';
import 'package:normal/normal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'game_state.g.dart';

class GameState = _GameState with _$GameState;

abstract class _GameState with Store {
  @observable
  List log;

  @observable
  int matchDiff = 50;

  @observable
  int playersNumber = 4;

  @observable
  List players = ['Коля', 'Саша', 'Мама', 'Папа'];

  @observable
  List baskets = List.filled(101, [List(), 0]);

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
  int timer = 20;

  @observable
  List words = [];

  @observable
  int diffDisp = 5;

  @action
  Future<int> getUsedWordsIter () async {
    final prefs = await SharedPreferences.getInstance();
    final int usedWordsIter = prefs.getInt('usedWordsIter') ?? -1;
    if (usedWordsIter == -1) {
      prefs.setInt('usedWordsIter', 0);
      return 0;
    }
    else {
      return usedWordsIter;
    }
  }

  @action
  Future<List> getUsedWords () async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    if (!File('$path/data.json').existsSync()) {
      List usedWords = List(1000);
      new File('$path/data.json').createSync();
      File('$path/data.json').writeAsString(jsonEncode(usedWords));
      return usedWords;
    }
    else {
      final file = await File('$path/data.json').readAsString();
      List usedWords = jsonDecode(file);
      return usedWords;
    }
  }

  @action
  void refreshWords() async {
    words = [];
    await getDictionary();
    final prefs = await SharedPreferences.getInstance();
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    int usedWordsIter = await getUsedWordsIter();
    List usedWords = await getUsedWords();
    List basketsDisp = Normal.generate(hatSize);
    for (var i = 0; i < hatSize; i++) {
      var basket = baskets[(basketsDisp[i] * diffDisp + matchDiff).round()];
      int len = basket[0].length;
      while (usedWords.contains(basket[0][basket[1]])) {
        basket[1]++;
        if (basket[1] == len) {
          basket[0].shuffle();
          basket[1] = 0;
        }
      }
      words.add([basket[0][basket[1]],0]);
      usedWords[usedWordsIter] = basket[0][basket[1]];
    }
    prefs.setInt('usedWordsIter', (usedWordsIter+hatSize)%1000);
    File('$path/data.json').writeAsStringSync(jsonEncode(usedWords));
  }

  @observable
  int wordNum;

  @observable
  String word;

  @action
  void newWord() {
    wordNum = 0;
    words.shuffle();

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
    refreshWords();
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
    timer = 20;
  }

  @action
  Future<void> getDictionary() async {
    var mainDictFile = await DefaultCacheManager().getSingleFile('http://the-hat.appspot.com/api/v2/dictionary/ru');
    var mainDict = jsonDecode(mainDictFile.readAsStringSync());
    for (var i=0; i<mainDict.length; i++) {
      baskets[mainDict[i]['diff']][0].add(mainDict[i]['word']);
    }
    for (var basket in baskets) {
      basket[0].shuffle();
      basket[1] = 0;
    }
  }
}