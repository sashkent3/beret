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
              tooltip: 'Удалить игрока',
              icon: Icon(Icons.close),
              onPressed: () {
                if (currentGameState.players.length > 2) {
                  currentGameState.removePlayer(index);
                } else {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                          'Должно быть хотя бы два игрока!',
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Закрыть'),
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
          bottomNavigationBar: BottomAppBar(
              color: Colors.blue,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        color: Colors.white,
                        tooltip: 'Добавить игрока',
                        onPressed: currentGameState.addPlayer,
                        icon: Icon(Icons.person_add)),
                    IconButton(
                        color: Colors.white,
                        tooltip: 'Перемешать игроков',
                        onPressed: currentGameState.players.shuffle,
                        icon: Icon(Icons.shuffle)),
                    IconButton(
                        color: Colors.white,
                        tooltip: 'Настройки матча',
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              builder: (BuildContext context) =>
                                  SettingsDialog(
                                      currentSetDifficulty:
                                      currentGameState.matchDifficulty,
                                      currentSetDifficultyDispersion:
                                      currentGameState.difficultyDispersion));
                        })
                  ])),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.cyan,
            child: Icon(Icons.play_arrow),
            onPressed: () {
              if (currentGameState.validateAll()) {
                currentGameState.createHat(currentAppState.dictionary);
                currentGameState.timer = currentGameState.mainStateLength;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Turn()),
                        (Route<dynamic> route) => false);
              } else {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(
                        'У всех игроков должны быть разные имена хотя бы из одного символа!',
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            'Закрыть',
                          ),
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
          ),
          appBar: AppBar(
            title: Text('Шляпа'),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: listView,
                controller: scrollController),
          ));
    });
  }
}

class SettingsDialog extends StatefulWidget {
  final int currentSetDifficulty;
  final int currentSetDifficultyDispersion;

  const SettingsDialog(
      {Key key, this.currentSetDifficulty, this.currentSetDifficultyDispersion})
      : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  static GlobalKey<FormState> settingsKey = GlobalKey<FormState>();
  int currentSetDifficulty;
  int currentSetDifficultyDispersion;

  @override
  void initState() {
    currentSetDifficulty = widget.currentSetDifficulty;
    currentSetDifficultyDispersion = widget.currentSetDifficultyDispersion;
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
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('Разброс сложности',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5)))),
                Slider.adaptive(
                  min: 0,
                  max: 50,
                  divisions: 50,
                  label: currentSetDifficultyDispersion.toString(),
                  value: currentSetDifficultyDispersion.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      currentSetDifficultyDispersion = value.toInt();
                    });
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
          child: Text('Готово'),
          onPressed: () {
            if (settingsKey.currentState.validate()) {
              currentGameState.matchDifficulty = currentSetDifficulty;
              currentGameState.difficultyDispersion =
                  currentSetDifficultyDispersion;
              settingsKey.currentState.save();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
