import 'quiz_progress.dart';

class ProgressManager {
  static final Map<String, QuizProgress> _progressMap = {};

  static void saveProgress(
    String topicTitle, 
    int score, 
    int totalQuestions,
    ) {
    _progressMap[topicTitle] = QuizProgress(
      score: score, 
      totalQuestions: totalQuestions
      );
  }

  static QuizProgress? getProgress(String topicTitle) {
    return _progressMap[topicTitle];
  }
}