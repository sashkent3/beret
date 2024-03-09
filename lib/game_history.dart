import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class GameHistory extends StatelessWidget {
  const GameHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    if (File('${currentState.documentsPath}/gameHistory.json').existsSync() &&
        File('${currentState.documentsPath}/gameHistory.json')
                .readAsStringSync() !=
            '') {
      List gameHistory = jsonDecode(
          File('${currentState.documentsPath}/gameHistory.json')
              .readAsStringSync());
      return Scaffold(
          appBar: AppBar(
            title: const Text('Шляпа'),
          ),
          body: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                  itemCount: gameHistory.length,
                  itemBuilder: (BuildContext context, int idx) {
                    List game = gameHistory[gameHistory.length - idx - 1];
                    if (game[3] == 'quickgame') {
                      String names =
                          game[0].map((var player) => player[3]).join(', ');
                      return Card(
                          child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ScoreBoard(game[0], game[2])));
                              },
                              title: Text(
                                names,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                  '${DateFormat('dd/MM/yyyy').add_Hm().format(DateTime.fromMillisecondsSinceEpoch(game[1]))}, быстрая игра')));
                    } else {
                      return Card(
                          child: ListTile(
                        title: Text('Я и ${game[0]} объяснили ${game[1]}'),
                        subtitle: Text(
                            '${DateFormat('dd/MM/yyyy').add_Hm().format(DateTime.fromMillisecondsSinceEpoch(game[2]))}, режим для двоих'),
                      ));
                    }
                  })));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Шляпа'),
        ),
        body: const Center(
          child: Text('У вас еще нет сыгранных игр!'),
        ),
      );
    }
  }
}

class ScoreBoard extends StatelessWidget {
  final List players;
  final bool fixTeams;

  const ScoreBoard(this.players, this.fixTeams, {super.key});

  @override
  Widget build(BuildContext context) {
    if (fixTeams) {
      return Scaffold(
          appBar: AppBar(title: const Text('Шляпа')),
          body: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: players.length ~/ 2 + 1,
                  itemBuilder: (BuildContext context, int idx) {
                    if (idx > 0) {
                      idx = (idx - 1) * 2;
                      return Card(
                          child: ListTile(
                              leading: Icon(Icons.group,
                                  color: Color(players[idx][2])),
                              title: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(children: [
                                    Text(players[idx][3]),
                                    Text(players[idx + 1][3])
                                  ])),
                              trailing: SizedBox(
                                width: 93,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(players[idx][1].toString()),
                                            Text(players[idx + 1][1].toString())
                                          ]),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(players[idx][0].toString()),
                                            Text(players[idx + 1][0].toString())
                                          ]),
                                      Text((players[idx][1] + players[idx][0])
                                          .toString())
                                    ]),
                              )));
                    } else {
                      return const ListTile(
                          leading: Visibility(
                              visible: false, child: Icon(Icons.person)),
                          title: Text('Имя игрока',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(Icons.lightbulb_outline),
                                  Icon(Icons.chat),
                                  Text(
                                    '\u{03A3}',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black45),
                                  )
                                ]),
                          ));
                    }
                  })));
    } else {
      return Scaffold(
          appBar: AppBar(title: const Text('Шляпа')),
          body: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: players.length + 1,
                  itemBuilder: (BuildContext context, int idx) {
                    if (idx > 0) {
                      idx -= 1;
                      return ListTile(
                          leading: const Icon(Icons.person, color: Colors.blue),
                          title: Text(players[idx][3]),
                          trailing: SizedBox(
                            width: 93,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(players[idx][1].toString()),
                                  Text(players[idx][0].toString()),
                                  Text((players[idx][1] + players[idx][0])
                                      .toString())
                                ]),
                          ));
                    } else {
                      return const ListTile(
                          leading: Visibility(
                              visible: false, child: Icon(Icons.person)),
                          title: Text('Имя игрока',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(Icons.lightbulb_outline),
                                  Icon(Icons.chat),
                                  Text(
                                    '\u{03A3}',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black45),
                                  )
                                ]),
                          ));
                    }
                  })));
    }
  }
}
