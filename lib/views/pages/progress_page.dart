import 'package:flutter/material.dart';
import 'package:flutter_projek_1/controllers/learning_stats_controller.dart';
import 'package:flutter_projek_1/controllers/progress_controller.dart';
import 'package:flutter_projek_1/models/quiz_progress.dart';
import 'package:flutter_projek_1/views/pages/dashboard_page.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  static const Color darkGreen = Color(0xFF12372A);
  static const Color green = Color(0xFF16804A);

  Map<String, QuizProgress> _userProgress = {};
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    await ProgressController.init();
    final data = ProgressController.getAllProgress();
    if (mounted) {
      setState(() {
        _userProgress = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = LearningStatsController.stats;

    final filteredProgress = _userProgress.entries.where((entry) {
      return entry.key.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      body: Column(
        children: [
          // NAVBAR KONSISTEN
          _buildNavbar(context),

          // KONTEN UTAMA
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: green))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // STATISTIK KUIS
                        Row(
                          children: [
                            Expanded(
                              child: _statBox(
                                icon: Icons.stars_rounded,
                                color: const Color(0xFFFFC36A),
                                value: '${stats.totalXp} XP',
                                label: 'Total XP',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statBox(
                                icon: Icons.local_fire_department_rounded,
                                color: const Color(0xFFFF6B6B),
                                value: '${stats.streak} Hari',
                                label: 'Streak Belajar',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statBox(
                                icon: Icons.check_circle_rounded,
                                color: green,
                                value: '${stats.completedQuizzes}',
                                label: 'Kuis Selesai',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // HEADER RIWAYAT & SEARCH BAR
                        Row(
                          children: [
                            const Text(
                              'Riwayat Pembelajaran',
                              style: TextStyle(
                                color: darkGreen,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 260,
                              height: 42,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(21),
                                border:
                                    Border.all(color: const Color(0xFFE3ECE5)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search_rounded,
                                      color: Color(0xFF68766D), size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (val) {
                                        setState(() => _searchQuery = val);
                                      },
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: const InputDecoration(
                                        hintText: 'Cari riwayat kuis...',
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9EAFA4),
                                            fontSize: 13),
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // DAFTAR RIWAYAT
                        if (filteredProgress.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 40, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: const Color(0xFFE3ECE5)),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.history_edu_rounded,
                                    size: 40, color: Colors.grey),
                                const SizedBox(height: 12),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'Riwayat kuis tidak ditemukan.'
                                      : 'Belum ada materi yang kamu kerjakan.',
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredProgress.length,
                            itemBuilder: (context, index) {
                              final entry = filteredProgress[index];
                              final topicTitle = entry.key;
                              final prog = entry.value;
                              final isDone = prog.score == prog.totalQuestions;

                              return _progressItem(
                                title: topicTitle,
                                percent: prog.percentage,
                                scoreText:
                                    'Skor Kuis: ${prog.score}/${prog.totalQuestions}',
                                isCompleted: isDone,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavbar(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06))),
      ),
      child: Row(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: darkGreen),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.biotech, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              const Text(
                'BioVerse',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: darkGreen),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3ECE5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF68766D), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _progressItem({
    required String title,
    required double percent,
    required String scoreText,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3ECE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isCompleted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5EC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(
                      color: green,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            scoreText,
            style: const TextStyle(color: Color(0xFF68766D), fontSize: 12),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: const Color(0xFFEEF4F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? green : const Color(0xFF22C55E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}