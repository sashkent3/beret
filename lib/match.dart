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
      if (currentGameState.fixTeams) {
        for (int index = 0;
        index < currentGameState.players.length;
        index += 2) {
          currentGameState.players[index].color = Colors.primaries[
          index * 7 ~/ 2 % Colors.primaries.length];
          listView.add(Card(
              child: ListTile(
                  leading: Icon(Icons.group,
                      color: currentGameState.players[index].color),
                  title: Column(children: [
                    TextFormField(
                        key: currentGameState.players[index].key,
                        decoration: InputDecoration(
                          labelText: 'Имя',
                        ),
                        initialValue: currentGameState.players[index].name,
                        onChanged: (value) {
                          currentGameState.players[index].name = value
                              .replaceAll(RegExp(r"^\s+|\s+$"), '')
                              .replaceAll(RegExp(r"\s+"), ' ');
                        }),
                    TextFormField(
                        key: currentGameState.players[index + 1].key,
                        decoration: InputDecoration(
                          labelText: 'Имя',
                        ),
                        initialValue: currentGameState.players[index + 1].name,
                        onChanged: (value) {
                          currentGameState.players[index + 1].name = value
                              .replaceAll(RegExp(r"^\s+|\s+$"), '')
                              .replaceAll(RegExp(r"\s+"), ' ');
                        })
                  ]),
                  trailing: Visibility(
                      visible: currentGameState.players.length > 2,
                      child: IconButton(
                          tooltip: 'Удалить пару',
                          icon: Icon(Icons.close, color: Colors.blue),
                          onPressed: () {
                            currentGameState.removePlayer(index);
                            currentGameState.removePlayer(index);
                          })))));
        }
      } else {
        for (int index = 0; index < currentGameState.players.length; index++) {
          listView.add(ListTile(
              title: TextFormField(
                  key: currentGameState.players[index].key,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person, color: Colors.blue),
                    labelText: 'Имя',
                  ),
                  initialValue: currentGameState.players[index].name,
                  onChanged: (value) {
                    currentGameState.players[index].name = value
                        .replaceAll(RegExp(r"^\s+|\s+$"), '')
                        .replaceAll(RegExp(r"\s+"), ' ');
                  }),
              trailing: Visibility(
                  visible: currentGameState.players.length > 2,
                  child: IconButton(
                      tooltip: 'Удалить игрока',
                      icon: Icon(Icons.close, color: Colors.blue),
                      onPressed: () {
                        currentGameState.removePlayer(index);
                      }))));
        }
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 10),
          curve: Curves.easeOut,
        );
      });
      return Scaffold(
          bottomNavigationBar: BottomAppBar(
              color: Colors.blue,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                        visible: currentGameState.fixTeams,
                        child: IconButton(
                            color: Colors.white,
                            tooltip: 'Добавить пару',
                            onPressed: () {
                              currentGameState.addPlayer();
                              currentGameState.addPlayer();
                            },
                            icon: Icon(Icons.group_add))),
                    Visibility(
                        visible: !currentGameState.fixTeams,
                        child: IconButton(
                            color: Colors.white,
                            tooltip: 'Добавить игрока',
                            onPressed: currentGameState.addPlayer,
                            icon: Icon(Icons.person_add))),
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
                                      currentGameState.difficultyDispersion,
                                      currentSetFixTeams:
                                      currentGameState.fixTeams));
                        })
                  ])),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFFDEA90C),
            child: Icon(Icons.play_arrow),
            onPressed: () {
              if (currentGameState.validateAll()) {
                currentGameState.createHat(currentAppState.dictionary);
                currentGameState.timer = currentGameState.mainStateLength;
                currentGameState.gameLog['start_timestamp'] =
                    DateTime
                        .now()
                        .millisecondsSinceEpoch;
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
            child: ListView(children: listView, controller: scrollController),
          ));
    });
  }
}

class SettingsDialog extends StatefulWidget {
  final int currentSetDifficulty;
  final int currentSetDifficultyDispersion;
  final bool currentSetFixTeams;

  const SettingsDialog({Key key,
    this.currentSetDifficulty,
    this.currentSetDifficultyDispersion,
    this.currentSetFixTeams})
      : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  static GlobalKey<FormState> settingsKey = GlobalKey<FormState>();
  int currentSetDifficulty;
  int currentSetDifficultyDispersion;
  bool currentSetFixTeams;

  @override
  void initState() {
    currentSetDifficulty = widget.currentSetDifficulty;
    currentSetDifficultyDispersion = widget.currentSetDifficultyDispersion;
    currentSetFixTeams = widget.currentSetFixTeams;
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
                ),
                Text('Разброс сложности',
                    style: TextStyle(
                        fontSize: 12, color: Colors.black.withOpacity(0.5))),
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
                Row(children: [
                  Checkbox(
                      value: currentSetFixTeams,
                      onChanged: (value) {
                        setState(() {
                          currentSetFixTeams = value;
                        });
                      }),
                  Text('Фиксировать команды',
                      style: TextStyle(
                          fontSize: 12, color: Colors.black.withOpacity(0.5)))
                ])
              ]))),
      actions: <Widget>[
        FlatButton(
          child: Text('Готово'),
          onPressed: () {
            if (settingsKey.currentState.validate()) {
              currentGameState.matchDifficulty = currentSetDifficulty;
              currentGameState.difficultyDispersion =
                  currentSetDifficultyDispersion;
              currentGameState.fixTeams = currentSetFixTeams;
              if (currentSetFixTeams &&
                  currentGameState.players.length % 2 != 0) {
                currentGameState.addPlayer();
              }
              settingsKey.currentState.save();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
