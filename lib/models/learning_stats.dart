class LearningStats {
  final int totalXp;
  final int streak;
  final int completedQuizzes;

  const LearningStats({
    this.totalXp = 0,
    this.streak = 0,
    this.completedQuizzes = 0,
  });

  int get level => (totalXp ~/ 1000) + 1;

  int get xpInCurrentLevel => totalXp % 1000;

  int get xpForNextLevel => 1000;

  double get levelProgress => xpInCurrentLevel / xpForNextLevel;
}