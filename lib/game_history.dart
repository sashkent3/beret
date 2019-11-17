import 'package:flutter/material.dart';

class GameHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Шляпа')),
        body: Padding(
            padding: EdgeInsets.all(12),
            child: Text('Скоро здесь появится история игр!')));
  }
}
