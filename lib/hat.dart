import 'dart:math' show Random;

class Hat {
  List words;
  Random randomGenerator;

  Hat(this.words) {
    randomGenerator = Random();
  }

  String getWord() {
    if (words.length != 0) {
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
