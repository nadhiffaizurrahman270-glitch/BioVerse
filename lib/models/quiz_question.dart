class QuizQuestion {
  final String question;
  final List<String> answers;
  final int correctAnswer;

  QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  bool isCorrectAnswer(int answerIndex) {
    return answerIndex == correctAnswer;
  }
}