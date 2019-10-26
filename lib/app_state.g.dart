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

  final _$playersAtom = Atom(name: '_AppState.players');

  @override
  List get players {
    _$playersAtom.context.enforceReadPolicy(_$playersAtom);
    _$playersAtom.reportObserved();
    return super.players;
  }

  @override
  set players(List value) {
    _$playersAtom.context.conditionallyRunInAction(() {
      super.players = value;
      _$playersAtom.reportChanged();
    }, _$playersAtom, name: '${_$playersAtom.name}_set');
  }

  final _$playersNumberAtom = Atom(name: '_AppState.playersNumber');

  @override
  int get playersNumber {
    _$playersNumberAtom.context.enforceReadPolicy(_$playersNumberAtom);
    _$playersNumberAtom.reportObserved();
    return super.playersNumber;
  }

  @override
  set playersNumber(int value) {
    _$playersNumberAtom.context.conditionallyRunInAction(() {
      super.playersNumber = value;
      _$playersNumberAtom.reportChanged();
    }, _$playersNumberAtom, name: '${_$playersNumberAtom.name}_set');
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

  final _$loadDictionaryAsyncAction = AsyncAction('loadDictionary');

  @override
  Future<void> loadDictionary() {
    return _$loadDictionaryAsyncAction.run(() => super.loadDictionary());
  }

  final _$_AppStateActionController = ActionController(name: '_AppState');

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
