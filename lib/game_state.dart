import 'dart:async';
import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:mobx/mobx.dart';

import 'dictionary.dart';
import 'hat.dart';
import 'player.dart';

part 'game_state.g.dart';

class GameState = GameStateBase with _$GameState;

abstract class GameStateBase with Store {
  GameStateBase(prefs) {
    matchDifficulty = prefs.getInt('matchDifficulty');
    wordsPerPlayer = prefs.getInt('wordsPerPlayer');
    difficultyDispersion = prefs.getInt('difficultyDispersion');
    lastStateLength = prefs.getInt('lastStateLength');
    mainStateLength = prefs.getInt('mainStateLength');
    fixTeams = prefs.getBool('fixTeams');
  }

  @action
  int getPlayerOneId() {
    if (fixTeams!) {
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
    if (fixTeams!) {
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
    'time_zone_offset': DateTime.now().timeZoneOffset.inMilliseconds,
    'attempts': []
  };

  @observable
  int? mainStateLength;

  @observable
  int? lastStateLength;

  @observable
  int? matchDifficulty;

  @observable
  bool? fixTeams;

  @observable
  ObservableList<Player> players =
      ObservableList.of([Player('Игрок 1'), Player('Игрок 2')]);

  @observable
  int turn = 0;

  @observable
  AudioPlayer audioPlayer = AudioPlayer();

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
  int? timer;

  @observable
  int difficultyDispersion = 5;

  @observable
  String? word;

  @observable
  int? timeSpent;

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
    audioPlayer.stop();
    audioPlayer.play(
      AssetSource('word_outcome_timeout.wav'),
      mode: PlayerMode.lowLatency,
    );
    hat!.putWord(word!);
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
    if (hat!.isEmpty()) {
      stopwatch.stop();
      changeState('verdict');
    } else if (state == 'last') {
      stopwatch.stop();
      changeState('verdict');
    } else {
      word = hat!.getWord();
    }
    audioPlayer.stop();
    audioPlayer.play(
      AssetSource('word_outcome_ok.wav'),
      mode: PlayerMode.lowLatency,
    );
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
    audioPlayer.stop();
    audioPlayer.play(
      AssetSource('word_outcome_fail.wav'),
      mode: PlayerMode.lowLatency,
    );
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
    turn++;
    playerOneID = getPlayerOneId();
    playerTwoID = getPlayerTwoId();
  }

  @action
  void newTurnTimerSecondPass() {
    newTurnTimerCnt -= 1;
  }

  @observable
  Timer? newTurnTimer;

  @observable
  HashMap? sounds;

  @action
  void newTurnTimerStart() {
    newTurnTimerCnt = 3;
    newTurnTimer = Timer.periodic(const Duration(seconds: 1), (Timer timeout) {
      newTurnTimerSecondPass();
      if (newTurnTimerCnt == 0) {
        timeout.cancel();
        turnStart();
      } else {
        audioPlayer.stop();
        audioPlayer.play(
          AssetSource('round_start_timer_tick.wav'),
          mode: PlayerMode.lowLatency,
        );
      }
    });
  }

  @action
  void turnStart() {
    audioPlayer.stop();
    audioPlayer.play(
      AssetSource('round_start_timer_timeout.wav'),
      mode: PlayerMode.lowLatency,
    );
    word = hat!.getWord();
    changeState('main');
    stopwatch.start();
    turnLog = [];
    Timer.periodic(const Duration(seconds: 1), (Timer timeout) {
      timerSecondPass();
      if (state != 'main' && state != 'last') {
        timeout.cancel();
        timer = mainStateLength;
      } else if (timer == 0) {
        timeSpent = stopwatch.elapsedMilliseconds;
        if (lastStateLength != 0) {
          audioPlayer.stop();
          audioPlayer.play(
            AssetSource('round_timer_timeout.wav'),
            mode: PlayerMode.lowLatency,
          );
        }
        stopwatch.reset();
        changeState('last');
      }
      if (timer == -lastStateLength!) {
        turnLog.add({
          'from': playerOneID,
          'to': playerTwoID,
          'word': word,
          'time': timeSpent,
          'extra_time': lastStateLength,
        });
        audioPlayer.stop();
        audioPlayer.play(
          AssetSource('round_start_timer_timeout.wav'),
          mode: PlayerMode.lowLatency,
        );
        hat!.putWord(word!);
        changeState('verdict');
        stopwatch.stop();
      }
    });
  }

  @observable
  Hat? hat;

  @action
  void timerSecondPass() {
    timer = timer! - 1;
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
        matchDifficulty!, difficultyDispersion));
  }
}
