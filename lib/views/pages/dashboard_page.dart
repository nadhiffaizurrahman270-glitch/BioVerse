import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_projek_1/services/auth_service.dart';
import '../widgets/cell_background.dart';
import 'login_page.dart';
import 'about_page.dart';
import 'package:flutter_projek_1/models/biology_topic.dart';
import '../topic_detail_page.dart';
import 'package:flutter_projek_1/controllers/progress_controller.dart';
import 'package:flutter_projek_1/models/quiz_progress.dart';
import 'package:flutter_projek_1/models/achievement.dart';
import 'package:flutter_projek_1/controllers/achievement_controller.dart';
import 'package:flutter_projek_1/controllers/learning_stats_controller.dart';
import 'explore_page.dart';
import 'package:flutter_projek_1/models/user_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}


class BioVerseAvatar extends StatelessWidget {
  final int avatarIndex;
  final double radius;
  final String? photoUrl;

  const BioVerseAvatar({
    super.key,
    required this.avatarIndex,
    this.radius = 28,
    this.photoUrl,
  });

  static const Color primaryColor = Color(0xFF166534);

  // Path PNG avatar BioVerse.
  static const List<String> avatars = [
    'assets/image/avatars/avatar_1.png',
    'assets/image/avatars/avatar_2.png',
    'assets/image/avatars/avatar_3.png',
    'assets/image/avatars/avatar_4.png',
    'assets/image/avatars/avatar_5.png',
    'assets/image/avatars/avatar_6.png',
    'assets/image/avatars/avatar_7.png',
  ];

  @override
  Widget build(BuildContext context) {
    final safeIndex = avatarIndex >= 0 && avatarIndex < avatars.length
        ? avatarIndex
        : 0;

    return CircleAvatar(
      radius: radius,
      backgroundColor: primaryColor,
      child: ClipOval(
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: Image.asset(
            avatars[safeIndex],
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.person_rounded,
                size: radius,
                color: Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  _DashboardPageState();

  int _avatarIndex = 0;

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

  final GlobalKey _dashboardKey = GlobalKey();
  final GlobalKey _exploreKey = GlobalKey();
  final GlobalKey _learnKey = GlobalKey();

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
    _loadUserAvatar();

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

  Future<void> _loadUserAvatar() async {
    final user = AuthService.currentUser;

    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final value = doc.data()?['avatarIndex'];

      if (!mounted) return;

      setState(() {
        if (value is num &&
            value.toInt() >= 0 &&
            value.toInt() < BioVerseAvatar.avatars.length) {
          _avatarIndex = value.toInt();
        } else {
          _avatarIndex = 0;
        }
      });
    } catch (e) {
      debugPrint('Gagal memuat avatar: $e');
    }
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final targetContext = key.currentContext;
    if (targetContext == null) return;

    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    final userName = user?.displayName ?? 'Explorer';

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

          Positioned.fill(
            child: Column(
              children: [
                _buildNavbar(userName),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildHero(userName),
                        _buildLearningStats(),
                        _buildExploreSection(),
                      ],
                    ),
                  ),
                ),
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
            _navButton('Dashboard', onTap: () => _scrollTo(_dashboardKey)),
            const SizedBox(width: 10),
            _navButton('Learn', onTap: () => _scrollTo(_learnKey)),
            const SizedBox(width: 10),
            _navButton(
              'Explore',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExplorePage(
                      topics: topics,
                    ),
                  ),
                );
              },
            ),

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
            onProfileUpdated: _loadUserAvatar,
          ),
        ],
      ),
    );
  }

  Widget _navButton(
    String title, {
    required VoidCallback onTap
    }) {
    return TextButton(
      onPressed: onTap,

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
      key: _dashboardKey,
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

  Widget _buildLearningStats() {
    final stats = LearningStatsController.stats;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 24,
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
                'YOUR LEARNING PROGRESS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12372A),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isSmall = constraints.maxWidth < 650;

                  final cards = [
                    _LearningStatCard(
                      icon: Icons.bolt_rounded,
                      title: 'Total XP',
                      value: '${stats.totalXp}',
                      subtitle: 'Experience Points earned',
                      color: const Color(0xFFFFC857),
                    ),
                    _LearningStatCard(
                      icon: Icons.local_fire_department_rounded,
                      title: 'Learning Streak',
                      value: '${stats.streak} days',
                      subtitle: 'Keep learning every day',
                      color: const Color(0xFFFF8A65),
                    ),
                    _LearningStatCard(
                      icon: Icons.workspace_premium_rounded,
                      title: 'Level ${stats.level}',
                      value: '${stats.xpInCurrentLevel}/${stats.xpForNextLevel} XP',
                      subtitle: '${stats.completedQuizzes} quizzes completed',
                      color: const Color(0xFF66BB6A),
                      progress: stats.levelProgress,
                    ),
                  ];

                  if (isSmall) {
                    return Column(
                      children: cards
                          .map((card) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: card,
                              ))
                          .toList(),
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: cards
                        .map((card) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: card,
                              ),
                            ))
                        .toList(),
                  );
                },
              ), 
            ]
          )
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
                onPressed: () => _scrollTo(_learnKey),

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
                onPressed: () => _scrollTo(_exploreKey),

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

              BioVerseAvatar(
                avatarIndex: _avatarIndex,
                radius: _virusHovered ? 88 : 78,
                photoUrl: AuthService.currentUser?.photoURL,
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
    // Topik yang sudah memiliki progres tetapi skornya belum maksimal.
    final continueTopics = topics.where((topic) {
      final progress = ProgressController.getProgress(topic.title);
      final isCompleted =
          LearningStatsController.isTopicCompleted(topic.title);

      return progress != null && !isCompleted;
    }).toList();

    final recommendedTopics = topics.where((topic) {
      final progress = ProgressController.getProgress(topic.title);
      final isCompleted =
          LearningStatsController.isTopicCompleted(topic.title);

      return progress == null && !isCompleted;
    }).toList();

    final completedTopics = topics.where((topic) {
      return LearningStatsController.isTopicCompleted(topic.title);
    }).toList();

    return Padding(
      key: _exploreKey,
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
              // ========================================
              // 1. CONTINUE LEARNING
              // ========================================

              Text(
                'Continue Learning',
                key: _learnKey,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Pick up where you left off and keep exploring.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              _buildTopicGrid(
                topicList: continueTopics,
                emptyMessage: 'No topics to continue yet',
                emptyDescription: 'Start exploring biology to see your learning progress here.',
              ),

              const SizedBox(height: 48),

              // ========================================
              // 2. RECOMMENDED TOPICS
              // ========================================

              const Text(
                'Recommended Topics',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Discover new topics and expand your biology knowledge.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 24),

              _buildTopicGrid(
                topicList: recommendedTopics,
                emptyMessage: 'You have explored all topics!',
                emptyDescription: 'Great job! You have started learning every available topic.',
              ),

              const SizedBox(height: 48),

              const Text(
                'Completed Learning',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Review the biology topics you have completed.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 24),

              _buildTopicGrid(
                topicList: completedTopics,
                emptyMessage: 'No completed topics yet',
                emptyDescription:
                    'Complete a biology quiz to see your achievements here.',
              ),

              // ========================================
              // 3. RECENT ACHIEVEMENTS
              // ========================================

              const SizedBox(height: 24),
              const Text(
                'Recent Achievements',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Celebrate your progress and milestones.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 24),

              const _AchievementSection(),
            ],
          ),
        ),
      ),
    );
  }
  
