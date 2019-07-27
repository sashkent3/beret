import 'package:flutter/material.dart';
import 'match.dart';
import 'package:beret/game_state.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)  => Provider<GameState>(
    builder: (_) => GameState(),
    child: MaterialApp(
      title: 'Шляпа',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Шляпа'),
        ),
        body: Match(),
      ),
    )
  );
}

