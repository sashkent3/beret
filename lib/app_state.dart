import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dictionary.dart';
import 'game_state.dart';

part 'app_state.g.dart';

class AppState = _AppState with _$AppState;

abstract class _AppState with Store {
  @observable
  bool loading = false;

  @action
  void saveGameLog(gameLog) {
    if (!File('$documentsPath/gameLogs.json').existsSync()) {
      List gameLogs = [gameLog];
      File('$documentsPath/gameLogs.json').createSync();
      File('$documentsPath/gameLogs.json')
          .writeAsStringSync(jsonEncode(gameLogs));
    } else {
      List gameLogs = jsonDecode(File('$documentsPath/gameLogs.json')
          .readAsStringSync());
      gameLogs.add(gameLog);
      File('$documentsPath/gameLogs.json')
          .writeAsStringSync(jsonEncode(gameLogs));
    }
  }

  @action
  Future sendGameLog(gameLog) async {
    return http.post('http://the-hat-dev.appspot.com/api/v2/game/log',
        body: {'version': '2.0', 'attempts': jsonEncode(gameLog)});
  }

  @action
  Future<void> sendSavedGameLogs() async {
    if (File('$documentsPath/gameLogs.json').existsSync()) {
      List gameLogs = jsonDecode(
          File('$documentsPath/gameLogs.json').readAsStringSync());
      for (var gameLog in gameLogs) {
        var response = await sendGameLog(gameLog);
        if (response.statusCode == 202) {
          gameLogs.remove(gameLog);
        }
      }
      if (gameLogs.isEmpty)
        File('$documentsPath/gameLogs.json').deleteSync();
      else {
        File('$documentsPath/gameLogs.json').writeAsStringSync(
            jsonEncode(gameLogs));
      }
    }
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
    if (!loading) {
      loading = true;
      if (prefs == null) {
        prefs = await SharedPreferences.getInstance();
        if (prefs.getInt('matchDifficulty') == null) {
          restoreDefaultSettings();
        }
      }
      if (documentsPath == null) {
        loading = true;
        final directory = await getApplicationDocumentsDirectory();
        documentsPath = directory.path;
      }
      await sendSavedGameLogs();
      if (dictionary == null) {
        dictionary = Dictionary(prefs, documentsPath);
      }
      if (!dictionary.loaded) {
        loading = true;
        await dictionary.load();
      }
      loading = false;
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
