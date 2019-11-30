import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'dictionary.dart';
import 'game_state.dart';

part 'app_state.g.dart';

class AppState = _AppState with _$AppState;

abstract class _AppState with Store {
  @observable
  bool loaded = false;

  @observable
  Uuid uuid = Uuid();

  @observable
  String deviceId;

  @action
  void saveGameLog(gameLog) {
    if (!File('$documentsPath/gameLogs.json').existsSync()) {
      List gameLogs = [gameLog];
      File('$documentsPath/gameLogs.json').createSync();
      File('$documentsPath/gameLogs.json')
          .writeAsStringSync(jsonEncode(gameLogs));
    } else {
      List gameLogs =
      jsonDecode(File('$documentsPath/gameLogs.json').readAsStringSync());
      gameLogs.add(gameLog);
      File('$documentsPath/gameLogs.json')
          .writeAsStringSync(jsonEncode(gameLogs));
    }
  }

  @action
  Future sendGameLog(gameLog) async {
    String url = 'http://the-hat-dev.appspot.com/';
    try {
      return await http.post('$url/api/v2/game/log',
          headers: {"content-type": "application/json"},
          body: jsonEncode(gameLog));
    } catch (_) {
      return null;
    }
  }

  @action
  Future<void> sendSavedGameLogs() async {
    if (File('$documentsPath/gameLogs.json').existsSync()) {
      List gameLogs =
      jsonDecode(File('$documentsPath/gameLogs.json').readAsStringSync());
      Set sentLogs = Set();
      for (var gameLog in gameLogs) {
        var response = await sendGameLog(gameLog);
        if (response != null && response.statusCode == 202) {
          sentLogs.add(gameLog);
        }
      }
      for (var gameLog in sentLogs) {
        gameLogs.remove(gameLog);
      }
      if (gameLogs.isEmpty) {
        File('$documentsPath/gameLogs.json').deleteSync();
      } else {
        File('$documentsPath/gameLogs.json')
            .writeAsStringSync(jsonEncode(gameLogs));
      }
    }
  }

  @action
  Future sendWordComplain(wordComplain) async {
    String url = 'http://the-hat-dev.appspot.com/';
    try {
      return await http.post('$url/$deviceId/complain',
          body: {"json": wordComplain});
    } on SocketException catch (_) {
      return null;
    }
  }

  @action
  Future<void> sendSavedWordsComplains() async {
    if (File('$documentsPath/wordsComplains.json').existsSync()) {
      try {
        var response = await sendWordComplain(
            File('$documentsPath/wordsComplains.json').readAsStringSync());
        if (response.statusCode == 200)
          File('$documentsPath/wordsComplains.json').deleteSync();
      } on SocketException catch (_) {}
    }
  }

  @action
  void saveWordComplain(wordComplain) {
    List savedWordsComplains;
    if (File('$documentsPath/wordsComplains.json').existsSync()) {
      savedWordsComplains = jsonDecode(
          File('$documentsPath/wordsComplains.json').readAsStringSync());
    } else {
      savedWordsComplains = List();
    }
    savedWordsComplains.add(wordComplain);
    File('$documentsPath/wordsComplains.json')
        .writeAsStringSync(jsonEncode(savedWordsComplains));
  }

  @observable
  GameState gameState;

  @observable
  SharedPreferences prefs;

  @observable
  Dictionary dictionary;

  @observable
  String documentsPath;

  @action
  Future<void> loadApp() async {
    if (!loaded) {
      prefs = await SharedPreferences.getInstance();
      if (prefs.getInt('matchDifficulty') == null) {
        restoreDefaultSettings();
      }
      final directory = await getApplicationDocumentsDirectory();
      documentsPath = directory.path;
      await sendSavedGameLogs();
      dictionary = Dictionary(prefs, documentsPath);
      await dictionary.load();
      if (prefs.getString('deviceId') == null) {
        deviceId = uuid.v4();
        prefs.setString('deviceId', deviceId);
      } else {
        deviceId = prefs.getString('deviceId');
      }
      await sendSavedWordsComplains();
      loaded = true;
    }
  }

  @action
  void restoreDefaultSettings() {
    prefs.setInt('matchDifficulty', 30);
    prefs.setInt('wordsPerPlayer', 10);
    prefs.setInt('difficultyDispersion', 15);
    prefs.setInt('lastStateLength', 3);
    prefs.setInt('mainStateLength', 20);
    prefs.setBool('fixTeams', false);
  }

  @action
  void newGame() {
    gameState = GameState(prefs);
  }
}
