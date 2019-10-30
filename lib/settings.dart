import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> settingsKey = GlobalKey<FormState>();
    final currentState = Provider.of<AppState>(context);
    return MaterialApp(
        title: 'Шляпа',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Шляпа'),
            ),
            body: Form(
                key: settingsKey,
                child: Container(
                    width: double.maxFinite,
                    child: ListView(shrinkWrap: true, children: [
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
                      TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: currentState.prefs
                            .getInt('difficultyDispersion')
                            .toString(),
                        decoration: const InputDecoration(
                          labelText: 'Разброс сложности',
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
                              .setInt('difficultyDispersion', int.parse(value));
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text('Сложность',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.5)))),
                      Observer(
                          builder: (_) => Slider(
                                min: 0,
                                max: 100,
                                divisions: 100,
                                label: currentState.currentSetDifficulty
                                    .toString(),
                                value: currentState.currentSetDifficulty
                                    .toDouble(),
                                onChanged: (value) {
                                  currentState
                                      .setCurrentDifficulty(value.toInt());
                                },
                              ))
                    ])))));
  }
}
