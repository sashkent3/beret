import 'dart:collection';

import 'package:beret/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class Turn extends StatelessWidget {
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return Scaffold(
        appBar: AppBar(
          title: Text('Шляпа'),
        ),
        body: Observer(builder: (_) {
          if (currentState.state == 'end') {
            return EndGame();
          } else if (currentState.state == 'main') {
            return Stack(children: <Widget>[
              Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    currentState.timer.toString(),
                    style: TextStyle(fontSize: 30),
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ErrorButton(),
                        ConcedeButton(),
                        GuessedRightButton()
                      ])),
              Center(child: CurrentWord())
            ]);
          } else if (currentState.state == 'last') {
            return Stack(children: <Widget>[
              Align(
                  alignment: Alignment.topRight,
                  child: Text(
                      (currentState.timer + currentState.lastStateLength)
                          .toString(),
                      style: TextStyle(fontSize: 30, color: Colors.red))),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ErrorButton(),
                        GuessedWrongButton(),
                        GuessedRightButton()
                      ])),
              Center(child: CurrentWord())
            ]);
          } else if (currentState.state == 'verdict') {
            return Stack(children: <Widget>[
              Padding(
                  child: RoundEditing(),
                  padding: EdgeInsets.only(top: 10, bottom: 50)),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                            child: Text('Закончить игру',
                                style: TextStyle(fontSize: 20)),
                            onPressed: () {
                              currentState.changeState('end');
                            }),
                        RaisedButton(
                            child:
                            Text('Готово', style: TextStyle(fontSize: 20)),
                            onPressed: () {
                              currentState.changeState('lobby');
                            })
                      ]))
            ]);
          } else {
            return Stack(children: <Widget>[
              Center(
                  child: SizedBox(
                      width: 200.0, height: 100.0, child: PlayersDisplay())),
              Align(
                alignment: Alignment.bottomCenter,
                child: GameStartButton(),
              )
            ]);
          }
        }));
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

class EndGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Center(
          child: Column(children: <Widget>[
            RaisedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyApp()),
                          (Route<dynamic> route) => false);
                },
                child: Text('Закончить игру', style: TextStyle(fontSize: 20)))
          ]));
}

class RoundEditing extends StatefulWidget {
  @override
  _RoundEditingState createState() => _RoundEditingState();
}

class _RoundEditingState extends State<RoundEditing> {
  HashSet shownNotGuessedIdx = HashSet();

  @override
  Widget build(BuildContext context) {
    final currentState = Provider
        .of<AppState>(context)
        .gameState;
    return ListView.builder(
        itemCount: currentState.turnLog.length,
        padding: EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int idx) {
          if (currentState.turnLog[idx].length == 5) {
            if (shownNotGuessedIdx.contains(idx)) {
              return Card(
                  child: ListTile(
                      leading: Icon(Icons.thumb_down),
                      title: Text(currentState.turnLog[idx][2]),
                      trailing: DropdownButton<String>(
                          value: 'Не угадано',
                          onChanged: (value) {
                            setState(() {
                              if (value == 'Угадано') {
                                currentState.turnLog[idx].add('guessed');
                              } else if (value == 'Ошибка') {
                                currentState.turnLog[idx].add('error');
                                currentState.hat
                                    .removeWord(currentState.turnLog[idx][2]);
                              }
                            });
                          },
                          items: ['Угадано', 'Не угадано', 'Ошибка']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList())));
            } else {
              return Card(
                  child: ListTile(
                      leading: Icon(Icons.thumb_down),
                      title: FlatButton(
                        child: Text('Показать слово',
                            style: TextStyle(fontSize: 15)),
                        onPressed: () {
                          setState(() {
                            shownNotGuessedIdx.add(idx);
                          });
                        },
                      )));
            }
          } else if (currentState.turnLog[idx][5] == 'guessed') {
            return Card(
                child: ListTile(
                    leading: Icon(Icons.thumb_up, color: Colors.green),
                    title: Text(currentState.turnLog[idx][2]),
                    trailing: DropdownButton<String>(
                        value: 'Угадано',
                        onChanged: (value) {
                          setState(() {
                            if (value == 'Не угадано') {
                              currentState.turnLog[idx].removeAt(5);
                            } else if (value == 'Ошибка') {
                              currentState.turnLog[idx][5] = 'error';
                              currentState.hat
                                  .removeWord(currentState.turnLog[idx][2]);
                            }
                          });
                        },
                        items: ['Угадано', 'Не угадано', 'Ошибка']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList())));
          } else {
            return Card(
                child: ListTile(
                    leading: Icon(Icons.error, color: Colors.red),
                    title: Text(currentState.turnLog[idx][2]),
                    trailing: DropdownButton<String>(
                        value: 'Ошибка',
                        onChanged: (value) {
                          setState(() {
                            if (value == 'Угадано') {
                              currentState.turnLog[idx][5] = 'guessed';
                            } else if (value == 'Не угадано') {
                              currentState.turnLog[idx].removeAt(5);
                            }
                            currentState.hat
                                .putWord(currentState.turnLog[idx][2]);
                          });
                        },
                        items: ['Угадано', 'Не угадано', 'Ошибка']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList())));
          }
        });
  }
}