Widget _buildTopicGrid({
  required List<BiologyTopic> topicList,
  required String emptyMessage,
  required String emptyDescription,
}) {
  if (topicList.isEmpty) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.menu_book_outlined,
            size: 40,
            color: Color(0xFF166534),
          ),
          const SizedBox(height: 12),
          Text(
            emptyMessage,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF12372A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            emptyDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  return LayoutBuilder(
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
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
          mainAxisExtent: 190,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemCount: topicList.length,
        itemBuilder: (context, index) {
          final topic = topicList[index];

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
                if (!mounted) return;
                setState(() {});
              });
            },
          );
        },
      );
    },
  );
}
    }
    
class _AchievementSection extends StatelessWidget {
  const _AchievementSection();

  @override
  Widget build(BuildContext context) {
    final achievements = AchievementController.getAchievements();

    final unlockedCount =
        achievements.where((item) => item.unlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$unlockedCount/${achievements.length}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: achievements.map((achievement) {
            return _AchievementBadge(
              achievement: achievement,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _LearningStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final double? progress;

  const _LearningStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 170,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE1EFE4),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF12372A).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF12372A),
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: const Color(0xFFE8F1E9),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF166534),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final Achievement achievement;

  const _AchievementBadge({
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;

    return Tooltip(
      message: '${achievement.title}\n${achievement.description}',
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: unlocked
              ? Colors.white.withValues(alpha: 0.13)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(
              alpha: unlocked ? 0.35 : 0.10,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: unlocked ? 1.0 : 0.28,
              child: Text(
                achievement.icon,
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Icon(
              unlocked
                  ? Icons.check_circle
                  : Icons.lock_outline,
              size: 13,
              color: unlocked
                  ? const Color(0xFF86EFAC)
                  : Colors.white30,
            ),

            const SizedBox(height: 5),

            Text(
              achievement.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(
                  alpha: unlocked ? 0.95 : 0.35,
                ),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
    final progress = ProgressController.getProgress(widget.topic.title);

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
            hovered ? -4 : 0,
            0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hovered
                  ? primaryColor.withValues(alpha: 0.35)
                  : Colors.white,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(
                  alpha: hovered ? 0.13 : 0.05,
                ),
                blurRadius: hovered ? 18 : 10,
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  widget.icon,
                  color: primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: darkColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: Colors.black54,
                      ),
                    ),
                    if (progress != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${progress.score}/${progress.totalQuestions}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF166534),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress.percentage,
                          minHeight: 5,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF166534),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress.percentage * 100).toInt()}% selesai',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                      ),
                    ],
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
      final progress = ProgressController.getProgress(topic.title);
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
  final Future<void> Function() onProfileUpdated;

  const _ProfileMenu({
    required this.userName,
    required this.onLogout,
    required this.onProfileUpdated,
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
      'title': 'Edit Profile',
      'icon': Icons.person_outline,
    },
    {
      'title': 'My Progress',
      'icon': Icons.insights_outlined,
    },
    {
      'title': 'Achievements',
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

                  onTap: () async {
                    _hideMenu();

                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserProfilePage(),
                    ),
                  );

                  if (!mounted) return;

                  if (result == true) {
                    await widget.onProfileUpdated();
                  }
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