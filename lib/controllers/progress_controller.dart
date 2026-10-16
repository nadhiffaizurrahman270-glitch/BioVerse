import '../models/quiz_progress.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressController {
  static const String _progressKey = 'bioverse_quiz_progress';

  static final Map<String, QuizProgress> _progressMap = {};

  static Future<void>? _initFuture;

  static Future<void> init() {
    return _initFuture ??= _loadProgress();
  }

  static Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_progressKey);

    if (savedData == null) return;

    try {
      final Map<String, dynamic> decoded =
          jsonDecode(savedData) as Map<String, dynamic>;

      _progressMap.clear();

      for (final entry in decoded.entries) {
        final data = entry.value as Map<String, dynamic>;

        _progressMap[entry.key] = QuizProgress(
          score: data['score'] as int,
          totalQuestions: data['totalQuestions'] as int,
        );
      }
    } catch (e) {
      _progressMap.clear();
    }
  }

  static Future<void> saveProgress(
    String topicTitle,
    int score,
    int totalQuestions,
  ) async {
    await init();

    if (totalQuestions <= 0 ||
        score < 0 ||
        score > totalQuestions) {
      return;
    }

    _progressMap[topicTitle] = QuizProgress(
      score: score,
      totalQuestions: totalQuestions,
    );

    final prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> data = {};

    for (final entry in _progressMap.entries) {
      data[entry.key] = {
        'score': entry.value.score,
        'totalQuestions': entry.value.totalQuestions,
      };
    }

    await prefs.setString(_progressKey, jsonEncode(data));
  }

  static QuizProgress? getProgress(String topicTitle) {
    return _progressMap[topicTitle];
  }
}