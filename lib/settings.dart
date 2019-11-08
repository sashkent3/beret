import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class Settings extends StatefulWidget {
  final int currentSetDifficulty;
  final int currentSetDifficultyDispersion;

  const Settings(
      {Key key, this.currentSetDifficulty, this.currentSetDifficultyDispersion})
      : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Шляпа'),
        ),
        body: Stack(children: [
          Form(
              key: settingsKey,
              child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: currentState.prefs
                          .getInt('wordsPerPlayer')
                          .toString(),
                      decoration: const InputDecoration(
                        labelText: 'Кол-во слов на игрока',
                      ),
                      validator: (value) {
                        if (int.tryParse(value) == null) {
                          return 'Должно быть натуральным числом';
                        } else if (int.parse(value) < 1) {
                          return 'Должно быть натуральным числом';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        currentState.prefs
                            .setInt('wordsPerPlayer', int.parse(value));
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: currentState.prefs
                          .getInt('mainStateLength')
                          .toString(),
                      decoration: const InputDecoration(
                        labelText: 'Длительность раунда',
                      ),
                      validator: (value) {
                        if (int.tryParse(value) == null) {
                          return 'Должно быть натуральным числом';
                        } else if (int.parse(value) < 1) {
                          return 'Должно быть натуральным числом';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        currentState.prefs
                            .setInt('mainStateLength', int.parse(value));
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: currentState.prefs
                          .getInt('lastStateLength')
                          .toString(),
                      decoration: const InputDecoration(
                        labelText: 'Добавочное время',
                      ),
                      validator: (value) {
                        if (int.tryParse(value) == null) {
                          return 'Должно быть целым неотрицательным числом';
                        } else if (int.parse(value) < 0) {
                          return 'Должно быть целым неотрицательным числом';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        currentState.prefs
                            .setInt('lastStateLength', int.parse(value));
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
                    Text('Сложность',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5))),
                    Slider.adaptive(
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
                  ])),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: <Widget>[
                  IconButton(
                      tooltip: 'Восстановить стандартные настройки',
                      icon: Icon(Icons.settings_backup_restore),
                      onPressed: () {
                        currentState.restoreDefaultSettings();
                        currentSetDifficulty =
                            currentState.prefs.getInt('matchDifficulty');
                        currentSetDifficultyDispersion =
                            currentState.prefs.getInt('difficultyDispersion');
                        setState(() {
                          settingsKey = GlobalKey<FormState>();
                        });
                      }),
                  IconButton(
                      tooltip: 'Сохранить настройки',
                      icon: Icon(Icons.save),
                      onPressed: () {
                        if (settingsKey.currentState.validate()) {
                          settingsKey.currentState.save();
                          currentState.prefs
                              .setInt('matchDifficulty', currentSetDifficulty);
                          currentState.prefs.setInt('difficultyDispersion',
                              currentSetDifficultyDispersion);
                        }
                      })
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ))
        ]));
  }
}
