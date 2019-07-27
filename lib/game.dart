import 'package:flutter/material.dart';
import 'package:beret/game_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'end_game.dart';
import 'package:mobx/mobx.dart';


class Game extends StatelessWidget {
  Widget build(BuildContext context) {
    final currentState = Provider.of<GameState>(context);

    return Observer(
      builder: (_) {
        when((_) => currentState.timer == 0, () => Navigator.pop(context));
        return MaterialApp(
        title: 'Шляпа',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Шляпа'),
          ),
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Text(currentState.timer.toString())
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GuessedButton()
              ),
              Center(
                child: CurrentWord()
              )
            ]
          )
        ),
        );
      }
    );
  }
}

class GuessedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<GameState>(context);

    return Observer(
      builder: (_) => RaisedButton(
        onPressed: () {
          currentState.guessedRight();
          if(currentState.hatSize == currentState.wordNum) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EndGame()),
            );
          } 
        },
        child: Text('Угадано', style: TextStyle(fontSize: 20)),
      )
    );
  }
}

class CurrentWord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<GameState>(context);

    return Observer(
      builder: (_) => Text(currentState.word, style: TextStyle(fontSize: 40))
    );
  }
}