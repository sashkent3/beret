import 'package:flutter/material.dart';

class Player {
  String name;
  Key key = UniqueKey();
  int guessedRightCnt = 0;
  int explainedRightCnt = 0;
  Color color;

  Player(this.name);

  void guessedRight() {
    guessedRightCnt++;
  }

  void explainedRight() {
    explainedRightCnt++;
  }

  void guessedWrong() {
    guessedRightCnt--;
  }

  void explainedWrong() {
    explainedRightCnt--;
  }
}
