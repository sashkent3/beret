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
      words[wordIdx] = words[-1];
      words.removeLast();
      return swappedWord;
    }
    else {
      return null;
    }
  }
}