import 'dart:async';
import 'dart:collection';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mobx/mobx.dart';

import 'dictionary.dart';
import 'hat.dart';
import 'player.dart';

part 'game_state.g.dart';

class GameState = _GameState with _$GameState;

abstract class _GameState with Store {
  _GameState(prefs) {
    matchDifficulty = prefs.getInt('matchDifficulty');
    wordsPerPlayer = prefs.getInt('wordsPerPlayer');
    difficultyDispersion = prefs.getInt('difficultyDispersion');
    lastStateLength = prefs.getInt('lastStateLength');
    mainStateLength = prefs.getInt('mainStateLength');
    fixTeams = prefs.getBool('fixTeams');
    audioPlayer.loadAll([
      'round_start_timer_tick.wav',
      'round_start_timer_timeout.wav',
      'round_timer_timeout.wav',
      'word_outcome_fail.wav',
      'word_outcome_ok.wav',
      'word_outcome_timeout.wav'
    ]);
  }

  @action
  int getPlayerOneId() {
    if (fixTeams) {
      if (turn ~/ (players.length / 2) % 2 == 0) {
        return 2 * turn % players.length;
      } else {
        return 2 * turn % players.length + 1;
      }
    } else {
      return turn % players.length;
    }
  }

  @action
  int getPlayerTwoId() {
    if (fixTeams) {
      if (turn ~/ (players.length / 2) % 2 == 0) {
        return 2 * turn % players.length + 1;
      } else {
        return 2 * turn % players.length;
      }
    } else {
      return (1 + (turn ~/ players.length) % (players.length - 1) + turn) %
          players.length;
    }
  }

  @observable
  int newTurnTimerCnt = 3;

  @observable
  String state = 'lobby';

  @observable
  List log = [];

  @observable
  List turnLog = [];

  @observable
  Map gameLog = {
    'version': '2.0',
    'time_zone_offset': DateTime
        .now()
        .timeZoneOffset
        .inMilliseconds,
    'attempts': []
  };

  @observable
  int mainStateLength;

  @observable
  int lastStateLength;

  @observable
  int matchDifficulty;

  @observable
  bool fixTeams;

  @observable
  ObservableList<Player> players =
  ObservableList.of([Player('Игрок 1'), Player('Игрок 2')]);

  @observable
  int turn = 0;

  @observable
  AudioCache audioPlayer = AudioCache();

  @observable
  int playerOneID = 0;

  @observable
  int playerTwoID = 1;

  @computed
  String get playerOne => players[playerOneID].name;

  @computed
  String get playerTwo => players[playerTwoID].name;

  @observable
  int wordsPerPlayer = 10;

  @observable
  int timer;

  @observable
  int difficultyDispersion = 5;

  @observable
  String word;

  @observable
  int timeSpent;

  @observable
  Stopwatch stopwatch = Stopwatch();

  @action
  void changeState(String newState) {
    state = newState;
  }

  @action
  void concede() {
    if (state == 'main') {
      timeSpent = stopwatch.elapsedMilliseconds;
      turnLog.add({
        'from': playerOneID,
        'to': playerTwoID,
        'word': word,
        'time': timeSpent,
        'extra_time': 0
      });
    } else if (state == 'last' || state == 'verdict') {
      turnLog.add({
        'from': playerOneID,
        'to': playerTwoID,
        'word': word,
        'time': timeSpent,
        'extra_time': stopwatch.elapsedMilliseconds
      });
    }
    audioPlayer.play('word_outcome_timeout.wav', mode: PlayerMode.LOW_LATENCY);
    hat.putWord(word);
    changeState('verdict');
  }

