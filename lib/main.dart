import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'match.dart';
import 'settings.dart';

void main() {
  runApp(Provider<AppState>(
      builder: (_) => AppState(),
      child: MaterialApp(title: 'Шляпа', home: MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    currentState.loadApp();
    return Scaffold(
        appBar: AppBar(title: Text('Шляпа')),
        body: Observer(builder: (_) {
          if (!currentState.loading) {
            return Center(
                child: Column(children: <Widget>[
                  RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        currentState.newGame();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Match()),
                        );
                      },
                      child: Text(
                        'БЫСТРАЯ ИГРА',
                        style: TextStyle(color: Colors.white),
                      )),
                  RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Settings(
                                      currentSetDifficulty:
                                      currentState.prefs.getInt(
                                          'matchDifficulty'),
                                      currentSetDifficultyDispersion: currentState
                                          .prefs
                                          .getInt('difficultyDispersion'))),
                        );
                      },
                      child:
                      Text('НАСТРОЙКИ', style: TextStyle(color: Colors.white)))
                ]));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }));
  }
}
