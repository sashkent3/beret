import 'package:beret/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';


class EndGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context).gameState;

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
                  Navigator.pop(
                    context
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