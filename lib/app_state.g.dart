// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppState on _AppState, Store {
  final _$loadedAtom = Atom(name: '_AppState.loaded');

  @override
  bool get loaded {
    _$loadedAtom.context.enforceReadPolicy(_$loadedAtom);
    _$loadedAtom.reportObserved();
    return super.loaded;
  }

  @override
  set loaded(bool value) {
    _$loadedAtom.context.conditionallyRunInAction(() {
      super.loaded = value;
      _$loadedAtom.reportChanged();
    }, _$loadedAtom, name: '${_$loadedAtom.name}_set');
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

  final _$documentsPathAtom = Atom(name: '_AppState.documentsPath');

  @override
  String get documentsPath {
    _$documentsPathAtom.context.enforceReadPolicy(_$documentsPathAtom);
    _$documentsPathAtom.reportObserved();
    return super.documentsPath;
  }

  @override
  set documentsPath(String value) {
    _$documentsPathAtom.context.conditionallyRunInAction(() {
      super.documentsPath = value;
      _$documentsPathAtom.reportChanged();
    }, _$documentsPathAtom, name: '${_$documentsPathAtom.name}_set');
  }

  final _$sendGameLogAsyncAction = AsyncAction('sendGameLog');

  @override
  Future sendGameLog(dynamic gameLog) {
    return _$sendGameLogAsyncAction.run(() => super.sendGameLog(gameLog));
  }

  final _$sendSavedGameLogsAsyncAction = AsyncAction('sendSavedGameLogs');

  @override
  Future<void> sendSavedGameLogs() {
    return _$sendSavedGameLogsAsyncAction.run(() => super.sendSavedGameLogs());
  }

  final _$loadAppAsyncAction = AsyncAction('loadApp');

  @override
  Future<void> loadApp() {
    return _$loadAppAsyncAction.run(() => super.loadApp());
  }

  final _$_AppStateActionController = ActionController(name: '_AppState');

  @override
  void saveGameLog(dynamic gameLog) {
    final _$actionInfo = _$_AppStateActionController.startAction();
    try {
      return super.saveGameLog(gameLog);
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
