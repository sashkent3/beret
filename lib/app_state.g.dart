// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppState on _AppState, Store {
  final _$loadingAtom = Atom(name: '_AppState.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$loadedAtom = Atom(name: '_AppState.loaded');

  @override
  bool get loaded {
    _$loadedAtom.reportRead();
    return super.loaded;
  }

  @override
  set loaded(bool value) {
    _$loadedAtom.reportWrite(value, super.loaded, () {
      super.loaded = value;
    });
  }

  final _$uuidAtom = Atom(name: '_AppState.uuid');

  @override
  Uuid get uuid {
    _$uuidAtom.reportRead();
    return super.uuid;
  }

  @override
  set uuid(Uuid value) {
    _$uuidAtom.reportWrite(value, super.uuid, () {
      super.uuid = value;
    });
  }

  final _$deviceIdAtom = Atom(name: '_AppState.deviceId');

  @override
  String? get deviceId {
    _$deviceIdAtom.reportRead();
    return super.deviceId;
  }

  @override
  set deviceId(String? value) {
    _$deviceIdAtom.reportWrite(value, super.deviceId, () {
      super.deviceId = value;
    });
  }

  final _$gameStateAtom = Atom(name: '_AppState.gameState');

  @override
  GameState? get gameState {
    _$gameStateAtom.reportRead();
    return super.gameState;
  }

  @override
  set gameState(GameState? value) {
    _$gameStateAtom.reportWrite(value, super.gameState, () {
      super.gameState = value;
    });
  }

  final _$deathmatchStateAtom = Atom(name: '_AppState.deathmatchState');

  @override
  DeathmatchState? get deathmatchState {
    _$deathmatchStateAtom.reportRead();
    return super.deathmatchState;
  }

  @override
  set deathmatchState(DeathmatchState? value) {
    _$deathmatchStateAtom.reportWrite(value, super.deathmatchState, () {
      super.deathmatchState = value;
    });
  }

  final _$prefsAtom = Atom(name: '_AppState.prefs');

  @override
  SharedPreferences? get prefs {
    _$prefsAtom.reportRead();
    return super.prefs;
  }

  @override
  set prefs(SharedPreferences? value) {
    _$prefsAtom.reportWrite(value, super.prefs, () {
      super.prefs = value;
    });
  }

  final _$dictionaryAtom = Atom(name: '_AppState.dictionary');

  @override
  Dictionary? get dictionary {
    _$dictionaryAtom.reportRead();
    return super.dictionary;
  }

  @override
  set dictionary(Dictionary? value) {
    _$dictionaryAtom.reportWrite(value, super.dictionary, () {
      super.dictionary = value;
    });
  }

  final _$documentsPathAtom = Atom(name: '_AppState.documentsPath');

  @override
  String? get documentsPath {
    _$documentsPathAtom.reportRead();
    return super.documentsPath;
  }

  @override
  set documentsPath(String? value) {
    _$documentsPathAtom.reportWrite(value, super.documentsPath, () {
      super.documentsPath = value;
    });
  }

  final _$syncingAtom = Atom(name: '_AppState.syncing');

  @override
  bool get syncing {
    _$syncingAtom.reportRead();
    return super.syncing;
  }

  @override
  set syncing(bool value) {
    _$syncingAtom.reportWrite(value, super.syncing, () {
      super.syncing = value;
    });
  }

  final _$loadAppAsyncAction = AsyncAction('_AppState.loadApp');

  @override
  Future<void> loadApp() {
    return _$loadAppAsyncAction.run(() => super.loadApp());
  }

  final _$_AppStateActionController = ActionController(name: '_AppState');

  @override
  void restoreDefaultSettings() {
    final _$actionInfo = _$_AppStateActionController.startAction(
        name: '_AppState.restoreDefaultSettings');
    try {
      return super.restoreDefaultSettings();
    } finally {
      _$_AppStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newGame() {
    final _$actionInfo =
        _$_AppStateActionController.startAction(name: '_AppState.newGame');
    try {
      return super.newGame();
    } finally {
      _$_AppStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newDeathMatch() {
    final _$actionInfo = _$_AppStateActionController.startAction(
        name: '_AppState.newDeathMatch');
    try {
      return super.newDeathMatch();
    } finally {
      _$_AppStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
loaded: ${loaded},
uuid: ${uuid},
deviceId: ${deviceId},
gameState: ${gameState},
deathmatchState: ${deathmatchState},
prefs: ${prefs},
dictionary: ${dictionary},
documentsPath: ${documentsPath},
syncing: ${syncing}
    ''';
  }
}
