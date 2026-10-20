import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_projek_1/controllers/topic_controller.dart';
import 'package:flutter_projek_1/controllers/bookmark_controller.dart';
import 'package:flutter_projek_1/views/pages/topic_detail_page.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  static const Color darkGreen = Color(0xFF12372A);
  static const Color green = Color(0xFF16804A);

  @override
  Widget build(BuildContext context) {
    final allTopics = Provider.of<TopicController>(context).topics;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      appBar: AppBar(
        title: const Text(
          'Saved Topics',
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkGreen),
      ),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: BookmarkController.bookmarkedTopicTitles,
        builder: (context, savedTitles, _) {
          final savedTopics = allTopics
              .where((topic) => savedTitles.contains(topic.title))
              .toList();

          if (savedTopics.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border_rounded,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada materi yang disimpan',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Simpan materi yang ingin kamu pelajari nanti.',
                    style: TextStyle(color: Colors.black45, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: savedTopics.length,
            itemBuilder: (context, index) {
              final topic = savedTopics[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE3ECE5)),
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TopicDetailPage(topic: topic),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5EC),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    topic.category.toUpperCase(),
                                    style: const TextStyle(
                                      color: green,
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    topic.level,
                                    style: const TextStyle(
                                      color: Color(0xFF1E88E5),
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              topic.title,
                              style: const TextStyle(
                                color: darkGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              topic.description,
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
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_rounded, color: green),
                      onPressed: () {
                        BookmarkController.removeBookmark(topic.title);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${topic.title} dihapus dari simpanan'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}