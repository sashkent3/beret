import 'package:mobx/mobx.dart';

import 'dictionary.dart';
import 'game_state.dart';

part 'app_state.g.dart';

class AppState = _AppState with _$AppState;

abstract class _AppState with Store {
  @observable
  bool loading = false;

  @observable
  Dictionary dictionary = Dictionary();

  @action
  Future<void> loadDictionary() async {
    if (!dictionary.loaded && !loading) {
      loading = true;
      await dictionary.load();
      loading = false;
    }
  }

  @observable
  GameState gameState;

  @action
  void newGame() {
    gameState = GameState();
  }
}
