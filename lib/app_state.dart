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
  GameState gameState;

  @observable
  SharedPreferences prefs;

  @observable
  Dictionary dictionary;

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
      dictionary = Dictionary(prefs);
      if (!dictionary.loaded) {
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
  }

  @action
  void newGame() {
    gameState = GameState(prefs);
  }
}
