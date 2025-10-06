
import 'dart:math';

import 'package:loremgenerator/services/static_data.dart';

class LoremGenerator {
  String generate(int words, int sentences, int paragraphs, bool startWithLorem) {
    var wMin = 6;

    var result = startWithLorem ? "Lorem ipsum " : "";

    for (int i = 0; i < paragraphs.round(); i++) {
      if (result.isNotEmpty && result!="Lorem ipsum ") {
        result += '\n\n';
      }

      var senCount = Random().nextInt(sentences.round())+1;

      for (int j = 0; j < senCount; j++) {
        var numberOfWords = Random().nextInt(words.truncate()) + wMin;
        for (int i2=0; i2 < numberOfWords; i2++) {
          var word = StaticData.allWords[Random().nextInt(StaticData.allWords.length)];
          result += (i2 == 0 ? "" : " ")
              + (i2 == 0 && ((startWithLorem == false) ||
                  (startWithLorem == true &&
                      (i > 0 || i == 0 && j>0)
                  )) ? word.capitalize() : word);
        }

        result += (Random().nextInt(100)<80 ? "." : "?") + (j < senCount ? " " : "");
      }
    }

    return result;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
