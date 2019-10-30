// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppState on _AppState, Store {
  final _$loadingAtom = Atom(name: '_AppState.loading');

  @override
  bool get loading {
    _$loadingAtom.context.enforceReadPolicy(_$loadingAtom);
    _$loadingAtom.reportObserved();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.context.conditionallyRunInAction(() {
      super.loading = value;
      _$loadingAtom.reportChanged();
    }, _$loadingAtom, name: '${_$loadingAtom.name}_set');
  }

  final _$prefsAtom = Atom(name: '_AppState.prefs');

  @override
  SharedPreferences get prefs {
    _$prefsAtom.context.enforceReadPolicy(_$prefsAtom);
    _$prefsAtom.reportObserved();
    return super.prefs;
  }

  @override
  set prefs(SharedPreferences value) {
    _$prefsAtom.context.conditionallyRunInAction(() {
      super.prefs = value;
      _$prefsAtom.reportChanged();
    }, _$prefsAtom, name: '${_$prefsAtom.name}_set');
  }

  final _$dictionaryAtom = Atom(name: '_AppState.dictionary');

  @override
  Dictionary get dictionary {
    _$dictionaryAtom.context.enforceReadPolicy(_$dictionaryAtom);
    _$dictionaryAtom.reportObserved();
    return super.dictionary;
  }

  @override
  set dictionary(Dictionary value) {
    _$dictionaryAtom.context.conditionallyRunInAction(() {
      super.dictionary = value;
      _$dictionaryAtom.reportChanged();
    }, _$dictionaryAtom, name: '${_$dictionaryAtom.name}_set');
  }

  final _$currentSetDifficultyAtom =
  Atom(name: '_AppState.currentSetDifficulty');

  @override
  int get currentSetDifficulty {
    _$currentSetDifficultyAtom.context
        .enforceReadPolicy(_$currentSetDifficultyAtom);
    _$currentSetDifficultyAtom.reportObserved();
    return super.currentSetDifficulty;
  }

  @override
  set currentSetDifficulty(int value) {
    _$currentSetDifficultyAtom.context.conditionallyRunInAction(() {
      super.currentSetDifficulty = value;
      _$currentSetDifficultyAtom.reportChanged();
    }, _$currentSetDifficultyAtom,
        name: '${_$currentSetDifficultyAtom.name}_set');
  }

  final _$gameStateAtom = Atom(name: '_AppState.gameState');

  @override
  GameState get gameState {
    _$gameStateAtom.context.enforceReadPolicy(_$gameStateAtom);
    _$gameStateAtom.reportObserved();
    return super.gameState;
  }

  @override
  set gameState(GameState value) {
    _$gameStateAtom.context.conditionallyRunInAction(() {
      super.gameState = value;
      _$gameStateAtom.reportChanged();
    }, _$gameStateAtom, name: '${_$gameStateAtom.name}_set');
  }

  final _$loadAppAsyncAction = AsyncAction('loadApp');

  @override
  Future<void> loadApp() {
    return _$loadAppAsyncAction.run(() => super.loadApp());
  }

  final _$_AppStateActionController = ActionController(name: '_AppState');

  @override
  void setCurrentDifficulty(int newDifficulty) {
    final _$actionInfo = _$_AppStateActionController.startAction();
    try {
      return super.setCurrentDifficulty(newDifficulty);
    } finally {
      _$_AppStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void restoreDefaultSettings() {
    final _$actionInfo = _$_AppStateActionController.startAction();
    try {
      return super.restoreDefaultSettings();
    } finally {
      _$_AppStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newGame() {
    final _$actionInfo = _$_AppStateActionController.startAction();
    try {
      return super.newGame();
    } finally {
      _$_AppStateActionController.endAction(_$actionInfo);
    }
  }
}
