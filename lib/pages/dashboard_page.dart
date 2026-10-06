import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/cell_background.dart';
import 'login_page.dart';
import 'about_page.dart';
import 'package:flutter_projek_1/models/biology_topic.dart';
import 'topic_detail_page.dart';
import '../models/progress_manager.dart';
import '../models/quiz_progress.dart';
import '../models/achievement.dart';
import '../models/achievement_manager.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  _DashboardPageState();

  IconData _getTopicIcon(int index) {
    const icons = [
      Icons.biotech,
      Icons.coronavirus_outlined,
      Icons.bubble_chart_outlined,
      Icons.eco_outlined,
    ];

    return icons[index % icons.length];
  }

  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);
  static const Color lightGreen = Color(0xFFF0FDF4);

  late AnimationController _virusController;
  late AnimationController _floatingController;

  bool _virusHovered = false;

        final List<BiologyTopic> topics = [
      BiologyTopic(
        title: 'DNA & Genetics',
        description: 'Jelajah DNA dan informasi genetik', 
        category: 'Genetics', 
        level: 'Beginner',
        content: '''
DNA atau Deoxyribonucleic Acid merupakan molekul
yang menyimpan informasi genetik pada makhluk hidup.

DNA memiliki peran penting dalam menentukan dan
mewariskan karakteristik suatu organisme.

STRUKTUR DNA

DNA memiliki bentuk double helix atau heliks ganda.
Struktur ini tersusun dari unit-unit yang disebut
nukleotida.

Setiap nukleotida terdiri dari:
• Gula deoksiribosa
• Gugus fosfat
• Basa nitrogen

BASA NITROGEN

DNA memiliki empat jenis basa nitrogen, yaitu:

• Adenine (A)
• Thymine (T)
• Guanine (G)
• Cytosine (C)

Basa nitrogen tersebut memiliki pasangan tertentu:

A ↔ T
G ↔ C

FUNGSI DNA

DNA berfungsi sebagai penyimpan informasi genetik
yang diperlukan oleh organisme. Informasi tersebut
juga dapat diwariskan dari satu generasi ke generasi
berikutnya.

DNA menjadi salah satu komponen penting dalam
pewarisan sifat dan berbagai proses biologis.
''',
      ),
      BiologyTopic(
        title: 'Cell Biology',
        description: 'Pelajari tentang sel dan organ-organnya.',
        category: 'Cells',
        level: 'Beginner',
        content: '''
Sel adalah unit dasar kehidupan.
Semua makhluk hidup tersusun atas sel.

Setiap sel memiliki organel yang menjalankan fungsi tertentu.
• Inti sel mengendalikan aktivitas sel.
• Mitokondria menghasilkan energi.
• Ribosom memproduksi protein.
• Membran sel mengatur keluar masuk zat.

Sel-sel dapat membentuk jaringan, organ, dan sistem organ.
''',
      ),
      BiologyTopic(
        title: 'Viruses',
        description: 'Pelajari struktur dan replikasi virus.',
        category: 'Microbiology',
        level: 'Intermediate',
        content: '''
Virus adalah agen infeksius yang hanya dapat berkembang biak
pada sel inang.

Virus memiliki kapsid yang melindungi materi genetiknya.
Beberapa virus memiliki membran lipid di luar kapsid.

Replikasi virus biasanya terjadi setelah virus menempel
pada sel inang dan memasukkan materi genetiknya.
''',
      ),
      BiologyTopic(
        title: 'Life & Ecosystems',
        description: 'Memahami organisme dan lingkungannya',
        category: 'Ecology',
        level: 'Intermediate',
        content: '''
Ekosistem adalah hubungan antara makhluk hidup
dengan lingkungan sekitarnya.

Di dalam ekosistem, terdapat produsen, konsumen,
dan dekomposer yang saling berinteraksi.

Ketidakseimbangan ekosistem dapat memengaruhi
kehidupan berbagai organisme di dalamnya.
''',
      ),
    ];

  @override
  void initState() {
    super.initState();

    // DNA berputar terus
    _virusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    // Animasi floating
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _virusController.dispose();
    _floatingController.dispose();

    super.dispose();
  }

  void _logout() {
    AuthService.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    final userName =
        user?['name'] ?? 'Explorer';

    return Scaffold(
      backgroundColor: lightGreen,

      body: Stack(
        children: [
          // ==========================================
          // BACKGROUND SEL
          // ==========================================

          const Positioned.fill(
            child: CellBackground(),
          ),

          // ==========================================
          // MAIN CONTENT
          // ==========================================

          SingleChildScrollView(
            child: Column(
              children: [
                _buildNavbar(userName),

                _buildHero(userName),

                _buildExploreSection(),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // NAVBAR
  // ==================================================

  Widget _buildNavbar(String userName) {
    return Container(
      height: 76,

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
          ),
        ],
      ),

      child: Row(
        children: [
          // LOGO
          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.biotech,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                'BioVerse',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: darkColor,
                ),
              ),
            ],
          ),

          const Spacer(),

          // NAVIGATION
          if (MediaQuery.of(context).size.width > 700) ...[
            _navButton('Dashboard'),

            const SizedBox(width: 10),

            _navButton('Learn'),

            const SizedBox(width: 10),

            _navButton('Explore'),

            const SizedBox(width: 10),

            _navButton(
              'About',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),

            const SizedBox(width: 10),
          ],

          // USER
          _ProfileMenu(
            userName: userName,
            onLogout: _logout,
          ),
        ],
      ),
    );
  }

  Widget _navButton(String title, {VoidCallback? onTap}) {
    return TextButton(
      onPressed: onTap ?? () {},

      child: Text(
        title,
        style: const TextStyle(
          color: darkColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ==================================================
  // HERO
  // ==================================================

  Widget _buildHero(String userName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        60,
        55,
        60,
        20,
      ),

      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),

          child: Container(
            constraints: const BoxConstraints(
              minHeight: 440,
            ),

            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

                colors: [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFE5F6E9),
                ],
              ),

              borderRadius: BorderRadius.circular(30),

              border: Border.all(
                color: Colors.white,
                width: 2,
              ),

              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.12),
                  blurRadius: 35,
                  offset: const Offset(0, 15),
                ),
              ],
            ),

            child: LayoutBuilder(
              builder: (context, constraints) {
                final isSmall = constraints.maxWidth < 800;

                if (isSmall) {
                  return Column(
                    children: [
                      _buildHeroText(userName),
                      _buildAnimatedBiology(),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildHeroText(userName),
                    ),

                    Expanded(
                      flex: 4,
                      child: _buildAnimatedBiology(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroText(String userName) {
    return Padding(
      padding: const EdgeInsets.all(55),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          // BADGE
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),

            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
            ),

            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: primaryColor,
                  size: 16,
                ),

                SizedBox(width: 8),

                Text(
                  'BIOLOGY LEARNING PLATFORM',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          Text(
            'Hi, $userName',
            style: const TextStyle(
              fontSize: 42,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: darkColor,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Jelajahi dunia biologi yang memukau  '
            'melalui pembelajaran interaktif, eksplorasi visual,  '
            'dan experimen yang menarik.',
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},

                icon: const Icon(
                  Icons.play_arrow,
                ),

                label: const Text(
                  'Continue Learning',
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  elevation: 0,
                ),
              ),

              const SizedBox(width: 12),

              OutlinedButton(
                onPressed: () {},

                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),

                  side: BorderSide(
                    color: primaryColor.withValues(
                      alpha: 0.3,
                    ),
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  'Explore Biology',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================================================
  // ANIMATED BIOLOGY
  // ==================================================

  Widget _buildAnimatedBiology() {
    return SizedBox(
      height: 430,

      child: MouseRegion(
        cursor: SystemMouseCursors.click,

        onEnter: (_) {
          setState(() {
            _virusHovered = true;
          });
        },

        onExit: (_) {
          setState(() {
            _virusHovered = false;
          });
        },

        child: AnimatedScale(
          scale: _virusHovered ? 1.08 : 1.0,

          duration: const Duration(
            milliseconds: 300,
          ),

          curve: Curves.easeOut,

          child: Stack(
            alignment: Alignment.center,

            children: [
              // GLOW
              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 300,
                ),

                width: _virusHovered ? 300 : 270,
                height: _virusHovered ? 300 : 270,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: Colors.white.withValues(
                    alpha: 0.9,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(
                        alpha: _virusHovered
                            ? 0.25
                            : 0.12,
                      ),

                      blurRadius:
                          _virusHovered ? 50 : 30,
                    ),
                  ],
                ),
              ),

              // DNA
              AnimatedBuilder(
                animation: _virusController,

                builder: (context, child) {
                  final rotation =
                      math.sin(_virusController.value * math.pi * 2) * 0.08;

                  final floating =
                      math.sin(_virusController.value * math.pi * 2) * 8;

                  return Transform.translate(
                    offset: Offset(0, floating),

                    child: Transform.rotate(
                      angle: rotation,

                      child: child,
                    ),
                  );
                },

                child: Image.asset(
                  'assets/image/virus_jahat.png',
                  width: _virusHovered ? 170 : 150,
                ),
              ),

              // CELL 1
              _floatingCell(
                top: 55,
                bottom: null,
                left: null,
                right: 45,
                size: 38,
                delay: 0,
              ),

              // CELL 2
              _floatingCell(
                top: null,
                bottom: 70,
                left: 40,
                right: null,
                size: 30,
                delay: 0.5,
              ),

              // CELL 3
              _floatingCell(
                top: 125,
                bottom: null,
                left: 35,
                right: null,
                size: 22,
                delay: 1,
              ),

              // CELL 4
              _floatingCell(
                top: null,
                bottom: 115,
                left: null,
                right: 45,
                size: 25,
                delay: 1.5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _floatingCell({
    required double? top,
    required double? bottom,
    required double? left,
    required double? right,
    required double size,
    required double delay,
  }) {
    return AnimatedBuilder(
      animation: _floatingController,

      builder: (context, child) {
        final movement =
            math.sin(
              (_floatingController.value * math.pi * 2) +
                  delay,
            ) *
            10;

        return Positioned(
          top: top != null ? top + movement : null,

          bottom: bottom != null
              ? bottom - movement
              : null,

          left: left,

          right: right,

          child: child!,
        );
      },

      child: Container(
        width: size,
        height: size,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          color: Colors.white.withValues(
            alpha: 0.9,
          ),

          border: Border.all(
            color: primaryColor.withValues(
              alpha: 0.25,
            ),
            width: 2,
          ),

          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(
                alpha: 0.15,
              ),

              blurRadius: 12,
            ),
          ],
        ),

        child: Icon(
          Icons.circle,
          size: size * 0.35,
          color: primaryColor.withValues(
            alpha: 0.65,
          ),
        ),
      ),
    );
  }

  // ==================================================
  // EXPLORE SECTION
  // ==================================================

  Widget _buildExploreSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 35,
      ),

      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Explore Biology',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              _LearningProgressSummary(topics: topics),

              const SizedBox(height: 30),

              const _AchievementSection(),

              const SizedBox(height: 30),

              const SizedBox(height: 8),

              Text(
                'Choose a topic and start exploring.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 25),

              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  int count = 3;

                  if (width < 700) {
                    count = 1;
                  } else if (width < 1000) {
                    count = 2;
                  }

                  return GridView.builder(

                    shrinkWrap: true,

                    physics:
                        const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: count,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: 1.6,
                    ),

                    itemCount: topics.length,

                    itemBuilder: (context, index) {
                      final topic = topics[index];

                      return _TopicCard(
                        icon: _getTopicIcon(index),
                        title: topic.title,
                        description: topic.description,
                        topic: topic,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopicDetailPage(
                                topic: topic,
                              ),
                            ),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementSection extends StatelessWidget {
  const _AchievementSection();

  @override
  Widget build(BuildContext context) {
    final achievements =
        AchievementManager.getAchievements();

    final unlockedCount =
        achievements.where((item) => item.unlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Achievements',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$unlockedCount/${achievements.length} Unlocked',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        const Text(
          'Keep learning and unlock new achievements!',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 18),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: achievements.length,
          gridDelegate:
              const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisExtent: 145,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            return _AchievementCard(
              achievement: achievements[index],
            );
          },
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const _AchievementCard({
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: unlocked
            ? Colors.white
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: unlocked
              ? const Color(0xFF166534)
              : Colors.grey.shade300,
        ),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: unlocked
                  ? const Color(0xFFF0FDF4)
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Text(
              unlocked ? achievement.icon : '🔒',
              style: const TextStyle(
                fontSize: 27,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: unlocked
                        ? const Color(0xFF12372A)
                        : Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  achievement.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: unlocked
                        ? Colors.black54
                        : Colors.grey.shade500,
                    fontSize: 12,
                    height: 1.4,
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

// ======================================================
// TOPIC CARD
// ======================================================

class _TopicCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final BiologyTopic topic;

  const _TopicCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.topic,
    this.onTap,
  });

  @override
  State<_TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<_TopicCard> {
  bool hovered = false;

  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);

  @override
  Widget build(BuildContext context) {
    final progress = ProgressManager.getProgress(widget.topic.title);

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(
            0,
            hovered ? -6 : 0,
            0,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: hovered
                  ? primaryColor.withValues(alpha: 0.3)
                  : Colors.white,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(
                  alpha: hovered ? 0.15 : 0.06,
                ),
                blurRadius: hovered ? 25 : 15,
                offset: Offset(
                  0,
                  hovered ? 10 : 5,
                ),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  widget.icon,
                  color: primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: darkColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.black54,
                      ),
                    ),
                    if (progress != null) ...[
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${progress.score}/${progress.totalQuestions}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF166534),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress.percentage,
                          minHeight: 7,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF166534),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${(progress.percentage * 100).toInt()}% selesai',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                    AnimatedOpacity(
                      opacity: hovered ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearningProgressSummary extends StatelessWidget {
  final List<BiologyTopic> topics;

  const _LearningProgressSummary({
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return _LearningProgressBar(topics: topics);
  }
}

class _LearningProgressBar extends StatelessWidget {
  final List<BiologyTopic> topics;

  const _LearningProgressBar({
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    int completedTopics = 0;
    int totalQuestions = 0;
    int totalScore = 0;
    int bestScore = 0;

    for (final topic in topics) {
      final progress = ProgressManager.getProgress(topic.title);
      if (progress != null) {
        completedTopics++;
        totalQuestions += progress.totalQuestions;
        totalScore += progress.score;
        if (progress.score > bestScore) {
          bestScore = progress.score;
        }
      }
    }

    final double overallProgress =
        totalQuestions == 0 ? 0 : totalScore / totalQuestions;

    final int averagePercentage =
        totalQuestions == 0 ? 0 : (overallProgress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF12372A),
            Color(0xFF166534),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Learning Progress',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Track your biology learning journey',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _ProgressStat(
                  value: '$completedTopics',
                  label: 'Topics Completed',
                ),
              ),
              Expanded(
                child: _ProgressStat(
                  value: '$averagePercentage%',
                  label: 'Average Score',
                ),
              ),
              Expanded(
                child: _ProgressStat(
                  value: totalQuestions == 0 ? '0' : '$bestScore/5',
                  label: 'Best Score',
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$averagePercentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: overallProgress,
              minHeight: 9,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProgressStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _ProfileMenu extends StatefulWidget {
  final String userName;
  final VoidCallback onLogout;

  const _ProfileMenu({
    required this.userName,
    required this.onLogout,
  });

  @override
  State<_ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<_ProfileMenu> {
  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);

  bool _isOpen = false;
  OverlayEntry? _overlayEntry;

  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Dashboard',
      'icon': Icons.dashboard_outlined,
    },
    {
      'title': 'My Learning',
      'icon': Icons.menu_book_outlined,
    },
    {
      'title': 'My Progress',
      'icon': Icons.insights_outlined,
    },
    {
      'title': 'Bookmarks',
      'icon': Icons.bookmark_border,
    },
    {
      'title': 'Certificates',
      'icon': Icons.workspace_premium_outlined,
    },
    {
      'title': 'Settings',
      'icon': Icons.settings_outlined,
    },
  ];

  // ==================================================
  // BUKA DROPDOWN
  // ==================================================

  void _showMenu() {
    final renderBox =
        context.findRenderObject() as RenderBox;

    final position =
        renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: position.dy + renderBox.size.height + 8,
          left: position.dx + renderBox.size.width - 270,

          child: Material(
            color: Colors.transparent,

            child: _buildDropdown(),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      _isOpen = true;
    });
  }

  // ==================================================
  // TUTUP DROPDOWN
  // ==================================================

  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  // ==================================================
  // DROPDOWN
  // ==================================================

  Widget _buildDropdown() {
    return Container(
      width: 500,

      constraints: const BoxConstraints(
        maxHeight: 430,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Colors.black.withValues(
            alpha: 0.06,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.15,
            ),

            blurRadius: 25,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          // ==========================================
          // PROFILE HEADER
          // ==========================================

          Padding(
            padding: const EdgeInsets.all(18),

            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,

                  backgroundColor: primaryColor,

                  child: Text(
                    widget.userName.isNotEmpty
                        ? widget.userName[0]
                            .toUpperCase()
                        : 'U',

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        widget.userName,

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                        ),
                      ),

                      const SizedBox(height: 3),

                      const Text(
                        'Biology Explorer',

                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ==========================================
          // LISTVIEW BUILDER
          // ==========================================

          SizedBox(
            height: 270,

            child: ListView.builder(
              padding: EdgeInsets.zero,

              itemCount: menuItems.length,

              itemBuilder: (context, index) {
                final item = menuItems[index];

                return _ProfileMenuItem(
                  title: item['title'],
                  icon: item['icon'],

                  onTap: () {
                    _hideMenu();

                    debugPrint(
                      'Menu dipilih: ${item['title']}',
                    );
                  },
                );
              },
            ),
          ),

          const Divider(height: 1),

          // ==========================================
          // LOGOUT
          // ==========================================

          _ProfileMenuItem(
            title: 'Logout',
            icon: Icons.logout,
            danger: true,

            onTap: () {
              _hideMenu();
              widget.onLogout();
            },
          ),

          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // ==================================================
  // PROFILE BUTTON
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),

      onTap: () {
        if (_isOpen) {
          _hideMenu();
        } else {
          _showMenu();
        }
      },

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          color: primaryColor.withValues(
            alpha: 0.08,
          ),

          borderRadius: BorderRadius.circular(30),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            CircleAvatar(
              radius: 16,

              backgroundColor: primaryColor,

              child: Text(
                widget.userName.isNotEmpty
                    ? widget.userName[0]
                        .toUpperCase()
                    : 'U',

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 9),

            Text(
              widget.userName,

              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: darkColor,
              ),
            ),

            const SizedBox(width: 5),

            AnimatedRotation(
              turns: _isOpen ? 0.5 : 0,

              duration: const Duration(
                milliseconds: 200,
              ),

              child: const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    super.dispose();
  }
}

// ======================================================
// PROFILE MENU ITEM
// ======================================================

class _ProfileMenuItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;

  const _ProfileMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  @override
  State<_ProfileMenuItem> createState() =>
      _ProfileMenuItemState();
}

class _ProfileMenuItemState
    extends State<_ProfileMenuItem> {
  bool hovered = false;

  static const Color primaryColor =
      Color(0xFF166534);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hovered = true;
        });
      },

      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },

      child: InkWell(
        onTap: widget.onTap,

        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 150,
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 13,
          ),

          color: hovered
              ? primaryColor.withValues(
                  alpha: 0.07,
                )
              : Colors.transparent,

          child: Row(
            children: [
              Icon(
                widget.icon,

                size: 20,

                color: widget.danger
                    ? Colors.red.shade600
                    : primaryColor,
              ),

              const SizedBox(width: 13),

              Text(
                widget.title,

                style: TextStyle(
                  fontSize: 14,

                  fontWeight: FontWeight.w500,

                  color: widget.danger
                      ? Colors.red.shade600
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}