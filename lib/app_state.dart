import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'deathmatch_state.dart';
import 'dictionary.dart';
import 'game_state.dart';

part 'app_state.g.dart';

class AppState = AppStateBase with _$AppState;

Future<void> syncWithServer(List<String?> args) async {
  String documentsPath = args[0]!;
  String deviceId = args[1]!;
  String host = 'the-hat.appspot.com';
  if (File('$documentsPath/gameLogs.json').existsSync()) {
    List gameLogs =
        jsonDecode(File('$documentsPath/gameLogs.json').readAsStringSync());
    Set sentLogs = {};
    for (var gameLog in gameLogs) {
      http.Response? response;
      try {
        response = await http.post(Uri.http(host, '/api/v2/game/log'),
            headers: {"content-type": "application/json"},
            body: jsonEncode(gameLog));
      } catch (_) {
        response = null;
      }
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
  if (File('$documentsPath/wordsComplains.json').existsSync()) {
    try {
      http.Response? response;
      try {
        response = await http
            .post(Uri.http(host, '/$deviceId/complain'), body: {
          "json": File('$documentsPath/wordsComplains.json').readAsStringSync()
        });
      } on SocketException catch (_) {
        response = null;
      }
      if (response != null && response.statusCode == 200) {
        File('$documentsPath/wordsComplains.json').deleteSync();
      }
    } on SocketException catch (_) {}
  }
}

abstract class AppStateBase with Store {
  @observable
  bool loading = false;

  @observable
  bool loaded = false;

  @observable
  Uuid uuid = const Uuid();

  @observable
  String? deviceId;

  @observable
  GameState? gameState;

  @observable
  DeathmatchState? deathmatchState;

  @observable
  SharedPreferences? prefs;

  @observable
  Dictionary? dictionary;

  @observable
  String? documentsPath;

  @observable
  bool syncing = false;

  @action
  Future<void> loadApp() async {
    if (!loaded && !loading) {
      loading = true;
      prefs = await SharedPreferences.getInstance();
      if (prefs!.getInt('matchDifficulty') == null) {
        restoreDefaultSettings();
      }
      final directory = await getApplicationDocumentsDirectory();
      documentsPath = directory.path;
      dictionary = Dictionary(prefs!, documentsPath!);
      await dictionary!.load();
      if (prefs!.getString('deviceId') == null) {
        deviceId = uuid.v4();
        prefs!.setString('deviceId', deviceId!);
      } else {
        deviceId = prefs!.getString('deviceId')!;
      }
      Timer.periodic(const Duration(minutes: 5), (Timer timeout) {
        if (!syncing) {
          syncing = true;
          compute(syncWithServer, [documentsPath, deviceId]).then((void _) {
            syncing = false;
          });
        }
      });
      loaded = true;
    }
  }

  @action
  void restoreDefaultSettings() {
    prefs!.setInt('matchDifficulty', 30);
    prefs!.setInt('wordsPerPlayer', 10);
    prefs!.setInt('difficultyDispersion', 15);
    prefs!.setInt('lastStateLength', 3);
    prefs!.setInt('mainStateLength', 20);
    prefs!.setBool('fixTeams', false);
  }

  @action
  void newGame() {
    gameState = GameState(prefs);
  }

  @action
  void newDeathMatch() {
    deathmatchState = DeathmatchState(dictionary!);
  }
}
