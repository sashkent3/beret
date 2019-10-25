import 'package:beret/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'match.dart';

void main() {
  runApp(
    Provider<AppState>(
      builder: (_) => AppState(),
      child: MaterialApp(
        title: 'Шляпа',
        home: MyApp()
      )
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Шляпа')
      ),
      body: MainScreen()
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    currentState.loadDictionary();

    return Observer(
      builder: (_) {
        if (!currentState.loading) {
          return Match();
        }
        else {
          return Center(
              child: CircularProgressIndicator()
          );
        }
      }
    );
  }
}


