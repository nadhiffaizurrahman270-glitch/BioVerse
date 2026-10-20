import 'package:flutter/material.dart';
import 'package:flutter_projek_1/controllers/achievement_controller.dart';

class AchievementPage extends StatelessWidget {
  const AchievementPage({super.key});

  static const Color darkGreen = Color(0xFF12372A);
  static const Color green = Color(0xFF16804A);

  @override
  Widget build(BuildContext context) {
    // AMBIL DATA LENCANA RESMI DARI CONTROLLER
    final achievements = AchievementController.getAchievements();
    final unlockedCount = achievements.where((item) => item.unlocked).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      appBar: AppBar(
        title: const Text(
          'Achievements',
          style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkGreen),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS TERBUKA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5ED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.military_tech_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pencapaian Kamu',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$unlockedCount dari ${achievements.length} Lencana Terbuka',
                        style: const TextStyle(
                          color: Color(0xFF4A5C51),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // GRID LENCANA
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).size.width >= 700 ? 2 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.8,
              ),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final item = achievements[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: item.unlocked
                          ? green.withValues(alpha: 0.5)
                          : const Color(0xFFE3ECE5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        item.icon,
                        style: TextStyle(
                          fontSize: 32,
                          color: item.unlocked ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    color:
                                        item.unlocked ? darkGreen : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(
                                  item.unlocked
                                      ? Icons.check_circle_rounded
                                      : Icons.lock_outline_rounded,
                                  size: 16,
                                  color: item.unlocked ? green : Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF68766D),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}