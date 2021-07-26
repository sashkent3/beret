import 'dart:async';

import 'package:beret/game_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'app_state.dart';
import 'authors.dart';
import 'deathmatch.dart';
import 'game_history.dart';
import 'match.dart';
import 'rules.dart';
import 'settings.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SentryFlutter.init(
    (options) => options.dsn =
        'https://ff1c3969e7fc468ab6a30f857208faa3@sentry.io/1863108',
    appRunner: () => runApp(Provider<AppState>(
        create: (_) => AppState(),
        child: MaterialApp(title: 'Шляпа', home: MyApp()))),
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
                        padding: EdgeInsets.fromLTRB(0, 0, 3, 3),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                ),
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
                        padding: EdgeInsets.fromLTRB(3, 0, 0, 3),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                onPressed: () {
                                  currentState.newDeathMatch();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Deathmatch()));
                                },
                                child: Text(
                                  'Режим для двоих',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 25),
                                ))))
                  ]),
                  TableRow(children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 3, 3),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingsPage(
                                        currentSetDifficulty: currentState
                                            .prefs!
                                            .getInt('matchDifficulty')!,
                                        currentSetDifficultyDispersion:
                                            currentState.prefs!.getInt(
                                                'difficultyDispersion')!,
                                        currentSetFixTeams: currentState.prefs!
                                            .getBool('fixTeams')!,
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Настройки',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 25))))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(3, 3, 0, 3),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GameHistory()));
                                },
                                child: Text('История игр',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 25)))))
                  ]),
                  TableRow(children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 3, 0),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Rules()));
                                },
                                child: Text('Правила',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 25))))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(3, 3, 0, 0),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Info()));
                                },
                                child: Text('Авторы и документы',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 25)))))
                  ])
                ]));
              } else {
                return Center(child: Image.asset('assets/the_hat_loading.png'));
              }
            })));
  }
}
