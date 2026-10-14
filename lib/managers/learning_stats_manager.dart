import 'package:shared_preferences/shared_preferences.dart';

import '../models/learning_stats.dart';

class LearningStatsManager {
  static const String _xpKey = 'bioverse_total_xp';
  static const String _streakKey = 'bioverse_streak';
  static const String _completedQuizzesKey =
      'bioverse_completed_quizzes';
  static const String _completedTopicsKey =
      'bioverse_completed_topics';
  static const String _lastStudyDateKey =
      'bioverse_last_study_date';

  static SharedPreferences? _prefs;

  static LearningStats _stats = const LearningStats();

  static Set<String> _completedTopics = {};

  // Memuat data yang tersimpan.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();

    final prefs = _prefs!;

    _stats = LearningStats(
      totalXp: prefs.getInt(_xpKey) ?? 0,
      streak: prefs.getInt(_streakKey) ?? 0,
      completedQuizzes:
          prefs.getInt(_completedQuizzesKey) ?? 0,
    );

    _completedTopics =
        (prefs.getStringList(_completedTopicsKey) ?? [])
            .toSet();

    // Periksa apakah streak masih berlaku.
    _checkStreak();
  }

  // Mengambil statistik belajar.
  static LearningStats get stats => _stats;

  // Mengecek apakah topik sudah pernah diselesaikan.
  static bool isTopicCompleted(String topicTitle) {
    return _completedTopics.contains(topicTitle);
  }

  // Memproses hasil kuis.
  static Future<bool> recordQuizCompletion({
    required String topicTitle,
    required int score,
    required int totalQuestions,
  }) async {
    await _ensureInitialized();

    if (totalQuestions <= 0) {
      return false;
    }

    if (score < 0 || score > totalQuestions) {
      return false;
    }

    // Aktivitas belajar dicatat setiap kuis selesai.
    _recordStudyActivity();

    // Jika topik sudah pernah diselesaikan,
    // tidak memberikan XP lagi.
    if (_completedTopics.contains(topicTitle)) {
      await _saveStats();
      return false;
    }

    // Tandai topik sebagai selesai.
    _completedTopics.add(topicTitle);

    // XP dasar untuk menyelesaikan kuis.
    int earnedXp = 50;

    // Bonus jika semua jawaban benar.
    if (score == totalQuestions) {
      earnedXp += 25;
    }

    _stats = LearningStats(
      totalXp: _stats.totalXp + earnedXp,
      streak: _stats.streak,
      completedQuizzes: _stats.completedQuizzes + 1,
    );

    await _saveStats();

    return true;
  }

  // Mencatat aktivitas belajar berdasarkan tanggal.
  static void _recordStudyActivity() {
    final now = DateTime.now();

    final today = _dateKey(now);
    final lastStudyDate =
        _prefs!.getString(_lastStudyDateKey);

    if (lastStudyDate == today) {
      // Aktivitas hari ini sudah pernah dicatat.
      return;
    }

    if (lastStudyDate == null) {
      // Aktivitas belajar pertama.
      _stats = LearningStats(
        totalXp: _stats.totalXp,
        streak: 1,
        completedQuizzes: _stats.completedQuizzes,
      );
    } else {
      final lastDate = DateTime.tryParse(lastStudyDate);

      if (lastDate == null) {
        _stats = LearningStats(
          totalXp: _stats.totalXp,
          streak: 1,
          completedQuizzes: _stats.completedQuizzes,
        );
      } else {
        final yesterday =
            DateTime(now.year, now.month, now.day)
                .subtract(const Duration(days: 1));

        final previousDay =
            DateTime(lastDate.year, lastDate.month, lastDate.day);

        final newStreak =
            previousDay == yesterday
                ? _stats.streak + 1
                : 1;

        _stats = LearningStats(
          totalXp: _stats.totalXp,
          streak: newStreak,
          completedQuizzes: _stats.completedQuizzes,
        );
      }
    }

    _prefs!.setString(_lastStudyDateKey, today);
  }

  // Memeriksa streak ketika aplikasi dibuka.
  static void _checkStreak() {
    final lastStudyDate =
        _prefs!.getString(_lastStudyDateKey);

    if (lastStudyDate == null) return;

    final lastDate = DateTime.tryParse(lastStudyDate);

    if (lastDate == null) return;

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final previousDay =
        today.subtract(const Duration(days: 1));

    final recordedDate =
        DateTime(lastDate.year, lastDate.month, lastDate.day);

    // Jika sudah melewati satu hari tanpa aktivitas,
    // streak kembali menjadi nol.
    if (recordedDate != today &&
        recordedDate != previousDay) {
      _stats = LearningStats(
        totalXp: _stats.totalXp,
        streak: 0,
        completedQuizzes: _stats.completedQuizzes,
      );

      _prefs!.setInt(_streakKey, 0);
    }
  }

  // Menyimpan statistik.
  static Future<void> _saveStats() async {
    final prefs = _prefs!;

    await prefs.setInt(_xpKey, _stats.totalXp);
    await prefs.setInt(_streakKey, _stats.streak);

    await prefs.setInt(
      _completedQuizzesKey,
      _stats.completedQuizzes,
    );

    await prefs.setStringList(
      _completedTopicsKey,
      _completedTopics.toList(),
    );
  }

  // Memastikan data sudah dimuat.
  static Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await init();
    }
  }

  // Mengubah tanggal menjadi format YYYY-MM-DD.
  static String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}