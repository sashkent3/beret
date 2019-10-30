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
                      onPressed: () {
                        currentState.newGame();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Match()),
                        );
                      },
                      child: Text(
                          'Быстрая игра', style: TextStyle(fontSize: 20))),
                  RaisedButton(
                      onPressed: () {
                        currentState.currentSetDifficulty =
                            currentState.prefs.getInt('matchDifficulty');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Settings()),
                        );
                      },
                      child: Text('Настройки', style: TextStyle(fontSize: 20)))
                ]));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }));
  }
}
