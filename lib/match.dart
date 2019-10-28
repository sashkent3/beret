import 'package:beret/app_state.dart';
import 'package:beret/turn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Match extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentGameState = Provider
        .of<AppState>(context)
        .gameState;
    final currentAppState = Provider.of<AppState>(context);
    return MaterialApp(
        title: 'Шляпа',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Шляпа'),
            ),
            body: Stack(children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Observer(
                      builder: (_) =>
                          ListView.builder(
                              itemCount: currentGameState.players.length,
                              itemBuilder: (context, index) {
                                return Row(children: <Widget>[
                                  Expanded(
                                      child: TextFormField(
                                          key: currentGameState.players[index]
                                              .key,
                                          decoration: const InputDecoration(
                                            icon: Icon(Icons.person),
                                            labelText: 'Имя',
                                          ),
                                          initialValue:
                                          currentGameState.players[index].name,
                                          onChanged: (value) {
                                            currentGameState.players[index]
                                                .name =
                                                value.split(RegExp(' +')).join(
                                                    ' ');
                                          })),
                                  IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        if (currentGameState.players.length >
                                            2) {
                                          currentGameState.removePlayer(index);
                                        } else {
                                          showDialog<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text(
                                                    'Должно быть хотя бы два игрока!',
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Закрыть',
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      })
                                ]);
                              }))),
              Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                    onPressed: () {
                      currentGameState.createHat(currentAppState.dictionary);
                      if (currentGameState.validateAll()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Turn()),
                        );
                      } else {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(
                                  'У всех игроков должны быть разные имена хотя бы из одного символа!',
                                  style: TextStyle(fontSize: 20)),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Закрыть',
                                      style: TextStyle(fontSize: 20)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Начать игру', style: TextStyle(fontSize: 20))),
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: RaisedButton(
                      onPressed: currentGameState.addPlayer,
                      child: Text('Добавить игрока',
                          style: TextStyle(fontSize: 20))))
            ])));
  }
}
