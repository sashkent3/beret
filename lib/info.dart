import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text('Шляпа'),
                bottom: TabBar(
                    tabs: <Widget>[Tab(text: 'Правила'), Tab(text: 'Авторы')])),
            body: TabBarView(children: [
              Text('Скоро здесь появятся правила!'),
              Text('Скоро здесь появится информация об авторах!')
            ])));
  }
}
