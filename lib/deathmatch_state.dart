import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:mobx/mobx.dart';

import 'dictionary.dart';

part 'deathmatch_state.g.dart';

class DeathmatchState = DeathmatchStateBase with _$DeathmatchState;

abstract class DeathmatchStateBase with Store {
  DeathmatchStateBase(this.dictionary);

  @observable
  Stopwatch stopwatch = Stopwatch();

  @observable
  ObservableList<bool> diffAndTimeVisibility = ObservableList.of([true, true]);

  @observable
  Map gameLog = {
    'version': '2.0',
    'time_zone_offset': DateTime.now().timeZoneOffset.inMilliseconds,
    'attempts': []
  };

  @action
  void toggleVisibility(int idx) {
    diffAndTimeVisibility[idx] = !diffAndTimeVisibility[idx];
  }

  @action
  void startBlinking(int idx) {
    int blinksCnt = 0;
    Timer.periodic(const Duration(milliseconds: 300), (Timer timeout) {
      toggleVisibility(idx);
      blinksCnt += 1;
      if (blinksCnt == 6) {
        timeout.cancel();
      }
    });
  }

  @observable
  AudioPlayer audioPlayer = AudioPlayer();

  @observable
  Dictionary? dictionary;

  @observable
  Random rng = Random();

  @observable
  String? word;

  @observable
  int difficulty = 15;

  @observable
  int additionalTime = 10;

  @observable
  String? partner;

  @observable
  int score = 0;

  @action
  void guessedRight() {
    audioPlayer.stop();
    audioPlayer.play(
      AssetSource('word_outcome_ok.wav'),
      mode: PlayerMode.lowLatency,
    );
    gameLog['attempts'].add({
      'from': 0,
      'to': 1,
      'word': word,
      'time': stopwatch.elapsedMilliseconds,
      'extra_time': 0,
      'outcome': 'guessed'
    });
    stopwatch.reset();
    score += 1;
    matchTimer!.cancel();
    resetMatchTimer();
    if (score % 5 == 0) {
      bool decreaseAdditionalTime;
      if (additionalTime == 0) {
        decreaseAdditionalTime = false;
      } else if (difficulty == 100) {
        decreaseAdditionalTime = true;
      } else {
        decreaseAdditionalTime = rng.nextBool();
      }
      if (decreaseAdditionalTime) {
        additionalTime -= 1;
        startBlinking(1);
      } else if (difficulty != 100) {
        difficulty += 5;
        startBlinking(0);
      }
    }
    addTimer = additionalTime;
    word = dictionary!.getWords(1, difficulty, 5)[0];
  }

  @observable
  int mainTimer = 60;

  @observable
  int addTimer = 10;

  @observable
  String state = 'start';

  @action
  void timerTick() {
    if (addTimer == 0) {
      mainTimer -= 1;
    } else {
      addTimer -= 1;
    }
  }

  @action
  void setState(String newState) {
    state = newState;
  }

  @observable
  Timer? matchTimer;

  @observable
  bool gameLogSent = false;

  @action
  void concede() {
    audioPlayer.stop();
    audioPlayer.play(
      AssetSource('round_start_timer_timeout.wav'),
      mode: PlayerMode.lowLatency,
    );
    gameLog['end_timestamp'] = DateTime.now().millisecondsSinceEpoch;
    gameLog['attempts'].add({
      'from': 0,
      'to': 1,
      'word': word,
      'time': stopwatch.elapsedMilliseconds,
      'extra_time': 0
    });
    matchTimer!.cancel();
    stopwatch.stop();
    setState('score');
  }

  @action
  void startMatch() {
    stopwatch.start();
    gameLog['start_timestamp'] = DateTime.now().millisecondsSinceEpoch;
    audioPlayer.stop();
    audioPlayer.play(
      AssetSource('round_start_timer_timeout.wav'),
      mode: PlayerMode.lowLatency,
    );
    setState('main');
    word = dictionary!.getWords(1, difficulty, 5)[0];
    resetMatchTimer();
  }

  @observable
  int startingCountdown = 3;

  @action
  void startingCountdownTick() {
    startingCountdown -= 1;
  }

  @observable
  Timer? countdownTimer;

  @action
  void startCountdown() {
    startingCountdown = 3;
    setState('countdown');
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (Timer timeout) {
      startingCountdownTick();
      if (state != 'countdown') {
        timeout.cancel();
      } else if (startingCountdown == 0) {
        timeout.cancel();
        startMatch();
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
  void resetMatchTimer() {
    matchTimer = Timer.periodic(const Duration(seconds: 1), (Timer timeout) {
      timerTick();
      if (mainTimer == 0) {
        timeout.cancel();
        audioPlayer.stop();
        audioPlayer.play(
          AssetSource('round_start_timer_timeout.wav'),
          mode: PlayerMode.lowLatency,
        );
        gameLog['end_timestamp'] = DateTime.now().millisecondsSinceEpoch;
        gameLog['attempts'].add({
          'from': 0,
          'to': 1,
          'word': word,
          'time': stopwatch.elapsedMilliseconds,
          'extra_time': 0
        });
        stopwatch.stop();
        setState('score');
      }
    });
  }
}
