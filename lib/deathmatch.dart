import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:mobx/mobx.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'app_state.dart';

Future<void> sendSingleGameLog(List args) async {
  var gameLog = args[0];
  String documentsPath = args[1];
  String url = 'http://the-hat-dev.appspot.com/';
  var response;
  try {
    response = await http.post('$url/api/v2/game/log',
        headers: {"content-type": "application/json"},
        body: jsonEncode(gameLog));
  } catch (_) {
    response = null;
  }
  if (response == null || response.statusCode != 201) {
    if (!File('$documentsPath/gameLogs.json').existsSync()) {
      List gameLogs = [gameLog];
      File('$documentsPath/gameLogs.json').createSync();
      File('$documentsPath/gameLogs.json')
          .writeAsStringSync(jsonEncode(gameLogs));
    } else {
      List gameLogs =
          jsonDecode(File('$documentsPath/gameLogs.json').readAsStringSync());
      gameLogs.add(gameLog);
      File('$documentsPath/gameLogs.json')
          .writeAsStringSync(jsonEncode(gameLogs));
    }
  }
}

Future<void> saveToHistory(List args) async {
  String partner = args[0];
  String documentsPath = args[1];
  int gameStartTimestamp = args[2];
  String score = args[3];
  List gameHistory = [];
  if (File('$documentsPath/gameHistory.json').existsSync()) {
    gameHistory =
        jsonDecode(File('$documentsPath/gameHistory.json').readAsStringSync());
  }
  gameHistory.add([partner, score, gameStartTimestamp, 'deathmatch']);
  File('$documentsPath/gameHistory.json')
      .writeAsStringSync(jsonEncode(gameHistory));
}

class Deathmatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).deathmatchState;
    final currentAppState = Provider.of<AppState>(context);

    return Observer(builder: (_) {
      if (currentState.state == 'start') {
        return Scaffold(
            appBar: AppBar(
              title: Text('Шляпа'),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFFDEA90C),
                child: Icon(Icons.arrow_forward),
                onPressed: currentState.startCountdown),
            body: Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                    child: Card(
                        child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'В этом режиме вам необходимо объяснить как можно больше слов по правилам обычной шляпы. Если вы допустили ошибку - придется сдаться. Изначально вам дано 60 секунд основного времени, а также на каждое слово выделено некоторое добавочное время, изначально равное 10 секундам. Каждые 5 отгаданных слов случайным образом либо увеличится сложность слов, либо добавочное время уменьшится на секунду. Побивайте рекорды и соревнуйтесь с друзьями!',
                    textScaleFactor: 1.5,
                  ),
                )))));
      } else if (currentState.state == 'countdown') {
        return WillPopScope(
            onWillPop: () async {
              currentState.setState('start');
              currentState.countdownTimer.cancel();
              return false;
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text('Шляпа'),
                ),
                body: Padding(
                    padding: EdgeInsets.all(12),
                    child: Stack(children: [
                      Center(
                          child: Text(currentState.startingCountdown.toString(),
                              style: TextStyle(fontSize: 157))),
                      GestureDetector(onTap: () {
                        currentState.startMatch();
                      })
                    ]))));
      } else if (currentState.state == 'main') {
        List colors;
        if (currentState.addTimer == 0) {
          colors = [null, Colors.red];
        } else {
          colors = [Colors.green, null];
        }
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text('Шляпа'),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endDocked,
                floatingActionButton: GuessedRightButton(),
                bottomNavigationBar: BottomAppBar(
                    color: Colors.blue,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [ConcedeButton()])),
                body: Padding(
                    padding: EdgeInsets.all(12),
                    child: Stack(children: <Widget>[
                      Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Сложность:',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Visibility(
                                    visible:
                                        currentState.diffAndTimeVisibility[0],
                                    child: LiquidCustomProgressIndicator(
                                        value: currentState.difficulty / 100,
                                        valueColor:
                                            AlwaysStoppedAnimation(Colors.blue),
                                        backgroundColor: Colors.amber,
                                        direction: Axis.vertical,
                                        shapePath: parseSvgPathData(
                                            " M 85 10 L 69.407 50.82 L 72.319 50.82 L 72.319 61.624 L 85 61.76 L 85 69.869 L 10 69.869 L 10 61.624 L 23.525 61.624 L 23.525 51.011 L 25.62 50.82 L 10 10 L 85 10 Z ")))
                              ])),
                      Align(
                          child: Text(currentState.score.toString(),
                              textScaleFactor: 2.5),
                          alignment: Alignment.topCenter),
                      Align(
                          alignment: Alignment.topRight,
                          child: Column(children: [
                            Text('${currentState.mainTimer}',
                                textScaleFactor: 2.5,
                                style: TextStyle(color: colors[1])),
                            Visibility(
                                visible: currentState.diffAndTimeVisibility[1],
                                child: Text('${currentState.addTimer}',
                                    textScaleFactor: 2.5,
                                    style: TextStyle(color: colors[0])))
                          ], crossAxisAlignment: CrossAxisAlignment.end)),
                      Center(
                          child: Text(
                        '${currentState.word}',
                        textScaleFactor: 2.5,
                      ))
                    ]))));
      } else {
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();
        String correctEnding = '';
        if (currentState.score % 10 == 1 && currentState.score != 11) {
          correctEnding = 'о';
        } else if (2 <= currentState.score % 10 &&
            currentState.score % 10 <= 4 &&
            (currentState.score < 12 || currentState.score > 14)) {
          correctEnding = 'а';
        }
        if (!currentState.gameLogSent) {
          currentState.gameLogSent = true;
          when((_) => !currentAppState.syncing, () {
            currentAppState.syncing = true;
            compute(sendSingleGameLog, [
              currentState.gameLog,
              currentAppState.documentsPath,
              currentAppState.deviceId
            ]).then((void _) {
              currentAppState.syncing = false;
            });
          });
        }
        return Scaffold(
            appBar: AppBar(title: Text('Шляпа')),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFFDEA90C),
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    compute(saveToHistory, [
                      currentState.partner,
                      currentAppState.documentsPath,
                      currentState.gameLog['start_timestamp'],
                      currentState.score.toString() + ' слов' + correctEnding,
                    ]);
                    Navigator.of(context).pop();
                  }
                }),
            body: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(
                            'Ваш результат: ${currentState.score} слов$correctEnding!',
                            textScaleFactor: 1.7),
                        subtitle: Text(
                            'Введите имя партнера, чтобы поделиться результатом в соцсетях!'),
                        trailing: IconButton(
                          iconSize: 40,
                          color: Colors.blue,
                          icon: Icon(Icons.share),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              Share.share(
                                  'Я и ${currentState.partner} набрали ${currentState.score} очков в новом режиме для двух игроков в шляпу! Попробуй побить наш результат: https://github.com/nzinov/beret/releases');
                            }
                          },
                        ),
                      ),
                      Form(
                          key: formKey,
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Имя партнера',
                                icon: Icon(Icons.person)),
                            initialValue: 'мой друг',
                            onSaved: (value) {
                              currentState.partner = value
                                  .replaceAll(RegExp(r"^\s+|\s+$"), '')
                                  .replaceAll(RegExp(r"\s+"), ' ');
                            },
                            validator: (value) {
                              if (value
                                      .replaceAll(RegExp(r"^\s+|\s+$"), '')
                                      .replaceAll(RegExp(r"\s+"), ' ') ==
                                  '') {
                                return 'Имя не может быть пустым';
                              }
                              return null;
                            },
                          ))
                    ])));
      }
    });
  }
}

class GuessedRightButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).deathmatchState;

    return FloatingActionButton.extended(
      backgroundColor: Color(0xFFDEA90C),
      onPressed: () {
        currentState.guessedRight();
      },
      label: Text(
        'Угадано',
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }
}

class ConcedeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).deathmatchState;

    return FlatButton.icon(
      icon: Icon(Icons.close, color: Colors.white),
      onPressed: currentState.concede,
      label: Text('СДАТЬСЯ', style: TextStyle(color: Colors.white)),
    );
  }
}
