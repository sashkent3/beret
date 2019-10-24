import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:normal/normal.dart';


class Dictionary {
  List words;

  List buckets;

  Dictionary(this.words) {
    buckets = List.filled(101, {'words': List(), 'iter': 0});
  }

  Future<List> getWords(int size, int difficulty, int difficultyDispersion, List usedWords) async {
    var dictionaryFile = await DefaultCacheManager().getSingleFile('http://the-hat.appspot.com/api/v2/dictionary/ru');
    var dictionaryString = jsonDecode(dictionaryFile.readAsStringSync());
    List hatWords = List(size);
    List bucketsDisp = Normal.generate(size);

    for (int i = 0; i < dictionaryString.length; i++) {
      buckets[dictionaryString[i]['diff']][0].add(dictionaryString[i]['word']);
    }

    for (var bucket in buckets) {
      bucket['words'].shuffle();
      bucket['iter'] = 0;
    }

    for (var i = 0; i < size; i++) {
      var bucket = buckets[(bucketsDisp[i] * difficultyDispersion + difficulty).round()];
      while (usedWords.contains(bucket['words'][bucket['iter']])) {
        bucket['iter']++;
        if (bucket['iter'] == bucket['words'].length) {
          bucket['words'].shuffle();
          bucket['iter'] = 0;
        }
      }
      hatWords.add(bucket['words'][bucket['iter']]);
    }
    return hatWords;
  }
}