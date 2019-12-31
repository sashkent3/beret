import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';

import 'app_state.dart';
import 'game_history.dart';
import 'info.dart';
import 'match.dart';
import 'settings.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

void main() {
  final SentryClient sentry = SentryClient(
      dsn: 'https://ff1c3969e7fc468ab6a30f857208faa3@sentry.io/1863108');
  Future<void> _reportError(dynamic error, dynamic stackTrace) async {
    print('Caught error: $error');
    if (isInDebugMode) {
      print(stackTrace);
      return;
    } else {
      sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  runZoned(
        () async {
      runApp(Provider<AppState>(
          create: (_) => AppState(),
          child: MaterialApp(title: 'Шляпа', home: MyApp())));
    },
    onError: (Object error, StackTrace stackTrace) {
      _reportError(error, stackTrace);
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    currentState.loadApp();
    return Scaffold(
        appBar: AppBar(title: Text('Шляпа')),
        body: Padding(
            padding: EdgeInsets.all(12),
            child: Observer(builder: (_) {
              if (currentState.loaded) {
                return Center(
                    child: Table(children: [
                      TableRow(children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 6, 6),
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: RaisedButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      currentState.newGame();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Match()),
                                      );
                                    },
                                    child: Text(
                                      'Быстрая игра',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 25),
                                    )))),
                        Padding(
                            padding: EdgeInsets.fromLTRB(6, 0, 0, 6),
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: RaisedButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Settings(
                                                    currentSetDifficulty: currentState
                                                        .prefs
                                                        .getInt(
                                                        'matchDifficulty'),
                                                    currentSetDifficultyDispersion:
                                                currentState.prefs.getInt(
                                                    'difficultyDispersion'),
                                                    currentSetFixTeams: currentState
                                                        .prefs
                                                        .getBool('fixTeams'))),
                                      );
                                    },
                                    child: Text('Настройки',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 25)))))
                      ]),
                      TableRow(children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 6, 6, 0),
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: RaisedButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GameHistory()));
                                    },
                                    child: Text(
                                      'История игр',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 25),
                                    )))),
                        Padding(
                            padding: EdgeInsets.fromLTRB(6, 6, 0, 0),
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: RaisedButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Info()));
                                    },
                                    child: Text('Правила и доп. информация',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 25)))))
                      ])
                    ]));
              } else {
                return Center(child: Image.asset('assets/the_hat_loading.png'));
              }
            })));
  }
}
