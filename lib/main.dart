import 'dart:async';

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
        child: const MaterialApp(title: 'Шляпа', home: MyApp()))),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    currentState.loadApp();

    return Scaffold(
        appBar: AppBar(title: const Text('Шляпа')),
        body: Padding(
            padding: const EdgeInsets.all(12),
            child: Observer(builder: (_) {
              if (currentState.loaded) {
                return Center(
                    child: Table(children: [
                  TableRow(children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 3),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  currentState.newGame();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Match()),
                                  );
                                },
                                child: const Text(
                                  'Быстрая игра',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 23),
                                )))),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(3, 0, 0, 3),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  currentState.newDeathMatch();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Deathmatch()));
                                },
                                child: const Text(
                                  'Режим для двоих',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 23),
                                ))))
                  ]),
                  TableRow(children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 3, 3),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
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
                                child: const Text('Настройки',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 23))))),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(3, 3, 0, 3),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const GameHistory()));
                                },
                                child: const Text('История игр',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 23)))))
                  ]),
                  TableRow(children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 3, 0),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Rules()));
                                },
                                child: const Text('Правила',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 23))))),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(3, 3, 0, 0),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Info()));
                                },
                                child: const Text('Авторы и документы',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 23)))))
                  ])
                ]));
              } else {
                return Center(child: Image.asset('assets/the_hat_loading.png'));
              }
            })));
  }
}
