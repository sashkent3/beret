import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dictionary.dart';
import 'game_state.dart';

part 'app_state.g.dart';

class AppState = _AppState with _$AppState;

abstract class _AppState with Store {
  @observable
  bool loading = false;

  @observable
  SharedPreferences prefs;

  @observable
  Dictionary dictionary;

  @action
  Future<void> loadApp() async {
    if (prefs == null && !loading) {
      loading = true;
      prefs = await SharedPreferences.getInstance();
      if (prefs.getInt('matchDifficulty') == null) {
        restoreDefaultSettings();
      }
    }
    dictionary = Dictionary(prefs);
    if (!dictionary.loaded && !loading) {
      loading = true;
      await dictionary.load();
    }
    loading = false;
  }

  @action
  void restoreDefaultSettings() {
    prefs.setInt('matchDifficulty', 30);
    prefs.setInt('wordsPerPlayer', 10);
    prefs.setInt('difficultyDispersion', 5);
    prefs.setInt('lastStateLength', 3);
    prefs.setInt('mainStateLength', 20);
  }

  @observable
  GameState gameState;

  @action
  void newGame() {
    gameState = GameState(prefs);
  }
}
