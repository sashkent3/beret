import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:beret/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'main.dart';

Future<void> sendSingleWordComplain(List args) async {
  String url = 'http://the-hat.appspot.com';
  var wordComplain = jsonEncode(args[0]);
  String documentsPath = args[1];
  String deviceId = args[2];
  var response;
  try {
    response = await http
        .post('$url/$deviceId/complain', body: {"json": wordComplain});
  } on SocketException catch (_) {
    response = null;
  }
  if (response == null || response.statusCode != 200) {
    List savedWordsComplains;
    if (File('$documentsPath/wordsComplains.json').existsSync()) {
      savedWordsComplains = jsonDecode(
          File('$documentsPath/wordsComplains.json').readAsStringSync());
    } else {
      savedWordsComplains = List();
    }
    savedWordsComplains.add(wordComplain);
    File('$documentsPath/wordsComplains.json')
        .writeAsStringSync(jsonEncode(savedWordsComplains));
  }
}

Future<void> sendSingleGameLog(List args) async {
  var gameLog = args[0];
  String documentsPath = args[1];
  String url = 'http://the-hat.appspot.com';
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
  List players = List.from(args[0]);
  String documentsPath = args[1];
  int gameStartTimestamp = args[2];
  bool fixTeams = args[3];
  List gameHistory = [];
  for (int i = 0; i < players.length; i++) {
    int color;
    if (fixTeams && i % 2 == 0) {
      color = players[i].color.value;
    }
    players[i] = [
      players[i].explainedRightCnt,
      players[i].guessedRightCnt,
      color,
      players[i].name
    ];
  }
  if (File('$documentsPath/gameHistory.json').existsSync()) {
    gameHistory =
        jsonDecode(File('$documentsPath/gameHistory.json').readAsStringSync());
  }
  gameHistory.add([players, gameStartTimestamp, fixTeams, 'quickgame']);
  File('$documentsPath/gameHistory.json')
      .writeAsStringSync(jsonEncode(gameHistory));
}

class Turn extends StatelessWidget {
  Widget build(BuildContext context) {
    final currentAppState = Provider.of<AppState>(context);
    final currentState = Provider.of<AppState>(context).gameState;

    return Observer(builder: (_) {
      if (currentState.state == 'end') {
        return Scaffold(
            appBar: AppBar(
              title: Text('Шляпа'),
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Закончить игру',
              backgroundColor: Color(0xFFDEA90C),
              child: Icon(Icons.arrow_forward),
              onPressed: () async {
                currentState.gameLog['end_timestamp'] =
                    DateTime.now().millisecondsSinceEpoch;
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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MyApp()),
                    (Route<dynamic> route) => false);
              },
            ),
            body: ScoreBoard());
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
                        textScaleFactor: 2.5,
                      )),
                  Center(
                      child:
                          FittedBox(fit: BoxFit.fitWidth, child: CurrentWord()))
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
                          style: TextStyle(color: Colors.red),
                          textScaleFactor: 2.5)),
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
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                  'Вы уверены, что хотите закончить игру?',
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      'Нет',
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                      child: Text(
                                        'Да',
                                      ),
                                      onPressed: () {
                                        currentState.gameLog['attempts'] +=
                                            currentState.turnLog;
                                        currentState.changeState('end');
                                        Navigator.of(context).pop();
                                      })
                                ],
                              );
                            });
                      })
                ])),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFFDEA90C),
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  currentState.gameLog['attempts'] += currentState.turnLog;
                  currentState.newTurn();
                  if (currentState.hat.isEmpty()) {
                    currentState.changeState('end');
                  } else {
                    currentState.changeState('lobby');
                  }
                }),
            body: Padding(
                child: RoundEditing(),
                padding: EdgeInsets.symmetric(vertical: 12)));
      } else if (currentState.state == 'countdown') {
        return WillPopScope(
            onWillPop: () async {
              currentState.changeState('lobby');
              currentState.newTurnTimer.cancel();
              return false;
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text('Шляпа'),
                ),
                body: Stack(children: [
                  Center(
                      child: Text(currentState.newTurnTimerCnt.toString(),
                          style: TextStyle(fontSize: 157))),
                  GestureDetector(onTap: () {
                    currentState.newTurnTimer.cancel();
                    currentState.turnStart();
                  })
                ])));
      } else {
        return Scaffold(
            appBar: AppBar(
              title: Text('Шляпа'),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFFDEA90C),
                child: Icon(Icons.play_arrow),
                onPressed: () {
                  currentState.changeState('countdown');
                  currentState.newTurnTimerStart();
                }),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                  child: SizedBox(
                      width: 300.0, height: 150.0, child: PlayersDisplay())),
            ));
      }
    });
  }
}

class ScoreBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;
    final currentAppState = Provider.of<AppState>(context);
    currentState.players.sort((player1, player2) =>
        player2.guessedRightCnt +
        player2.explainedRightCnt -
        player1.guessedRightCnt -
        player1.explainedRightCnt);
    saveToHistory([
      currentState.players,
      currentAppState.documentsPath,
      currentState.gameLog['start_timestamp'],
      currentState.fixTeams
    ]);
    if (currentState.fixTeams) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: currentState.players.length ~/ 2 + 1,
          itemBuilder: (BuildContext context, int idx) {
            if (idx > 0) {
              idx = (idx - 1) * 2;
              return Card(
                  child: ListTile(
                      leading: Icon(Icons.group,
                          color: currentState.players[idx].color),
                      title: Container(
                          child: Column(children: [
                            Text(currentState.players[idx].name),
                            Text(currentState.players[idx + 1].name)
                          ]),
                          alignment: Alignment.centerLeft),
                      trailing: Container(
                        width: 93,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(currentState
                                        .players[idx].guessedRightCnt
                                        .toString()),
                                    Text(currentState
                                        .players[idx + 1].guessedRightCnt
                                        .toString())
                                  ]),
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(currentState
                                        .players[idx].explainedRightCnt
                                        .toString()),
                                    Text(currentState
                                        .players[idx + 1].explainedRightCnt
                                        .toString())
                                  ]),
                              Text((currentState.players[idx].guessedRightCnt +
                                      currentState
                                          .players[idx].explainedRightCnt)
                                  .toString())
                            ]),
                      )));
            } else {
              return ListTile(
                  leading:
                      Visibility(child: Icon(Icons.person), visible: false),
                  title: Text('Имя игрока',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Container(
                    width: 100,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.lightbulb_outline),
                          Icon(Icons.chat),
                          Text(
                            '\u{03A3}',
                            style:
                                TextStyle(fontSize: 25, color: Colors.black45),
                          )
                        ]),
                  ));
            }
          });
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: currentState.players.length + 1,
          itemBuilder: (BuildContext context, int idx) {
            if (idx > 0) {
              idx -= 1;
              return ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text(currentState.players[idx].name),
                  trailing: Container(
                    width: 93,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(currentState.players[idx].guessedRightCnt
                              .toString()),
                          Text(currentState.players[idx].explainedRightCnt
                              .toString()),
                          Text((currentState.players[idx].guessedRightCnt +
                                  currentState.players[idx].explainedRightCnt)
                              .toString())
                        ]),
                  ));
            } else {
              return ListTile(
                  leading:
                      Visibility(child: Icon(Icons.person), visible: false),
                  title: Text('Имя игрока',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Container(
                    width: 100,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.lightbulb_outline),
                          Icon(Icons.chat),
                          Text(
                            '\u{03A3}',
                            style:
                                TextStyle(fontSize: 25, color: Colors.black45),
                          )
                        ]),
                  ));
            }
          });
    }
  }
}

class PlayersDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return Observer(
        builder: (_) => Stack(children: <Widget>[
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(currentState.playerTwo, textScaleFactor: 2.5)),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(currentState.playerOne, textScaleFactor: 2.5))
            ]));
  }
}

class GuessedRightButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return FloatingActionButton.extended(
      backgroundColor: Color(0xFFDEA90C),
      onPressed: currentState.guessedRight,
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

class GuessedWrongButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return FlatButton.icon(
      icon: Icon(Icons.close, color: Colors.white),
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
    final currentState = Provider.of<AppState>(context).gameState;

    return FlatButton.icon(
      icon: Icon(Icons.close, color: Colors.white),
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
    final currentState = Provider.of<AppState>(context).gameState;

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

class RoundEditing extends StatefulWidget {
  @override
  _RoundEditingState createState() => _RoundEditingState();
}

class _RoundEditingState extends State<RoundEditing> {
  HashSet shownNotGuessedIdx = HashSet();
  HashSet complainedWords = HashSet();

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;
    return ListView.builder(
        itemCount: currentState.turnLog.length,
        padding: EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int idx) {
          Color thumbDownColor;
          if (complainedWords.contains(idx)) {
            thumbDownColor = Colors.red;
          }
          if (!currentState.turnLog[idx].containsKey('outcome')) {
            if (shownNotGuessedIdx.contains(idx)) {
              return Card(
                  child: ListTile(
                      leading: Icon(Icons.close),
                      title: AutoSizeText(currentState.turnLog[idx]['word'],
                          maxLines: 1, maxFontSize: 18),
                      trailing: IntrinsicWidth(
                          child: Row(children: [
                        DropdownButton<String>(
                            value: 'Не угадано',
                            onChanged: (value) {
                              setState(() {
                                if (value == 'Угадано') {
                                  currentState.turnLog[idx]['outcome'] =
                                      'guessed';
                                  currentState.hat.removeWord(
                                      currentState.turnLog[idx]['word']);
                                  currentState.players[currentState.playerOneID]
                                      .explainedRight();
                                  currentState.players[currentState.playerTwoID]
                                      .guessedRight();
                                } else if (value == 'Ошибка') {
                                  currentState.turnLog[idx]['outcome'] =
                                      'failed';
                                  currentState.hat.removeWord(
                                      currentState.turnLog[idx]['word']);
                                }
                              });
                            },
                            items: ['Угадано', 'Не угадано', 'Ошибка']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()),
                        IconButton(
                            icon: Icon(Icons.thumb_down, color: thumbDownColor),
                            onPressed: () async {
                              var _complain = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      WordComplainDialog(
                                          word: currentState.turnLog[idx]
                                              ['word']));
                              if (_complain) {
                                setState(() {
                                  complainedWords.add(idx);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Жалоба отправлена!')));
                                });
                              }
                            })
                      ]))));
            } else {
              return Card(
                  child: ListTile(
                      leading: Icon(Icons.close),
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
          } else if (currentState.turnLog[idx]['outcome'] == 'guessed') {
            return Card(
                child: ListTile(
                    leading: Icon(Icons.check, color: Colors.green),
                    title: AutoSizeText(currentState.turnLog[idx]['word'],
                        maxLines: 1, maxFontSize: 18),
                    trailing: IntrinsicWidth(
                        child: Row(children: [
                      DropdownButton<String>(
                          value: 'Угадано',
                          onChanged: (value) {
                            setState(() {
                              if (value == 'Не угадано') {
                                currentState.turnLog[idx].remove('outcome');
                                currentState.players[currentState.playerOneID]
                                    .explainedWrong();
                                currentState.players[currentState.playerTwoID]
                                    .guessedWrong();
                                currentState.hat
                                    .putWord(currentState.turnLog[idx]['word']);
                              } else if (value == 'Ошибка') {
                                currentState.turnLog[idx]['outcome'] = 'failed';
                                currentState.players[currentState.playerOneID]
                                    .explainedWrong();
                                currentState.players[currentState.playerTwoID]
                                    .guessedWrong();
                              }
                            });
                          },
                          items: ['Угадано', 'Не угадано', 'Ошибка']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                      IconButton(
                          icon: Icon(Icons.thumb_down, color: thumbDownColor),
                          onPressed: () async {
                            var _complain = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) =>
                                    WordComplainDialog(
                                        word: currentState.turnLog[idx]
                                            ['word']));
                            if (_complain) {
                              setState(() {
                                complainedWords.add(idx);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Жалоба отправлена!')));
                              });
                            }
                          })
                    ]))));
          } else {
            return Card(
                child: ListTile(
                    leading: Icon(Icons.error, color: Colors.red),
                    title: AutoSizeText(currentState.turnLog[idx]['word'],
                        maxLines: 1, maxFontSize: 18),
                    trailing: IntrinsicWidth(
                        child: Row(children: [
                      DropdownButton<String>(
                          value: 'Ошибка',
                          onChanged: (value) {
                            setState(() {
                              if (value == 'Угадано') {
                                currentState.turnLog[idx]['outcome'] =
                                    'guessed';
                                currentState.players[currentState.playerOneID]
                                    .explainedRight();
                                currentState.players[currentState.playerTwoID]
                                    .guessedRight();
                              } else if (value == 'Не угадано') {
                                currentState.turnLog[idx].remove('outcome');
                                currentState.hat
                                    .putWord(currentState.turnLog[idx]['word']);
                              }
                            });
                          },
                          items: ['Угадано', 'Не угадано', 'Ошибка']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                      IconButton(
                          icon: Icon(Icons.thumb_down, color: thumbDownColor),
                          onPressed: () async {
                            var _complain = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) =>
                                    WordComplainDialog(
                                        word: currentState.turnLog[idx]
                                            ['word']));
                            if (_complain) {
                              setState(() {
                                complainedWords.add(idx);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Жалоба отправлена!')));
                              });
                            }
                          })
                    ]))));
          }
        });
  }
}

class WordComplainDialog extends StatefulWidget {
  final String word;

  const WordComplainDialog({Key key, this.word}) : super(key: key);

  @override
  _WordComplainDialogState createState() => _WordComplainDialogState();
}

class _WordComplainDialogState extends State<WordComplainDialog> {
  static GlobalKey<FormFieldState> replaceWordKey = GlobalKey<FormFieldState>();
  final ScrollController scrollController = ScrollController();
  String word;
  String replaceWord;
  String reason = 'non_noun';

  @override
  void initState() {
    word = widget.word;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,
      );
    });
    return AlertDialog(
        title: Text('Пожаловаться на слово $word'),
        content: Container(
            width: double.maxFinite,
            child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                    title: Text('Не существительное'),
                    leading: Radio(
                        value: 'non_noun',
                        groupValue: reason,
                        onChanged: (value) {
                          setState(() {
                            reason = value;
                          });
                        })),
                ListTile(
                    title: Text('Несловарное слово'),
                    leading: Radio(
                        value: 'non_dict',
                        groupValue: reason,
                        onChanged: (value) {
                          setState(() {
                            reason = value;
                          });
                        })),
                ListTile(
                    title: Text('Прямое заимствование'),
                    leading: Radio(
                        value: 'loanword',
                        groupValue: reason,
                        onChanged: (value) {
                          setState(() {
                            reason = value;
                          });
                        })),
                ListTile(
                    title: Text('Опечатка'),
                    leading: Radio(
                        value: 'typo',
                        groupValue: reason,
                        onChanged: (value) {
                          setState(() {
                            reason = value;
                          });
                        })),
                Visibility(
                    visible: reason == 'typo',
                    child: TextFormField(
                        decoration: InputDecoration(labelText: 'Заменить на'),
                        onSaved: (value) {
                          replaceWord = value;
                        },
                        key: replaceWordKey))
              ],
            )),
        actions: [
          FlatButton(
            child: Text('Отмена'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
              child: Text('Готово'),
              onPressed: () async {
                Map wordComplain;
                if (reason == 'typo') {
                  replaceWordKey.currentState.save();
                  wordComplain = {
                    'word': word,
                    'reason': reason,
                    'replace_word': replaceWord
                  };
                } else {
                  wordComplain = {'word': word, 'reason': reason};
                }
                when((_) => !currentState.syncing, () {
                  currentState.syncing = true;
                  compute(sendSingleWordComplain, [
                    [wordComplain],
                    currentState.documentsPath,
                    currentState.deviceId
                  ]).then((void _) {
                    currentState.syncing = false;
                  });
                });
                Navigator.of(context).pop(true);
              })
        ]);
  }
}
