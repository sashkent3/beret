import 'package:beret/app_state.dart';
import 'package:beret/turn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Match extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentGameState = Provider
        .of<AppState>(context)
        .gameState;
    final currentAppState = Provider.of<AppState>(context);
    final ScrollController scrollController = ScrollController();
    return Observer(builder: (_) {
      if (currentGameState.state == 'start') {
        List<Widget> listView = [];
        for (int index = 0; index < currentGameState.players.length; index++) {
          listView.add(Row(children: <Widget>[
            Expanded(
                child: TextFormField(
                    key: currentGameState.players[index].key,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Имя',
                    ),
                    initialValue: currentGameState.players[index].name,
                    onChanged: (value) {
                      currentGameState.players[index].name = value
                          .replaceAll(RegExp(r"^\s+|\s+$"), '')
                          .replaceAll(RegExp(r"\s+"), ' ');
                    })),
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  if (currentGameState.players.length > 2) {
                    currentGameState.removePlayer(index);
                  } else {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('Должно быть хотя бы два игрока!',
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
                })
          ]));
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 10),
            curve: Curves.easeOut,
          );
        });
        return Scaffold(
                appBar: AppBar(
                  title: Text('Шляпа'),
                ),
                body: Stack(children: <Widget>[
                  Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              children: listView,
                              controller: scrollController),
                          padding: EdgeInsets.only(bottom: 50))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                onPressed: currentGameState.addPlayer,
                                icon: Icon(Icons.person_add)),
                            IconButton(
                                onPressed: currentGameState.players.shuffle,
                                icon: Icon(Icons.shuffle)),
                            IconButton(
                                icon: Icon(Icons.settings),
                                onPressed: () {
                                  showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SettingsDialog(
                                              currentSetDifficulty:
                                              currentGameState
                                                  .matchDifficulty));
                                }),
                            IconButton(
                                onPressed: () {
                                  currentGameState
                                      .createHat(currentAppState.dictionary);
                                  if (currentGameState.validateAll()) {
                                    currentGameState.timer =
                                        currentGameState.mainStateLength;
                                    currentGameState.changeState('lobby');
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
                                                  style:
                                                  TextStyle(fontSize: 20)),
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
                                icon: Icon(Icons.play_arrow))
                          ]))
                ]));
      } else {
        return Turn();
      }
    });
  }
}

class SettingsDialog extends StatefulWidget {
  final int currentSetDifficulty;

  const SettingsDialog({Key key, this.currentSetDifficulty}) : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  static GlobalKey<FormState> settingsKey = GlobalKey<FormState>();
  int currentSetDifficulty;

  @override
  void initState() {
    currentSetDifficulty = widget.currentSetDifficulty;
    super.initState();
  }

  @override
  build(BuildContext context) {
    final currentGameState = Provider
        .of<AppState>(context)
        .gameState;
    return AlertDialog(
      title: Text('Настройки'),
      content: Form(
          key: settingsKey,
          child: Container(
              width: double.maxFinite,
              child: ListView(shrinkWrap: true, children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: currentGameState.wordsPerPlayer.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Кол-во слов на игрока',
                  ),
                  validator: (value) {
                    if (int.tryParse(value) == null || int.parse(value) < 1) {
                      return 'Должно быть натуральным числом';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    currentGameState.wordsPerPlayer = int.parse(value);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: currentGameState.mainStateLength.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Длительность раунда',
                  ),
                  validator: (value) {
                    if (int.tryParse(value) == null || int.parse(value) < 1) {
                      return 'Должно быть натуральным числом';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    currentGameState.mainStateLength = int.parse(value);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: currentGameState.lastStateLength.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Добавочное время',
                  ),
                  validator: (value) {
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'Должно быть целым неотрицательным числом';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    currentGameState.lastStateLength = int.parse(value);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue:
                  currentGameState.difficultyDispersion.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Разброс сложности',
                  ),
                  validator: (value) {
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'Должно быть целым неотрицательным числом';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    currentGameState.difficultyDispersion = int.parse(value);
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('Сложность',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5)))),
                Slider(
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: currentSetDifficulty.toString(),
                  value: currentSetDifficulty.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      currentSetDifficulty = value.toInt();
                    });
                  },
                )
              ]))),
      actions: <Widget>[
        FlatButton(
          child: Text('Готово', style: TextStyle(fontSize: 20)),
          onPressed: () {
            if (settingsKey.currentState.validate()) {
              currentGameState.matchDifficulty = currentSetDifficulty;
              settingsKey.currentState.save();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
