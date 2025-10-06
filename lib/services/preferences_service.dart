// Copyright (c) 2025 Konstantin Adamov. Licensed under the MIT license.

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _keyMaxWords = 'max_words';
  static const _keyMaxSentences = 'max_sentences';
  static const _keyMaxParagraphs = 'max_paragraphs';
  static const _keyStartWithLorem = 'start_with_lorem';


  Future<void> saveMaxWords(int maxWords) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMaxWords, maxWords);
  }

  Future<int> getMaxWords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMaxWords) ?? 15;
  }

  Future<void> saveMaxSentences(int maxSentences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMaxSentences, maxSentences);
  }

  Future<int> getMaxSentences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMaxSentences) ?? 4;
  }

  Future<void> saveMaxParagraphs(int maxParagraphs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMaxParagraphs, maxParagraphs);
  }

  Future<int> getMaxParagraphs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMaxParagraphs) ?? 5;
  }

  Future<void> saveStartWithLorem(bool startWithLorem) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyStartWithLorem, startWithLorem);
  }

  Future<bool> getStartWithLorem() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyStartWithLorem) ?? true;
  }
}
