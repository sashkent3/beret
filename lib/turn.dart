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
  String host = 'the-hat.appspot.com';
  var wordComplain = jsonEncode(args[0]);
  String documentsPath = args[1];
  String deviceId = args[2];
  http.Response? response;
  try {
    response = await http.post(Uri.http(host, '/$deviceId/complain'),
        body: {"json": wordComplain});
  } on SocketException catch (_) {
    response = null;
  }
  if (response == null || response.statusCode != 200) {
    List savedWordsComplains;
    if (File('$documentsPath/wordsComplains.json').existsSync()) {
      savedWordsComplains = jsonDecode(
          File('$documentsPath/wordsComplains.json').readAsStringSync());
    } else {
      savedWordsComplains = [];
    }
    savedWordsComplains.add(wordComplain);
    File('$documentsPath/wordsComplains.json')
        .writeAsStringSync(jsonEncode(savedWordsComplains));
  }
}

Future<void> sendSingleGameLog(List args) async {
  var gameLog = args[0];
  String documentsPath = args[1];
  String host = 'the-hat.appspot.com';
  http.Response? response;
  try {
    response = await http.post(Uri.http(host, '/api/v2/game/log'),
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
    int? color;
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
  const Turn({super.key});

  @override
  Widget build(BuildContext context) {
    final currentAppState = Provider.of<AppState>(context);
    final currentState = Provider.of<AppState>(context).gameState!;

    return Observer(builder: (_) {
      if (currentState.state == 'end') {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Шляпа'),
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Закончить игру',
              backgroundColor: const Color(0xFFDEA90C),
              child: const Icon(Icons.arrow_forward),
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
                        builder: (BuildContext context) => const MyApp()),
                    (Route<dynamic> route) => false);
              },
            ),
            body: const ScoreBoard());
      } else if (currentState.state == 'main') {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Шляпа'),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: const GuessedRightButton(),
            bottomNavigationBar: const BottomAppBar(
                color: Colors.blue,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [ErrorButton(), ConcedeButton()])),
            body: Padding(
                padding: const EdgeInsets.all(12),
                child: Stack(children: <Widget>[
                  Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        currentState.timer.toString(),
                        textScaler: const TextScaler.linear(2.5),
                      )),
                  const Center(
                      child:
                          FittedBox(fit: BoxFit.fitWidth, child: CurrentWord()))
                ])));
      } else if (currentState.state == 'last') {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Шляпа'),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: const GuessedRightButton(),
            bottomNavigationBar: const BottomAppBar(
                color: Colors.blue,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [ErrorButton(), GuessedWrongButton()])),
            body: Padding(
                padding: const EdgeInsets.all(12),
                child: Stack(children: <Widget>[
                  Align(
                      alignment: Alignment.topRight,
                      child: Text(
                          (currentState.timer! + currentState.lastStateLength!)
                              .toString(),
                          style: const TextStyle(color: Colors.red),
                          textScaler: const TextScaler.linear(2.5))),
                  const Center(child: CurrentWord())
                ])));
      } else if (currentState.state == 'verdict') {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Шляпа'),
            ),
            bottomNavigationBar: BottomAppBar(
                color: Colors.blue,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  TextButton(
                      child: const Text(
                        'ЗАКОНЧИТЬ ИГРУ',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                  'Вы уверены, что хотите закончить игру?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text(
                                      'Нет',
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                      child: const Text(
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
                backgroundColor: const Color(0xFFDEA90C),
                child: const Icon(Icons.arrow_forward),
                onPressed: () {
                  currentState.gameLog['attempts'] += currentState.turnLog;
                  currentState.newTurn();
                  if (currentState.hat!.isEmpty()) {
                    currentState.changeState('end');
                  } else {
                    currentState.changeState('lobby');
                  }
                }),
            body: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: RoundEditing()));
      } else if (currentState.state == 'countdown') {
        return PopScope(
            canPop: false,
            onPopInvoked: (_) {
              currentState.changeState('lobby');
              currentState.newTurnTimer!.cancel();
            },
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('Шляпа'),
                ),
                body: Stack(children: [
                  Center(
                      child: Text(currentState.newTurnTimerCnt.toString(),
                          style: const TextStyle(fontSize: 157))),
                  GestureDetector(onTap: () {
                    currentState.newTurnTimer!.cancel();
                    currentState.turnStart();
                  })
                ])));
      } else {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Шляпа'),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: const Color(0xFFDEA90C),
                child: const Icon(Icons.play_arrow),
                onPressed: () {
                  currentState.changeState('countdown');
                  currentState.newTurnTimerStart();
                }),
            body: const Padding(
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
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState!;
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
    if (currentState.fixTeams!) {
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
                          alignment: Alignment.centerLeft,
                          child: Column(children: [
                            Text(currentState.players[idx].name),
                            Text(currentState.players[idx + 1].name)
                          ])),
                      trailing: SizedBox(
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
              return const ListTile(
                  leading:
                      Visibility(visible: false, child: Icon(Icons.person)),
                  title: Text('Имя игрока',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: SizedBox(
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
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(currentState.players[idx].name),
                  trailing: SizedBox(
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
              return const ListTile(
                  leading:
                      Visibility(visible: false, child: Icon(Icons.person)),
                  title: Text('Имя игрока',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: SizedBox(
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
  const PlayersDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState!;

    return Observer(
        builder: (_) => Stack(children: <Widget>[
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    currentState.playerTwo,
                    textScaler: const TextScaler.linear(2.5),
                  )),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    currentState.playerOne,
                    textScaler: const TextScaler.linear(2.5),
                  ))
            ]));
  }
}

class GuessedRightButton extends StatelessWidget {
  const GuessedRightButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState!;

    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFFDEA90C),
      onPressed: currentState.guessedRight,
      label: const Text(
        'УГАДАНО',
        style: TextStyle(color: Colors.white),
      ),
      icon: const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }
}

class GuessedWrongButton extends StatelessWidget {
  const GuessedWrongButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState!;

    return TextButton.icon(
      icon: const Icon(Icons.close, color: Colors.white),
      onPressed: () {
        currentState.concede();
      },
      label: const Text('НЕ УГАДАНО', style: TextStyle(color: Colors.white)),
    );
  }
}

