import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_projek_1/services/api_service.dart';
import 'package:flutter_projek_1/controllers/topic_controller.dart';
import 'package:flutter_projek_1/views/pages/topic_detail_page.dart';
import 'package:flutter_projek_1/views/pages/dashboard_page.dart';

class BookmarkController {
  static final ValueNotifier<List<String>> bookmarkedTopicTitles =
      ValueNotifier<List<String>>([]);

  static bool isBookmarked(String topicTitle) {
    return bookmarkedTopicTitles.value.contains(topicTitle);
  }

  static void toggleBookmark(String topicTitle) {
    final currentList = List<String>.from(bookmarkedTopicTitles.value);
    if (currentList.contains(topicTitle)) {
      currentList.remove(topicTitle);
    } else {
      currentList.add(topicTitle);
    }
    bookmarkedTopicTitles.value = currentList;
  }

  static void removeBookmark(String topicTitle) {
    final currentList = List<String>.from(bookmarkedTopicTitles.value);
    if (currentList.contains(topicTitle)) {
      currentList.remove(topicTitle);
      bookmarkedTopicTitles.value = currentList;
    }
  }
}

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  static const Color darkGreen = Color(0xFF12372A);
  static const Color green = Color(0xFF16804A);

  String _searchQuery = '';
  String _username = 'Explorer';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final profile = await ApiService().getUserProfile();
      final rawName = profile['name'];
      final name = (rawName is String && rawName.isNotEmpty)
          ? rawName
          : "Pengguna Tanpa Nama";

      // Simulasi delay
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          _username = name;
        });
      }
    } catch (e) {
      debugPrint("Gagal mengambil nama pengguna: $e");

      if (mounted) {
        setState(() {
          _username = "User Bioverse";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allTopics = Provider.of<TopicController>(context).topics;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      body: Column(
        children: [
          // 1. NAVBAR KONSISTEN
          _buildNavbar(context, _username),

          // 2. KONTEN UTAMA
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ValueListenableBuilder<List<String>>(
                valueListenable: BookmarkController.bookmarkedTopicTitles,
                builder: (context, savedTitles, _) {
                  // Filter berdasarkan bookmark & search query
                  final savedTopics = allTopics.where((topic) {
                    final isSaved = savedTitles.contains(topic.title);
                    final matchesSearch = topic.title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        topic.description
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                    return isSaved && matchesSearch;
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER & SEARCH BAR
                      Row(
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saved Topics',
                                style: TextStyle(
                                  color: darkGreen,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Materi yang kamu simpan untuk dipelajari nanti.',
                                style: TextStyle(
                                    color: Color(0xFF68766D), fontSize: 13),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // SEARCH BAR FILTER BOOKMARK
                          Container(
                            width: 260,
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: const InputDecoration(
                                      hintText: 'Cari materi simpanan...',
                                      hintStyle: TextStyle(
                                          color: Color(0xFF9EAFA4),
                                          fontSize: 13),
                                      border: InputBorder.none,
                                      isCollapsed: true,
                                    ),
                                    style: const TextStyle(
                                        fontSize: 13, color: darkGreen),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // DAFTAR BOOKMARK
                      if (savedTopics.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Column(
                              children: [
                                Icon(Icons.bookmark_border_rounded,
                                    size: 64, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'Materi tidak ditemukan'
                                      : 'Belum ada materi yang disimpan',
                                  style: const TextStyle(
                                    color: darkGreen,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'Coba gunakan kata kunci pencarian yang lain.'
                                      : 'Simpan materi dari Dashboard untuk mempermudah akses belajar.',
                                  style: const TextStyle(
                                      color: Colors.black45, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: savedTopics.length,
                          itemBuilder: (context, index) {
                            final topic = savedTopics[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: const Color(0xFFE3ECE5)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => TopicDetailPage(
                                                topic: topic),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFE8F5EC),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                    icon: const Icon(Icons.bookmark_rounded,
                                        color: green),
                                    onPressed: () {
                                      BookmarkController.removeBookmark(
                                          topic.title);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET NAVBAR KONSISTEN
  Widget _buildNavbar(BuildContext context, String userName) {
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
          const Spacer(),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DashboardPage()),
                (route) => false,
              );
            },
            child: const Text('Dashboard',
                style:
                    TextStyle(color: darkGreen, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}