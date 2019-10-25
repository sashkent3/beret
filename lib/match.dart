import 'package:beret/app_state.dart';
import 'package:beret/turn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';


class Match extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    return Center(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              currentState.newGame();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Turn()),
              );
            },
            child: Text('Начать игру', style: TextStyle(fontSize: 20))
          ),
          //SettingsInfo()
        ]
      )
    );
  }
}

class SettingsInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return Observer(
      builder: (_) => Text('Всего слов в шляпе: ' + currentState.hatSize.toString())
    );
  }
}
