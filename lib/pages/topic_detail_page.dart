import 'package:flutter/material.dart';
import '../models/biology_topic.dart';

class TopicDetailPage extends StatelessWidget {
  final BiologyTopic topic;

  const TopicDetailPage({
    super.key,
    required this.topic,
  });

  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);
  static const Color lightGreen = Color(0xFFF0FDF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: darkColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          topic.title,
          style: const TextStyle(
            color: darkColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 60,
          vertical: 40,
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1000,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ==============================
                // HEADER TOPIK
                // ==============================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        primaryColor,
                        darkColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    borderRadius: BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(
                          alpha: 0.15,
                        ),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // CATEGORY
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),

                        child: Text(
                          topic.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // TITLE
                      Text(
                        topic.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // DESCRIPTION
                      Text(
                        topic.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // LEVEL
                      Row(
                        children: [
                          const Icon(
                            Icons.signal_cellular_alt,
                            color: Colors.white70,
                            size: 18,
                          ),

                          const SizedBox(width: 8),

                          Text(
                            'Level: ${topic.level}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ==============================
                // MATERI
                // ==============================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(35),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(
                          alpha: 0.06,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Row(
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            color: primaryColor,
                            size: 26,
                          ),

                          SizedBox(width: 10),

                          Text(
                            'Materi Pembelajaran',
                            style: TextStyle(
                              color: darkColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      Text(
                        topic.content,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ==============================
                // BACK BUTTON
                // ==============================

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.arrow_back,
                    ),

                    label: const Text(
                      'Kembali ke Topik',
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,

                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}