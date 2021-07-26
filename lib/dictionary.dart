import 'dart:convert';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:normal/normal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dictionary {
  late List words;

  late List buckets;

  late List bucketsIters;

  late List usedWords;

  String usedWordsPath;

  SharedPreferences prefs;

  Dictionary(this.prefs, this.usedWordsPath) {
    buckets = List.generate(101, (_) => []);
    bucketsIters = List.filled(101, 0);
  }

  Future<void> load() async {
    var dictionaryFile = await DefaultCacheManager()
        .getSingleFile('http://the-hat.appspot.com/api/v2/dictionary/ru');
    var dictionaryList = jsonDecode(dictionaryFile.readAsStringSync());

    for (int i = 0; i < dictionaryList.length; i++) {
      if (dictionaryList[i]['tags'] != '-deleted') {
        buckets[dictionaryList[i]['diff']].add(dictionaryList[i]['word']);
      }
    }

    for (int i = 0; i < 101; i++) {
      buckets[i].shuffle();
      bucketsIters[i] = 0;
    }
  }

  int getUsedWordsIter() {
    final int usedWordsIter = prefs.getInt('usedWordsIter') ?? -1;

    if (usedWordsIter == -1) {
      prefs.setInt('usedWordsIter', 0);
      return 0;
    } else {
      return usedWordsIter;
    }
  }

  List getUsedWords() {
    if (!File('$usedWordsPath/used_words.json').existsSync()) {
      List usedWords = List.filled(1000, null);
      new File('$usedWordsPath/used_words.json').createSync();
      File('$usedWordsPath/used_words.json')
          .writeAsStringSync(jsonEncode(usedWords));
      return usedWords;
    } else {
      final file = File('$usedWordsPath/used_words.json').readAsStringSync();
      List usedWords = jsonDecode(file);
      return usedWords;
    }
  }

  List getWords(int size, int difficulty, int difficultyDispersion) {
    List hatWords = [];
    List usedWords = getUsedWords();
    int usedWordsIter = getUsedWordsIter();
    for (var i = 0; i < size; i++) {
      int bucketIdx =
          (Normal.generate(1)[0] / 3 * difficultyDispersion + difficulty)
              .round();
      while (bucketIdx < 0 || bucketIdx > 100) {
        bucketIdx =
            (Normal.generate(1)[0] / 3 * difficultyDispersion + difficulty)
                .round();
      }
      String word = buckets[bucketIdx][bucketsIters[bucketIdx]];
      bool bucketShuffled = false;
      while (usedWords.contains(word)) {
        word = buckets[bucketIdx][bucketsIters[bucketIdx]];
        bucketsIters[bucketIdx]++;
        if (bucketsIters[bucketIdx] == buckets[bucketIdx].length) {
          if (bucketShuffled) {
            int newBucketIdx =
                (Normal.generate(1)[0] / 3 * difficultyDispersion + difficulty)
                    .round();
            while (newBucketIdx < 0 ||
                newBucketIdx > 100 ||
                newBucketIdx == bucketIdx) {
              newBucketIdx = (Normal.generate(1)[0] / 3 * difficultyDispersion +
                      difficulty)
                  .round();
            }
            bucketIdx = newBucketIdx;
            bucketShuffled = false;
          } else {
            buckets[bucketIdx].shuffle();
            bucketShuffled = true;
          }
          bucketsIters[bucketIdx] = 0;
        }
      }
      hatWords.add(word);
      usedWords[usedWordsIter] = word;
      usedWordsIter++;
      if (usedWordsIter == 1000) {
        usedWordsIter = 0;
      }
    }
    prefs.setInt('usedWordsIter', usedWordsIter);
    File('$usedWordsPath/used_words.json')
        .writeAsStringSync(jsonEncode(usedWords));
    return hatWords;
  }
}
