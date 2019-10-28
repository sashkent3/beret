import 'package:beret/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'end_game.dart';

class Turn extends StatelessWidget {
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return Observer(builder: (_) {
      if (currentState.state == 'end') {
        return EndGame();
      } else if (currentState.state == 'main') {
        return MaterialApp(
            title: 'Шляпа',
            home: Scaffold(
                appBar: AppBar(
                  title: Text('Шляпа'),
                ),
                body: Stack(children: <Widget>[
                  Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        currentState.timer.toString(),
                        style: TextStyle(fontSize: 30),
                      )),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: GuessedRightButton()),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ConcedeButton()),
                  Align(alignment: Alignment.bottomLeft, child: ErrorButton()),
                  Center(child: CurrentWord())
                ])));
      } else if (currentState.state == 'last') {
        return MaterialApp(
            title: 'Шляпа',
            home: Scaffold(
                appBar: AppBar(
                  title: Text('Шляпа'),
                ),
                body: Stack(children: <Widget>[
                  Align(
                      alignment: Alignment.topRight,
                      child: Text((currentState.timer + 3).toString(),
                          style: TextStyle(fontSize: 30, color: Colors.red))),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: GuessedRightButton()),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: GuessedWrongButton()),
                  Align(alignment: Alignment.bottomLeft, child: ErrorButton()),
                  Center(child: CurrentWord())
                ])));
      } else if (currentState.state == 'verdict') {
        return MaterialApp(
            title: 'Шляпа',
            home: Scaffold(
                appBar: AppBar(
                  title: Text('Шляпа'),
                ),
                body: Stack(children: <Widget>[
                  Align(
                      alignment: Alignment.bottomRight,
                      child: GuessedRightButton()),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: GuessedWrongButton()),
                  Align(alignment: Alignment.bottomLeft, child: ErrorButton()),
                  Center(child: CurrentWord())
                ])));
      } else {
        return MaterialApp(
            title: 'Шляпа',
            home: Scaffold(
                appBar: AppBar(title: Text('Шляпа')),
                body: Stack(children: <Widget>[
                  Center(
                      child: SizedBox(
                          width: 200.0,
                          height: 100.0,
                          child: PlayersDisplay())),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GameStartButton(),
                  )
                ])));
      }
    });
  }
}

class PlayersDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return Observer(
        builder: (_) =>
            Stack(children: <Widget>[
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(currentState.playerTwo)),
              Align(
                alignment: Alignment.topLeft,
                child: Text(currentState.playerOne),
              )
            ]));
  }
}

class GameStartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return RaisedButton(
        onPressed: () {
          currentState.newTurn();
        },
        child: Text('Поехали', style: TextStyle(fontSize: 20)));
  }
}

class GuessedRightButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return RaisedButton(
      onPressed: () {
        currentState.guessedRight();
      },
      child: Text('Угадано', style: TextStyle(fontSize: 20)),
    );
  }
}

class GuessedWrongButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider
        .of<AppState>(context)
        .gameState;

    return RaisedButton(
      onPressed: () {
        currentState.concede();
      },
      child: Text('Не угадано', style: TextStyle(fontSize: 20)),
    );
  }
}

class ConcedeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider
        .of<AppState>(context)
        .gameState;

    return RaisedButton(
      onPressed: () {
        currentState.concede();
      },
      child: Text('Сдаться', style: TextStyle(fontSize: 20)),
    );
  }
}

class ErrorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider
        .of<AppState>(context)
        .gameState;

    return RaisedButton(
      onPressed: () {
        currentState.error();
      },
      child: Text('Ошибка', style: TextStyle(fontSize: 20, color: Colors.red)),
    );
  }
}

class CurrentWord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return Observer(
        builder: (_) =>
            Text(currentState.word, style: TextStyle(fontSize: 40)));
  }
}
