import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class SettingsPage extends StatefulWidget {
  final int currentSetDifficulty;
  final int currentSetDifficultyDispersion;
  final bool currentSetFixTeams;

  const SettingsPage(
      {Key? key,
      required this.currentSetDifficulty,
      required this.currentSetDifficultyDispersion,
      required this.currentSetFixTeams})
      : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static GlobalKey<FormState> settingsKey = GlobalKey<FormState>();
  late int currentSetDifficulty;
  late int currentSetDifficultyDispersion;
  late bool currentSetFixTeams;

  @override
  void initState() {
    currentSetDifficulty = widget.currentSetDifficulty;
    currentSetDifficultyDispersion = widget.currentSetDifficultyDispersion;
    currentSetFixTeams = widget.currentSetFixTeams;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Шляпа'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          tooltip: 'Сохранить настройки',
          backgroundColor: Color(0xFFDEA90C),
          child: Icon(Icons.save),
          onPressed: () {
            if (settingsKey.currentState!.validate()) {
              settingsKey.currentState!.save();
              currentState.prefs!
                  .setInt('matchDifficulty', currentSetDifficulty);
              currentState.prefs!.setInt(
                  'difficultyDispersion', currentSetDifficultyDispersion);
              currentState.prefs!.setBool('fixTeams', currentSetFixTeams);
              Navigator.of(context).pop();
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
            color: Colors.blue,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              TextButton.icon(
                  label: Text(
                    'СБРОСИТЬ НАСТРОЙКИ',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon:
                      Icon(Icons.settings_backup_restore, color: Colors.white),
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              'Вы уверены, что вы хотите сбросить настройки до стандартных значений?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'Нет',
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                  child: Text(
                                    'Да',
                                  ),
                                  onPressed: () {
                                    currentState.restoreDefaultSettings();
                                    currentSetDifficulty = currentState.prefs!
                                        .getInt('matchDifficulty')!;
                                    currentSetDifficultyDispersion =
                                        currentState.prefs!
                                            .getInt('difficultyDispersion')!;
                                    currentSetFixTeams = currentState.prefs!
                                        .getBool('fixTeams')!;
                                    setState(() {
                                      settingsKey = GlobalKey<FormState>();
                                      Navigator.of(context).pop();
                                    });
                                  })
                            ],
                          );
                        });
                  })
            ])),
        body: Stack(children: [
          Form(
              key: settingsKey,
              child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: currentState.prefs!
                          .getInt('wordsPerPlayer')
                          .toString(),
                      decoration: const InputDecoration(
                        labelText: 'Кол-во слов на игрока',
                      ),
                      validator: (value) {
                        if (int.tryParse(value!) == null) {
                          return 'Должно быть натуральным числом';
                        } else if (int.parse(value) < 1) {
                          return 'Должно быть натуральным числом';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        currentState.prefs!
                            .setInt('wordsPerPlayer', int.parse(value!));
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: currentState.prefs!
                          .getInt('mainStateLength')
                          .toString(),
                      decoration: const InputDecoration(
                        labelText: 'Длительность раунда',
                      ),
                      validator: (value) {
                        if (int.tryParse(value!) == null) {
                          return 'Должно быть натуральным числом';
                        } else if (int.parse(value) < 1) {
                          return 'Должно быть натуральным числом';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        currentState.prefs!
                            .setInt('mainStateLength', int.parse(value!));
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: currentState.prefs!
                          .getInt('lastStateLength')
                          .toString(),
                      decoration: const InputDecoration(
                        labelText: 'Добавочное время',
                      ),
                      validator: (value) {
                        if (int.tryParse(value!) == null) {
                          return 'Должно быть целым неотрицательным числом';
                        } else if (int.parse(value) < 0) {
                          return 'Должно быть целым неотрицательным числом';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        currentState.prefs!
                            .setInt('lastStateLength', int.parse(value!));
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text('Сложность',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.5)))),
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
                    ),
                    Text('Разброс сложности',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5))),
                    Slider.adaptive(
                      min: 5,
                      max: 50,
                      divisions: 45,
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
                              currentSetFixTeams = value!;
                            });
                          }),
                      Text('Фиксировать команды',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.5)))
                    ])
                  ])),
        ]));
  }
}
