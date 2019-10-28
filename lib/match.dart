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
                                          key: ValueKey(
                                              currentGameState.players[index]),
                                          decoration: const InputDecoration(
                                            icon: Icon(Icons.person),
                                            labelText: 'Имя',
                                          ),
                                          initialValue:
                                          currentGameState.players[index],
                                          onChanged: (value) {
                                            currentGameState.players[index] =
                                                value;
                                          })),
                                  IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        //playersFormKey.currentGameState.save();
                                        if (currentGameState.players.length >
                                            2) {
                                          currentGameState.removePlayer(index);
                                        }
                                      })
                                ]);
                              }))),
              Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                    onPressed: () {
                      if (currentGameState.validateAll()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Turn()),
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
