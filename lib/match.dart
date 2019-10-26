import 'package:beret/app_state.dart';
import 'package:beret/turn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';


class Match extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    final playersFormKey = GlobalKey<FormState>();
    List<Widget> playersTextFormField = List.filled(
      currentState.playersNumber,
      TextFormField(
        onSaved: (value) {
          currentState.players.add(value);
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
    return Center(
      child: Column(
        children: <Widget>[
          Form(
              key: playersFormKey,
              child: Column(
                  children: playersTextFormField
              )
          ),
          RaisedButton(
            onPressed: () {
              if (playersFormKey.currentState.validate()) {
                playersFormKey.currentState.save();
                currentState.newGame();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Turn()),
                );
              }
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
