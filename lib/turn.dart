import 'dart:collection';

import 'package:beret/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class Turn extends StatelessWidget {
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return Observer(builder: (_) {
      if (currentState.state == 'end') {
        return Scaffold(
            appBar: AppBar(
              title: Text('Шляпа'),
            ),
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: EndGame()));
      } else if (currentState.state == 'main') {
        return Scaffold(
            appBar: AppBar(
              title: Text('Шляпа'),
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.endDocked,
            floatingActionButton: GuessedRightButton(),
            bottomNavigationBar: BottomAppBar(
                color: Colors.blue,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [ErrorButton(), ConcedeButton()])),
            body: Padding(
                padding: EdgeInsets.all(12),
                child: Stack(children: <Widget>[
                  Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        currentState.timer.toString(),
                        style: TextStyle(fontSize: 30),
                      )),
                  Center(child: CurrentWord())
                ])));
      } else if (currentState.state == 'last') {
        return Scaffold(
            appBar: AppBar(
              title: Text('Шляпа'),
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.endDocked,
            floatingActionButton: GuessedRightButton(),
            bottomNavigationBar: BottomAppBar(
                color: Colors.blue,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [ErrorButton(), GuessedWrongButton()])),
            body: Padding(
                padding: EdgeInsets.all(12),
                child: Stack(children: <Widget>[
                  Align(
                      alignment: Alignment.topRight,
                      child: Text(
                          (currentState.timer + currentState.lastStateLength)
                              .toString(),
                          style: TextStyle(fontSize: 30, color: Colors.red))),
                  Center(child: CurrentWord())
                ])));
      } else if (currentState.state == 'verdict') {
        return Scaffold(
            appBar: AppBar(
              title: Text('Шляпа'),
            ),
            bottomNavigationBar: BottomAppBar(
                color: Colors.blue,
                child:
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  FlatButton(
                      child: Text(
                        'ЗАКОНЧИТЬ ИГРУ',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        currentState.changeState('end');
                      })
                ])),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.endDocked,
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.cyan,
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  if (currentState.hat.isEmpty()) {
                    currentState.changeState('end');
                  } else {
                    currentState.changeState('lobby');
                  }
                }),
            body: Padding(
                child: RoundEditing(),
                padding: EdgeInsets.symmetric(vertical: 12)));
      } else {
        return Scaffold(
            appBar: AppBar(
              title: Text('Шляпа'),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.cyan,
                child: Icon(Icons.play_arrow),
                onPressed: () {
                  currentState.newTurn();
                }),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                  child: SizedBox(
                      width: 200.0, height: 100.0, child: PlayersDisplay())),
            ));
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

class GuessedRightButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return FloatingActionButton.extended(
      backgroundColor: Colors.cyan,
      onPressed: currentState.guessedRight,
      label: Text(
        'Угадано',
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        Icons.thumb_up,
        color: Colors.white,
      ),
    );
  }
}

class GuessedWrongButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider
        .of<AppState>(context)
        .gameState;

    return FlatButton.icon(
      icon: Icon(Icons.thumb_down, color: Colors.white),
      onPressed: () {
        currentState.concede();
      },
      label: Text('НЕ УГАДАНО', style: TextStyle(color: Colors.white)),
    );
  }
}

class ConcedeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider
        .of<AppState>(context)
        .gameState;

    return FlatButton.icon(
      icon: Icon(Icons.thumb_down, color: Colors.white),
      onPressed: () {
        currentState.concede();
      },
      label: Text('СДАТЬСЯ', style: TextStyle(color: Colors.white)),
    );
  }
}

class ErrorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider
        .of<AppState>(context)
        .gameState;

    return FlatButton.icon(
      icon: Icon(Icons.error, color: Colors.red),
      onPressed: () {
        currentState.error();
      },
      label: Text('ОШИБКА', style: TextStyle(color: Colors.red)),
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
                color: Colors.blue,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyApp()),
                          (Route<dynamic> route) => false);
                },
                child:
                Text('ЗАКОНЧИТЬ ИГРУ', style: TextStyle(color: Colors.white)))
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
