import 'package:beret/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'end_game.dart';


class Turn extends StatelessWidget {
  Widget build(BuildContext context) {
    final currentState = Provider.of<GameState>(context);

    return Observer(
      builder: (_) {
        if(currentState.timerTicking) {
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
                    child: Text(currentState.timer.toString(), style: TextStyle(fontSize: 30),)
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
            )
          );
        }
        else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Шляпа'),
            ),
            body: Stack(
              children: <Widget>[
                Center(
                  child: SizedBox(
                    width: 200.0,
                    height: 100.0,
                    child: PlayersDisplay()
                  )
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GameStartButton(),
                )
              ]
            )
          );
        }
      }
    );
  }
}

class PlayersDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<GameState>(context);

    return Observer(
      builder: (_) => Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: Text(currentState.playerTwo)
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(currentState.playerOne),
          )
        ]
      )
    );
  }
}

class GameStartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<GameState>(context);

    return RaisedButton(
      onPressed: () {
        currentState.newTurn();
      },
      child: Text('Поехали', style: TextStyle(fontSize: 20))
    );
  }
}

class GuessedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<GameState>(context);

    return RaisedButton(
      onPressed: () {
        currentState.guessedRight();
        if(currentState.word == '') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EndGame()),
          );
        }
      },
      child: Text('Угадано', style: TextStyle(fontSize: 20)),
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