  @action
  void guessedRight() {
    players[playerOneID].explainedRight();
    players[playerTwoID].guessedRight();
    if (state == 'main') {
      timeSpent = stopwatch.elapsedMilliseconds;
      turnLog.add({
        'from': playerOneID,
        'to': playerTwoID,
        'word': word,
        'time': timeSpent,
        'extra_time': 0,
        'outcome': 'guessed'
      });
    } else if (state == 'last') {
      turnLog.add({
        'from': playerOneID,
        'to': playerTwoID,
        'word': word,
        'time': timeSpent,
        'extra_time': stopwatch.elapsedMilliseconds,
        'outcome': 'guessed'
      });
    }
    if (hat.isEmpty()) {
      stopwatch.stop();
      changeState('verdict');
    } else if (state == 'last') {
      stopwatch.stop();
      changeState('verdict');
    } else {
      word = hat.getWord();
    }
    audioPlayer.play('word_outcome_ok.wav', mode: PlayerMode.LOW_LATENCY);
    stopwatch.reset();
  }

  @action
  void error() {
    if (state == 'main') {
      timeSpent = stopwatch.elapsedMilliseconds;
      turnLog.add({
        'from': playerOneID,
        'to': playerTwoID,
        'word': word,
        'time': timeSpent,
        'extra_time': 0,
        'outcome': 'failed'
      });
    } else if (state == 'last') {
      turnLog.add({
        'from': playerOneID,
        'to': playerTwoID,
        'word': word,
        'time': timeSpent,
        'extra_time': stopwatch.elapsedMilliseconds,
        'outcome': 'failed'
      });
    }
    audioPlayer.play('word_outcome_fail.wav', mode: PlayerMode.LOW_LATENCY);
    stopwatch.stop();
    stopwatch.reset();
    changeState('verdict');
  }

  @action
  bool validateAll() {
    HashSet validationSet = HashSet.of(players.map((player) => player.name));
    if (validationSet.contains('') || validationSet.length != players.length) {
      return false;
    }
    return true;
  }

  @action
  void newTurn() {
    playerOneID = getPlayerOneId();
    playerTwoID = getPlayerTwoId();
    turn++;
    word = hat.getWord();
    changeState('main');
    turnStart();
  }

  @action
  void newTurnTimerSecondPass() {
    newTurnTimerCnt -= 1;
  }

  @observable
  Timer newTurnTimer;

  @observable
  HashMap sounds;

  @action
  void newTurnTimerStart() {
    newTurnTimerCnt = 3;
    newTurnTimer = Timer.periodic(Duration(seconds: 1), (Timer _timeout) {
      newTurnTimerSecondPass();
      if (newTurnTimerCnt == 0) {
        audioPlayer.play('round_start_timer_timeout.wav',
            mode: PlayerMode.LOW_LATENCY);
        _timeout.cancel();
        newTurn();
      } else {
        audioPlayer.play('round_start_timer_tick.wav',
            mode: PlayerMode.LOW_LATENCY);
      }
    });
  }

  @action
  void turnStart() {
    stopwatch.start();
    turnLog = [];
    Timer.periodic(Duration(seconds: 1), (Timer _timeout) {
      timerSecondPass();
      if (state != 'main' && state != 'last') {
        _timeout.cancel();
        timer = mainStateLength;
      } else if (timer == 0) {
        timeSpent = stopwatch.elapsedMilliseconds;
        if (lastStateLength != 0) {
          audioPlayer.play('round_timer_timeout.wav',
              mode: PlayerMode.LOW_LATENCY);
        }
        stopwatch.reset();
        changeState('last');
      }
      if (timer == -lastStateLength) {
        turnLog.add({
          'from': playerOneID,
          'to': playerTwoID,
          'word': word,
          'time': timeSpent,
          'extra_time': lastStateLength,
        });
        audioPlayer.play('round_start_timer_timeout.wav',
            mode: PlayerMode.LOW_LATENCY);
        changeState('verdict');
        stopwatch.stop();
      }
    });
  }

  @observable
  Hat hat;

  @action
  void timerSecondPass() {
    timer--;
  }

  @action
  void addPlayer() {
    players.add(Player('Игрок ${players.length + 1}'));
  }

  @action
  void removePlayer(int i) {
    players.removeAt(i);
  }

  @action
  void createHat(Dictionary dictionary) {
    hat = Hat(dictionary.getWords(wordsPerPlayer * players.length,
        matchDifficulty, difficultyDispersion));
  }
}
