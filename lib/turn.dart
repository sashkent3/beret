import 'dart:collection';

import 'package:beret/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'main.dart';

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
              onPressed: () {
                currentState.gameLog['end_timestamp'] =
                    DateTime
                        .now()
                        .millisecondsSinceEpoch;
                currentAppState.saveGameLog(currentState.gameLog);
                currentAppState.saveWordsComplains(currentState.wordComplains);
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
                        style: TextStyle(fontSize: 30),
                      )),
                  Center(child: CurrentWord())
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
                          style: TextStyle(fontSize: 30, color: Colors.red))),
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
                        currentState.gameLog['attempts'] +=
                            currentState.turnLog;
                        currentState.changeState('end');
                      })
                ])),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.endDocked,
            floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFFDEA90C),
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  currentState.gameLog['attempts'] += currentState.turnLog;
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
                body: Center(
                    child: Text(currentState.newTurnTimerCnt.toString(),
                        style: TextStyle(fontSize: 157)))));
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
    final currentState = Provider
        .of<AppState>(context)
        .gameState;
    currentState.players.sort((player1, player2) =>
    player2.guessedRightCnt +
        player2.explainedRightCnt -
        player1.guessedRightCnt -
        player1.explainedRightCnt);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: currentState.players.length + 1,
        itemBuilder: (BuildContext context, int idx) {
          if (idx > 0) {
            idx -= 1;
            return ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text(currentState.players[idx].name),
                trailing: Text(
                    currentState.players[idx].explainedRightCnt.toString() +
                        '/' +
                        currentState.players[idx].guessedRightCnt.toString() +
                        '/' +
                        (currentState.players[idx].explainedRightCnt +
                            currentState.players[idx].guessedRightCnt)
                            .toString()));
          } else {
            return ListTile(
                leading: Visibility(child: Icon(Icons.person), visible: false),
                title: Text('Имя игрока',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text('Объяснено/Угадано/Сумма',
                    style: TextStyle(fontWeight: FontWeight.bold)));
          }
        });
  }
}

class PlayersDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

    return Observer(
        builder: (_) =>
            Stack(children: <Widget>[
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(currentState.playerTwo,
                      style: TextStyle(fontSize: 20))),
              Align(
                alignment: Alignment.topLeft,
                child: Text(currentState.playerOne,
                    style: TextStyle(fontSize: 20)),
              )
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
    final currentState = Provider
        .of<AppState>(context)
        .gameState;

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
    final currentState = Provider
        .of<AppState>(context)
        .gameState;

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
    final currentState = Provider
        .of<AppState>(context)
        .gameState;

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

  @override
  Widget build(BuildContext context) {
    final currentState = Provider
        .of<AppState>(context)
        .gameState;
    return ListView.builder(
        itemCount: currentState.turnLog.length,
        padding: EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int idx) {
          if (!currentState.turnLog[idx].containsKey('outcome')) {
            if (shownNotGuessedIdx.contains(idx)) {
              return Card(
                  child: ListTile(
                      leading: Icon(Icons.close),
                      title: Text(currentState.turnLog[idx]['word']),
                      trailing: IntrinsicWidth(
                          child: Row(children: [
                            IconButton(
                                icon: Icon(Icons.thumb_down),
                                onPressed: () {
                                  return showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          WordComplainDialog(word: currentState
                                              .turnLog[idx]['word']));
                                }),
                            DropdownButton<String>(
                                value: 'Не угадано',
                                onChanged: (value) {
                                  setState(() {
                                    if (value == 'Угадано') {
                                      currentState.turnLog[idx]['outcome'] =
                                      'guessed';
                                      currentState.players[currentState
                                          .playerOneID]
                                          .explainedRight();
                                      currentState.players[currentState
                                          .playerTwoID]
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
                                    .map<DropdownMenuItem<String>>((
                                    String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList())
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
                    title: Text(currentState.turnLog[idx]['word']),
                    trailing: IntrinsicWidth(
                        child: Row(children: [
                          IconButton(
                              icon: Icon(Icons.thumb_down),
                              onPressed: () {
                                return showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        WordComplainDialog(word: currentState
                                            .turnLog[idx]['word']));
                              }),
                          DropdownButton<String>(
                              value: 'Угадано',
                              onChanged: (value) {
                                setState(() {
                                  if (value == 'Не угадано') {
                                    currentState.turnLog[idx].remove('outcome');
                                    currentState.players[currentState
                                        .playerOneID]
                                        .explainedWrong();
                                    currentState.players[currentState
                                        .playerTwoID]
                                        .guessedWrong();
                                  } else if (value == 'Ошибка') {
                                    currentState.turnLog[idx]['outcome'] =
                                    'failed';
                                    currentState.hat.removeWord(
                                        currentState.turnLog[idx]['word']);
                                    currentState.players[currentState
                                        .playerOneID]
                                        .explainedWrong();
                                    currentState.players[currentState
                                        .playerTwoID]
                                        .guessedWrong();
                                  }
                                });
                              },
                              items: ['Угадано', 'Не угадано', 'Ошибка']
                                  .map<DropdownMenuItem<String>>((
                                  String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList())
                        ]))));
          } else {
            return Card(
                child: ListTile(
                    leading: Icon(Icons.error, color: Colors.red),
                    title: Text(currentState.turnLog[idx]['word']),
                    trailing: IntrinsicWidth(
                        child: Row(children: [
                          IconButton(
                              icon: Icon(Icons.thumb_down),
                              onPressed: () {
                                return showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        WordComplainDialog(word: currentState
                                            .turnLog[idx]['word']));
                              }),
                          DropdownButton<String>(
                              value: 'Ошибка',
                              onChanged: (value) {
                                setState(() {
                                  if (value == 'Угадано') {
                                    currentState.turnLog[idx]['outcome'] =
                                    'guessed';
                                    currentState.players[currentState
                                        .playerOneID]
                                        .explainedRight();
                                    currentState.players[currentState
                                        .playerTwoID]
                                        .guessedRight();
                                  } else if (value == 'Не угадано') {
                                    currentState.turnLog[idx].remove('outcome');
                                  }
                                  currentState.hat
                                      .putWord(
                                      currentState.turnLog[idx]['word']);
                                });
                              },
                              items: ['Угадано', 'Не угадано', 'Ошибка']
                                  .map<DropdownMenuItem<String>>((
                                  String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList())
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
    final currentState = Provider
        .of<AppState>(context)
        .gameState;
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
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
              child: Text('Готово'),
              onPressed: () {
                if (reason == 'typo') {
                  replaceWordKey.currentState.save();
                  currentState.wordComplains.add({
                    'word': word,
                    'reason': reason,
                    'replace_word': replaceWord
                  });
                } else {
                  currentState.wordComplains
                      .add({'word': word, 'reason': reason});
                }
                Navigator.of(context).pop();
              })
        ]);
  }
}
