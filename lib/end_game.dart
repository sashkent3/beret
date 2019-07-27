import 'package:beret/main.dart';
import 'package:flutter/material.dart';
import 'package:beret/game_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';


class EndGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<GameState>(context);

    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Шляпа'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(currentState.log.toString()),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Text('Закончить игру', style: TextStyle(fontSize: 20))
              )
            ]
          )
        )
      )
    );
  }
}