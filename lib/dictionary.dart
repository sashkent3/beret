import 'dart:convert';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:normal/normal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dictionary {
  List words;

  List buckets;

  List bucketsIters;

  List usedWords;

  String usedWordsPath;

  SharedPreferences prefs;

  bool loaded;

  Dictionary(this.prefs) {
    buckets = List.generate(101, (_) => List());
    bucketsIters = List.filled(101, 0);
    loaded = false;
  }

  Future<void> getDirectories() async {
    final directory = await getApplicationDocumentsDirectory();
    usedWordsPath = directory.path;
  }

  Future<void> load() async {
    var dictionaryFile = await DefaultCacheManager()
        .getSingleFile('http://the-hat.appspot.com/api/v2/dictionary/ru');
    var dictionaryList = jsonDecode(dictionaryFile.readAsStringSync());

    await getDirectories();
    for (int i = 0; i < dictionaryList.length; i++) {
      buckets[dictionaryList[i]['diff']].add(dictionaryList[i]['word']);
    }
    for (int i = 0; i < 101; i++) {
      buckets[i].shuffle();
      bucketsIters[i] = 0;
    }
    loaded = true;
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
      List usedWords = List(1000);
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
    List hatWords = List();
    List bucketsDispersion = Normal.generate(size);
    List usedWords = getUsedWords();
    int usedWordsIter = getUsedWordsIter();
    for (var i = 0; i < size; i++) {
      int bucketIdx =
      (bucketsDispersion[i] / 3 * difficultyDispersion + difficulty).round();
      if (bucketIdx < 0) {
        bucketIdx = 0;
      }
      if (bucketIdx > 100) {
        bucketIdx = 100;
      }
      String word = buckets[bucketIdx][bucketsIters[bucketIdx]];
      while (usedWords.contains(word)) {
        word = buckets[bucketIdx][bucketsIters[bucketIdx]];
        bucketsIters[bucketIdx]++;
        if (bucketsIters[bucketIdx] == buckets[bucketIdx].length) {
          buckets[bucketIdx].shuffle();
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
