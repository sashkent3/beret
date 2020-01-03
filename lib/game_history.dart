import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class GameHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    List gameHistory = jsonDecode(
        File('${currentState.documentsPath}/gameHistory.json')
            .readAsStringSync());
    return Scaffold(
        appBar: AppBar(title: Text('Шляпа')),
        body: Padding(
            padding: EdgeInsets.all(12),
            child: ListView.builder(
                reverse: true,
                itemCount: gameHistory.length,
                itemBuilder: (BuildContext context, int idx) {
                  List game = gameHistory[idx];
                  String names = game[0].map((var player) => player[3]).join(
                      ', ');
                  return Card(child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ScoreBoard(game[0], game[2])));
                      },
                      title: Text(names, overflow: TextOverflow.ellipsis,),
                      subtitle: Text(
                          DateFormat('dd/MM/yyyy').add_Hm().format(
                              DateTime.fromMillisecondsSinceEpoch(game[1])))));
                })));
  }
}

class ScoreBoard extends StatelessWidget {
  final List players;
  final bool fixTeams;

  ScoreBoard(this.players, this.fixTeams);

  @override
  Widget build(BuildContext context) {
    if (fixTeams) {
      return Scaffold(
          appBar: AppBar(title: Text('Шляпа')),
          body: Padding(
              padding: EdgeInsets.all(12),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: players.length ~/ 2 + 1,
                  itemBuilder: (BuildContext context, int idx) {
                    if (idx > 0) {
                      idx = (idx - 1) * 2;
                      return Card(
                          child: ListTile(
                              leading: Icon(
                                  Icons.group, color: Color(players[idx][2])),
                              title: Container(
                                  child: Column(children: [
                                    Text(players[idx][3]),
                                    Text(players[idx + 1][3])
                                  ]),
                                  alignment: Alignment.centerLeft),
                              trailing: Container(
                                width: 93,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
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
                      return ListTile(
                          leading:
                          Visibility(child: Icon(Icons.person), visible: false),
                          title: Text('Имя игрока',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Container(
                            width: 100,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  Icon(Icons.lightbulb_outline),
                                  Icon(Icons.chat),
                                  Text(
                                    '\u{03A3}',
                                    style:
                                    TextStyle(
                                        fontSize: 25, color: Colors.black45),
                                  )
                                ]),
                          ));
                    }
                  })));
    } else {
      return Scaffold(
          appBar: AppBar(title: Text('Шляпа')),
          body: Padding(
              padding: EdgeInsets.all(12),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: players.length + 1,
                  itemBuilder: (BuildContext context, int idx) {
                    if (idx > 0) {
                      idx -= 1;
                      return ListTile(
                          leading: Icon(Icons.person, color: Colors.blue),
                          title: Text(players[idx][3]),
                          trailing: Container(
                            width: 93,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  Text(players[idx][1].toString()),
                                  Text(players[idx][0].toString()),
                                  Text((players[idx][1] + players[idx][0])
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
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  Icon(Icons.lightbulb_outline),
                                  Icon(Icons.chat),
                                  Text(
                                    '\u{03A3}',
                                    style:
                                    TextStyle(
                                        fontSize: 25, color: Colors.black45),
                                  )
                                ]),
                          ));
                    }
                  })));
    }
  }
}