class ConcedeButton extends StatelessWidget {
  const ConcedeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState!;

    return TextButton.icon(
      icon: const Icon(Icons.close, color: Colors.white),
      onPressed: () {
        currentState.concede();
      },
      label: const Text('СДАТЬСЯ', style: TextStyle(color: Colors.white)),
    );
  }
}

class ErrorButton extends StatelessWidget {
  const ErrorButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState!;

    return TextButton.icon(
      icon: const Icon(Icons.error, color: Colors.red),
      onPressed: () {
        currentState.error();
      },
      label: const Text('ОШИБКА', style: TextStyle(color: Colors.red)),
    );
  }
}

class CurrentWord extends StatelessWidget {
  const CurrentWord({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState!;

    return Observer(
        builder: (_) =>
            Text(currentState.word!, style: const TextStyle(fontSize: 40)));
  }
}

class RoundEditing extends StatefulWidget {
  const RoundEditing({super.key});

  @override
  RoundEditingState createState() => RoundEditingState();
}

class RoundEditingState extends State<RoundEditing> {
  HashSet shownNotGuessedIdx = HashSet();
  HashSet complainedWords = HashSet();

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState!;
    return ListView.builder(
        itemCount: currentState.turnLog.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int idx) {
          Color? thumbDownColor;
          if (complainedWords.contains(idx)) {
            thumbDownColor = Colors.red;
          }
          if (!currentState.turnLog[idx].containsKey('outcome')) {
            if (shownNotGuessedIdx.contains(idx)) {
              return Card(
                  child: ListTile(
                      leading: const Icon(Icons.close),
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
                                  currentState.hat!.removeWord(
                                      currentState.turnLog[idx]['word']);
                                  currentState.players[currentState.playerOneID]
                                      .explainedRight();
                                  currentState.players[currentState.playerTwoID]
                                      .guessedRight();
                                } else if (value == 'Ошибка') {
                                  currentState.turnLog[idx]['outcome'] =
                                      'failed';
                                  currentState.hat!.removeWord(
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
                              bool? complain = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) =>
                                    WordComplainDialog(
                                  word: currentState.turnLog[idx]['word'],
                                ),
                              );
                              if (complain != null && complain) {
                                setState(() {
                                  complainedWords.add(idx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Жалоба отправлена!')));
                                });
                              }
                            })
                      ]))));
            } else {
              return Card(
                  child: ListTile(
                      leading: const Icon(Icons.close),
                      title: TextButton(
                        child: const Text('Показать слово',
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
                    leading: const Icon(Icons.check, color: Colors.green),
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
                                currentState.hat!
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
                            bool? complain = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) =>
                                    WordComplainDialog(
                                        word: currentState.turnLog[idx]
                                            ['word']));
                            if (complain != null && complain) {
                              setState(() {
                                complainedWords.add(idx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Жалоба отправлена!')));
                              });
                            }
                          })
                    ]))));
          } else {
            return Card(
                child: ListTile(
                    leading: const Icon(Icons.error, color: Colors.red),
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
                                currentState.hat!
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
                            bool? complain = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) =>
                                    WordComplainDialog(
                                        word: currentState.turnLog[idx]
                                            ['word']));
                            if (complain != null && complain) {
                              setState(() {
                                complainedWords.add(idx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
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

  const WordComplainDialog({super.key, required this.word});

  @override
  WordComplainDialogState createState() => WordComplainDialogState();
}

class WordComplainDialogState extends State<WordComplainDialog> {
  static GlobalKey<FormFieldState> replaceWordKey = GlobalKey<FormFieldState>();
  final ScrollController scrollController = ScrollController();
  late String word;
  late String replaceWord;
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
        content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                    title: const Text('Не существительное'),
                    leading: Radio(
                        value: 'non_noun',
                        groupValue: reason,
                        onChanged: (String? value) {
                          setState(() {
                            reason = value!;
                          });
                        })),
                ListTile(
                    title: const Text('Несловарное слово'),
                    leading: Radio(
                        value: 'non_dict',
                        groupValue: reason,
                        onChanged: (String? value) {
                          setState(() {
                            reason = value!;
                          });
                        })),
                ListTile(
                    title: const Text('Прямое заимствование'),
                    leading: Radio(
                        value: 'loanword',
                        groupValue: reason,
                        onChanged: (String? value) {
                          setState(() {
                            reason = value!;
                          });
                        })),
                ListTile(
                    title: const Text('Опечатка'),
                    leading: Radio(
                        value: 'typo',
                        groupValue: reason,
                        onChanged: (String? value) {
                          setState(() {
                            reason = value!;
                          });
                        })),
                Visibility(
                    visible: reason == 'typo',
                    child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Заменить на'),
                        onSaved: (String? value) {
                          replaceWord = value!;
                        },
                        key: replaceWordKey))
              ],
            )),
        actions: [
          TextButton(
            child: const Text('Отмена'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
              child: const Text('Готово'),
              onPressed: () async {
                Map wordComplain;
                if (reason == 'typo') {
                  replaceWordKey.currentState!.save();
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
