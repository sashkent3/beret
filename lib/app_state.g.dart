// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppState on AppStateBase, Store {
  late final _$loadingAtom =
      Atom(name: 'AppStateBase.loading', context: context);

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

  late final _$loadedAtom = Atom(name: 'AppStateBase.loaded', context: context);

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

  late final _$uuidAtom = Atom(name: 'AppStateBase.uuid', context: context);

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

  late final _$deviceIdAtom =
      Atom(name: 'AppStateBase.deviceId', context: context);

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

  late final _$gameStateAtom =
      Atom(name: 'AppStateBase.gameState', context: context);

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

  late final _$deathmatchStateAtom =
      Atom(name: 'AppStateBase.deathmatchState', context: context);

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

  late final _$prefsAtom = Atom(name: 'AppStateBase.prefs', context: context);

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

  late final _$dictionaryAtom =
      Atom(name: 'AppStateBase.dictionary', context: context);

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

  late final _$documentsPathAtom =
      Atom(name: 'AppStateBase.documentsPath', context: context);

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

  late final _$syncingAtom =
      Atom(name: 'AppStateBase.syncing', context: context);

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

  late final _$loadAppAsyncAction =
      AsyncAction('AppStateBase.loadApp', context: context);

  @override
  Future<void> loadApp() {
    return _$loadAppAsyncAction.run(() => super.loadApp());
  }

  late final _$AppStateBaseActionController =
      ActionController(name: 'AppStateBase', context: context);

  @override
  void restoreDefaultSettings() {
    final _$actionInfo = _$AppStateBaseActionController.startAction(
        name: 'AppStateBase.restoreDefaultSettings');
    try {
      return super.restoreDefaultSettings();
    } finally {
      _$AppStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newGame() {
    final _$actionInfo = _$AppStateBaseActionController.startAction(
        name: 'AppStateBase.newGame');
    try {
      return super.newGame();
    } finally {
      _$AppStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newDeathMatch() {
    final _$actionInfo = _$AppStateBaseActionController.startAction(
        name: 'AppStateBase.newDeathMatch');
    try {
      return super.newDeathMatch();
    } finally {
      _$AppStateBaseActionController.endAction(_$actionInfo);
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
