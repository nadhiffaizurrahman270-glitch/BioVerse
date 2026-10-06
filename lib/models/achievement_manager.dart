import 'progress_manager.dart';
import 'achievement.dart';

class AchievementManager {
  static List<Achievement> getAchievements() {
    final dna = ProgressManager.getProgress('DNA & Genetics');
    final cell = ProgressManager.getProgress('Cell Biology');
    final viruses = ProgressManager.getProgress('Viruses');
    final ecosystem =
        ProgressManager.getProgress('Life & Ecosystems');

    final completedTopics = [
      dna,
      cell,
      viruses,
      ecosystem,
    ].where((progress) => progress != null).length;

    final hasCompletedQuiz = completedTopics > 0;

    return [
      Achievement(
        title: 'First Step',
        description: 'Menyelesaikan quiz pertama',
        icon: '🌱',
        unlocked: hasCompletedQuiz,
      ),

      Achievement(
        title: 'DNA Explorer',
        description: 'Mendapatkan skor minimal 80% pada DNA & Genetics',
        icon: '🧬',
        unlocked: dna != null && dna.percentage >= 0.8,
      ),

      Achievement(
        title: 'Cell Researcher',
        description: 'Mendapatkan skor minimal 80% pada Cell Biology',
        icon: '🔬',
        unlocked: cell != null && cell.percentage >= 0.8,
      ),

      Achievement(
        title: 'Virus Hunter',
        description: 'Mendapatkan skor minimal 80% pada Viruses',
        icon: '🦠',
        unlocked: viruses != null && viruses.percentage >= 0.8,
      ),

      Achievement(
        title: 'Eco Explorer',
        description:
            'Mendapatkan skor minimal 80% pada Life & Ecosystems',
        icon: '🌍',
        unlocked: ecosystem != null &&
            ecosystem.percentage >= 0.8,
      ),

      Achievement(
        title: 'Biology Master',
        description: 'Menyelesaikan semua topik quiz',
        icon: '🏆',
        unlocked: completedTopics == 4,
      ),
    ];
  }
}