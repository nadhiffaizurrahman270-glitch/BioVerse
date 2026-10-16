import 'progress_controller.dart';
import '../models/achievement.dart';

class AchievementController {
  static List<Achievement> getAchievements() {
    final dna = ProgressController.getProgress('DNA & Genetics');
    final cell = ProgressController.getProgress('Cell Biology');
    final viruses = ProgressController.getProgress('Viruses');
    final ecosystem =
        ProgressController.getProgress('Life & Ecosystems');

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