import 'dart:math' show Random;

class Hat {
  List words;
  late Random randomGenerator;

  Hat(this.words) {
    randomGenerator = Random();
  }

  String getWord() {
    if (words.isNotEmpty) {
      int wordIdx = randomGenerator.nextInt(words.length);
      String swappedWord = words[wordIdx];
      words[wordIdx] = words.last;
      words.removeLast();
      return swappedWord;
    } else {
      return '';
    }
  }

  void putWord(String word) {
    words.add(word);
  }

  bool isEmpty() {
    return words.isEmpty;
  }

  void removeWord(String word) {
    words.remove(word);
  }
}
