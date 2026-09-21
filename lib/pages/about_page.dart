import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);
  static const Color backgroundColor = Color(0xFFF0FDF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

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

        title: const Text(
          'About BioVerse',
          style: TextStyle(
            color: darkColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 70,
          vertical: 50,
        ),

        children: [
          // ==========================================
          // HERO
          // ==========================================

          Container(
            padding: const EdgeInsets.all(45),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(24),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.06,
                  ),

                  blurRadius: 25,

                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: Column(
              children: [
                Container(
                  width: 75,
                  height: 75,

                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Icon(
                    Icons.biotech,
                    color: Colors.white,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Learn Biology.\nExplore Life.',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 42,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: darkColor,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'BioVerse is an interactive biology learning platform '
                  'designed to make biological concepts easier to '
                  'understand through visual exploration and '
                  'interactive learning experiences.',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 17,
                    height: 1.6,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 60),

          // ==========================================
          // WHAT IS BIOVERSE
          // ==========================================

          const Text(
            'What is BioVerse?',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: darkColor,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'BioVerse brings biology closer through a '
            'combination of visual content, interactive '
            'experiences, and structured learning.',

            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 30),

          // ==========================================
          // FEATURES
          // ==========================================

          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                shrinkWrap: true,

                physics:
                    const NeverScrollableScrollPhysics(),

                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      constraints.maxWidth > 900
                          ? 3
                          : 1,

                  crossAxisSpacing: 20,

                  mainAxisSpacing: 20,

                  childAspectRatio:
                      constraints.maxWidth > 900
                          ? 1.5
                          : 2.2,
                ),

                itemCount: 3,

                itemBuilder: (context, index) {
                  final features = [
                    {
                      'icon': Icons.visibility_outlined,
                      'title': 'Visual Learning',
                      'description':
                          'Understand biology through visual representations.',
                    },
                    {
                      'icon': Icons.touch_app_outlined,
                      'title': 'Interactive',
                      'description':
                          'Explore concepts through interactive experiences.',
                    },
                    {
                      'icon': Icons.school_outlined,
                      'title': 'Structured Learning',
                      'description':
                          'Learn biological concepts in an organized way.',
                    },
                  ];

                  final item = features[index];

                  return _FeatureCard(
                    icon: item['icon'] as IconData,
                    title: item['title'] as String,
                    description:
                        item['description'] as String,
                  );
                },
              );
            },
          ),

          const SizedBox(height: 60),

          // ==========================================
          // EXPLORE
          // ==========================================

          const Text(
            'Explore Biology',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: darkColor,
            ),
          ),

          const SizedBox(height: 25),

          _TopicCard(
            icon: Icons.biotech,
            title: 'DNA & Genetics',
            description:
                'Explore genetic information, DNA structure, '
                'replication, and inheritance.',
          ),

          _TopicCard(
            icon: Icons.coronavirus_outlined,
            title: 'Viruses',
            description:
                'Discover virus structures, replication cycles, '
                'and how viruses interact with living organisms.',
          ),

          _TopicCard(
            icon: Icons.cell_tower,
            title: 'Cells',
            description:
                'Learn about cell structures, organelles, '
                'and the processes that keep cells alive.',
          ),

          _TopicCard(
            icon: Icons.eco_outlined,
            title: 'Life & Ecosystems',
            description:
                'Explore organisms, ecosystems, and the '
                'relationships between living things.',
          ),

          const SizedBox(height: 60),

          // ==========================================
          // GOAL
          // ==========================================

          Container(
            padding: const EdgeInsets.all(40),

            decoration: BoxDecoration(
              color: darkColor,

              borderRadius: BorderRadius.circular(24),
            ),

            child: const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Our Goal',

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  'Making biology easier to see, '
                  'explore, and understand.',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          const Center(
            child: Text(
              'BioVerse • Interactive Biology Learning Platform',

              style: TextStyle(
                color: Colors.black45,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ======================================================
// FEATURE CARD
// ======================================================

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  static const Color primaryColor =
      Color(0xFF166534);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: primaryColor.withValues(
            alpha: 0.08,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 32,
          ),

          const SizedBox(height: 18),

          Text(
            title,

            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,

            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// TOPIC CARD
// ======================================================

class _TopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TopicCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  static const Color primaryColor =
      Color(0xFF166534);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,

            decoration: BoxDecoration(
              color: primaryColor.withValues(
                alpha: 0.08,
              ),

              borderRadius:
                  BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: primaryColor,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,

                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}