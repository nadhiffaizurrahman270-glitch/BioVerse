class QuizProgress {
  final int score;
  final int totalQuestions;

  QuizProgress({
    required this.score,
    required this.totalQuestions,
  });

  double get percentage {
    if (totalQuestions == 0) return 0;
    return score / totalQuestions;
  }
}