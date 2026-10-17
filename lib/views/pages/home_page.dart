import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import '../../models/biology_topic.dart';
import 'topic_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const green = Color(0xFF16804A);
  static const darkGreen = Color(0xFF12372A);
  static const paleGreen = Color(0xFFE8F5EC);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey homeKey = GlobalKey();
  final GlobalKey learnKey = GlobalKey();
  final GlobalKey exploreKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();

  String _searchQuery = '';

  final List<Map<String, dynamic>> _allTopics = [
    {
      'icon': Icons.biotech_rounded,
      'number': '01',
      'title': 'DNA & Genetics',
      'desc': 'Explore genetic information, DNA structures, and the traits that make organisms unique.',
      'tag': 'GENETICS',
    },
    {
      'icon': Icons.bubble_chart_rounded,
      'number': '02',
      'title': 'Cell Biology',
      'desc': 'Discover cells, their organelles, and how these tiny building blocks keep life running.',
      'tag': 'MICRO WORLD',
    },
    {
      'icon': Icons.coronavirus_outlined,
      'number': '03',
      'title': 'Viruses',
      'desc': 'Understand virus structures, how they spread, and their relationship with living organisms.',
      'tag': 'VIROLOGY',
    },
    {
      'icon': Icons.eco_rounded,
      'number': '04',
      'title': 'Life & Ecosystems',
      'desc': 'Learn how organisms interact with each other and the environments they call home.',
      'tag': 'ECOLOGY',
    },
    {
      'icon': Icons.wb_sunny_rounded,
      'number': '05',
      'title': 'Photosynthesis',
      'desc': 'The amazing process by which plants convert sunlight into food.',
      'tag': 'PLANT BIOLOGY',
    },
    {
      'icon': Icons.public_rounded,
      'number': '06',
      'title': 'Biodiversity',
      'desc': 'Learn about the various levels of diversity among living organisms on Earth.',
      'tag': 'ECOLOGY',
    },
    {
      'icon': Icons.accessibility_new_rounded,
      'number': '07',
      'title': 'Human Body Anatomy',
      'desc': 'Get to know the organ systems that work together in our body.',
      'tag': 'ANATOMY',
    },
  ];

  void _openTopic(Map<String, dynamic> topic) {
    final biologyTopic = BiologyTopic(
        id: topic['number'].toString(),
        title: topic['title'],
        description: topic['desc'],
        category: topic['tag'],
        level: 'Beginner',
        content: topic['content'] ?? 'Materi belum tersedia.',
      );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicDetailPage(
          topic: biologyTopic,
        ),
      ),
    );
  }

  void _login(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );

  void _scroll(BuildContext context, GlobalKey key) {
    final target = key.currentContext;
    if (target != null) {
      Scrollable.ensureVisible(target,
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeInOut);
    }
  }

Widget _topic(
  IconData icon,
  String number,
  String title,
  String description,
  String tag,
) =>
    InkWell(
      onTap: () {
        final topic = BiologyTopic(
          id: number,
          title: title,
          description: description,
          category: tag,
          level: 'Beginner',
          content: 'Materi belum tersedia.',
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopicDetailPage(topic: topic),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE3ECE5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: HomePage.darkGreen.withValues(alpha: .04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: HomePage.green, size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: HomePage.darkGreen,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF68766D),
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: HomePage.paleGreen,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  color: HomePage.green,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .5,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget _buildBenefitsSection(bool wide) {
      return Container(
      width: double.infinity,
      padding: EdgeInsets.all(wide ? 50 : 26),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5ED), 
        borderRadius: BorderRadius.circular(30),
      ),
      child: Flex(
        direction: wide ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: wide ? 6 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FREE ACCOUNT',
                  style: TextStyle(
                    color: HomePage.green,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Simpan progressmu.\nKapan saja, di mana saja.',
                  style: TextStyle(
                    color: HomePage.darkGreen,
                    fontSize: wide ? 42 : 32,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Belajar biologi 100% gratis. Buat akun sekarang untuk menyimpan XP, mempertahankan streak harian, dan melihat statistik belajarmu di BioVerse.',
                  style: TextStyle(
                    color: Color(0xFF4A5C51),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 30),
                Wrap(
                  spacing: 40,
                  runSpacing: 15,
                  children: [
                    _benefitCheck('Progress tracking'),
                    _benefitCheck('XP & Streaks'),
                    _benefitCheck('Interactive Quizzes'),
                    _benefitCheck('Ad-free learning'),
                  ],
                ),
              ],
            ),
          ),
          if (wide) const SizedBox(width: 40) else const SizedBox(height: 32),
          Flexible(
            flex: wide ? 4 : 1,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: HomePage.green.withValues(alpha: 0.08),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.rocket_launch_rounded,
                      color: HomePage.green, size: 36),
                  const SizedBox(height: 16),
                  const Text(
                    'Mulai dengan satu klik',
                    style: TextStyle(
                      color: HomePage.darkGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Buat akun gratis dan lanjutkan belajarmu dari mana saja.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _login(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE3ECE5)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            color: HomePage.darkGreen,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('or',
                        style: TextStyle(color: Colors.black45, fontSize: 12)),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF171717),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Sign Up',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _benefitCheck(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_rounded, color: HomePage.green, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
              color: HomePage.darkGreen,
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
      ],
    );
  }

  Widget _feature(IconData icon, String title, String description) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
                color: HomePage.paleGreen, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: HomePage.green, size: 27),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      color: HomePage.darkGreen,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(description,
                  style: const TextStyle(
                      color: Color(0xFF68766D), fontSize: 14, height: 1.6)),
            ]),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 900;
    final padding = width >= 1100 ? 76.0 : width >= 650 ? 38.0 : 22.0;
    

    final filteredTopics = _allTopics.where((topic) {
      final titleMatch =
          topic['title'].toLowerCase().contains(_searchQuery.toLowerCase());
      final descMatch =
          topic['desc'].toLowerCase().contains(_searchQuery.toLowerCase());
      return titleMatch || descMatch;
    }).toList();
    

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      body: SingleChildScrollView(
        child: Column(children: [
          // White navbar
          Container(
            key: homeKey,
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEF4F0), width: 1),
              ),
            ),
            child: Row(children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _searchQuery = '');
                    _scroll(context, homeKey);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: HomePage.green,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.eco_rounded,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 10),
                      const Text('BioVerse',
                          style: TextStyle(
                              color: HomePage.darkGreen,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -.5)),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              if (wide) ...[
                Container(
                  width: 280,
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F7F4),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE3ECE5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, 
                      color: Color(0xFF68766D), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState((){
                            _searchQuery = value;
                            });
                            if (value.isNotEmpty) _scroll(context, exploreKey);
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search topics',
                            hintStyle: TextStyle(color: Color(0xFF9EAFA4), fontSize: 14),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(fontSize: 14, color: HomePage.darkGreen),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                onPressed: () => _login(context),
                style: TextButton.styleFrom(
                  foregroundColor: HomePage.darkGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => const SignUpPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HomePage.green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
        ]),
          ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: padding, vertical: wide ? 78 : 52),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF123D2D), Color(0xFF08271E)],
              ),
            ),
            child: Stack(children: [
              Positioned(
                right: wide ? 40 : 0,
                top: 0,
                child: Container(
                  width: wide ? 230 : 100,
                  height: wide ? 230 : 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withValues(alpha: .07), width: 1.5),
                  ),
                ),
              ),
              Positioned(
                right: wide ? 90 : 25,
                top: 55,
                child: Container(
                  width: wide ? 115 : 48,
                  height: wide ? 115 : 48,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HomePage.green.withValues(alpha: .16)),
                ),
              ),
              if (wide)
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                    flex: 6,
                    child: _HeroCopy(
                      titleSize: 54,
                      onStart: () => _login(context),
                      onExplore: () => _scroll(context, exploreKey),
                    ),
                  ),
                  const SizedBox(width: 36),
                  Expanded(
                    flex: 5,
                    child: _HeroCarousel(onSignIn: () => _login(context)),
                  ),
                ])
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroCopy(
                      titleSize: width >= 600 ? 46 : 38,
                      onStart: () => _login(context),
                      onExplore: () => _scroll(context, exploreKey),
                    ),
                    const SizedBox(height: 42),
                    _HeroCarousel(onSignIn: () => _login(context)),
                  ],
                ),
            ]),
          ),

          // Topic cards
          
          Container(
            key: exploreKey,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 78),
            child: Column(children: [
              const _SectionTitle(
                eyebrow: 'EXPLORE & DISCOVER',
                title: 'Discover Biology',
                subtitle: 'Start with the fundamentals of life. Pick a topic '
                    'and begin exploring the science behind it.',
              ),
              const SizedBox(height: 40),
              GridView.count(
                crossAxisCount: width >= 1100 ? 4 : width >= 650 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: width >= 1100
                    ? 1.2
                    : width >= 650
                        ? 1.0
                        : 0.85,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: filteredTopics
                  .map((topic) => _topic(
                      topic['icon'] as IconData,
                      topic['number'] as String,
                      topic['title'] as String,
                      topic['desc'] as String,
                      topic['tag'] as String,
                    ))
                  .toList(),
              ),
            ]),
          ),

          // Learning center
          Container(
            key: learnKey,
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 78),
            child: wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('YOUR LEARNING SPACE',
                            style: TextStyle(
                              color: HomePage.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2)),
                        SizedBox(height: 12),
                        Text('Learn biology\nyour way.',
                            style: TextStyle(
                                color: HomePage.darkGreen,
                                fontSize: 38,
                                height: 1.2,
                                fontWeight: FontWeight.w800)),
                        SizedBox(height: 14),
                        Text(
                            'A simple learning space designed to help you understand concepts and keep track of your progress.',
                            style: TextStyle(
                                color: Color(0xFF68766D),
                                fontSize: 15,
                                height: 1.7)),
                      ]),
                    ),
                    const SizedBox(width: 70),
                    Expanded(
                      child: Column(children: [
                        _feature(Icons.menu_book_rounded, 'Learning Center',
                            'Explore biology topics in clear, organized learning sections.'),
                        const SizedBox(height: 25),
                        _feature(Icons.fact_check_rounded, 'Interactive Quiz',
                            'Test your understanding with short quizzes after studying a topic.'),
                        const SizedBox(height: 25),
                        _feature(Icons.trending_up_rounded, 'Learning Progress',
                            'Keep track of completed topics and your learning achievements.'),
                      ]),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: HomePage.green,
                          foregroundColor: Colors.white,
                          elevation: 0),
                      child: const Text('Start Learning'),
                    ),
                  ])
                : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('YOUR LEARNING SPACE',
                        style: TextStyle(
                            color: HomePage.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2)),
                    const SizedBox(height: 12),
                    const Text('Learn biology your way.',
                        style: TextStyle(
                            color: HomePage.darkGreen,
                            fontSize: 32,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 14),
                    const Text(
                        'Explore topics, take interactive quizzes, and keep track of your learning progress.',
                        style: TextStyle(
                            color: Color(0xFF68766D), fontSize: 15, height: 1.7)),
                    const SizedBox(height: 32),
                    _feature(Icons.menu_book_rounded, 'Learning Center',
                        'Explore biology topics in clear, organized learning sections.'),
                    const SizedBox(height: 24),
                    _feature(Icons.fact_check_rounded, 'Interactive Quiz',
                        'Test your understanding with short quizzes after studying a topic.'),
                    const SizedBox(height: 24),
                    _feature(Icons.trending_up_rounded, 'Learning Progress',
                        'Keep track of completed topics and your learning achievements.'),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: HomePage.green,
                          foregroundColor: Colors.white,
                          elevation: 0),
                      child: const Text('Continue Learning'),
                    ),
                  ]),
          ),

          // Footer / about
          Container(
            key: aboutKey,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 36),
            color: const Color(0xFF08271E),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 25,
              runSpacing: 15,
              children: const [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.eco_rounded, color: Color(0xFF78D998), size: 25),
                  SizedBox(width: 10),
                  Text('BioVerse',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900)),
                ]),
                Text('Explore life. Understand science. Grow your curiosity.',
                    style: TextStyle(color: Color(0xFFB8CEC0), fontSize: 13)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  const _SectionTitle(
      {required this.eyebrow, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(eyebrow,
            style: const TextStyle(
                color: HomePage.green,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 2)),
        const SizedBox(height: 12),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: HomePage.darkGreen,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                height: 1.2)),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFF68766D), fontSize: 15, height: 1.7)),
        ),
      ]);
}

class _HeroCopy extends StatelessWidget {
  final double titleSize;
  final VoidCallback onStart;
  final VoidCallback onExplore;

  const _HeroCopy({
    required this.titleSize,
    required this.onStart,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: .13)),
            ),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.auto_awesome_rounded,
                  color: Color(0xFF8BE0A7), size: 16),
              SizedBox(width: 8),
              Text('INTERACTIVE BIOLOGY LEARNING',
                  style: TextStyle(
                      color: Color(0xFFB6E9C5),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1)),
            ]),
          ),
          const SizedBox(height: 27),
          Text('Explore the Wonders\nof Biology.',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: titleSize,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.4)),
          const SizedBox(height: 20),
          const Text(
            'Discover life, explore science, and understand the world around '
            'you through an engaging interactive learning experience.',
            style: TextStyle(
                color: Color(0xFFC3D6CA), fontSize: 16, height: 1.75),
          ),
          const SizedBox(height: 29),
          Wrap(spacing: 12, runSpacing: 12, children: [
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF65D98B),
                foregroundColor: const Color(0xFF0D3022),
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 17),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11)),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Text('Start Learning',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                SizedBox(width: 9),
                Icon(Icons.arrow_forward_rounded, size: 18),
              ]),
            ),
          ]),
          const SizedBox(height: 28),
          const Wrap(spacing: 20, runSpacing: 10, children: [
            _HeroFact(Icons.menu_book_rounded, 'Learn at your pace'),
            _HeroFact(Icons.quiz_rounded, 'Interactive quizzes'),
            _HeroFact(Icons.trending_up_rounded, 'Track your progress'),
          ]),
        ],
      );
}

class _HeroCarousel extends StatefulWidget {
  final VoidCallback onSignIn;
  const _HeroCarousel({required this.onSignIn});

  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  bool _paused = false;

  late final List<_CarouselSlideData> _slides = [
    const _CarouselSlideData(
      eyebrow: 'YOUR LEARNING JOURNEY',
      title: 'Every step counts.',
      description: 'Learn consistently and earn XP as you explore biology.',
      icon: Icons.local_fire_department_rounded,
      accent: Color(0xFFFFC36A),
    ),
    const _CarouselSlideData(
      eyebrow: 'EXPLORE & DISCOVER',
      title: 'Discover the world of cells.',
      description: 'Explore the tiny systems that make life work.',
      icon: Icons.bubble_chart_rounded,
      accent: Color(0xFF8BE0A7),
    ),
    const _CarouselSlideData(
      eyebrow: 'LEARN BY PLAYING',
      title: 'Challenge your knowledge.',
      description: 'Practice what you learn with interactive biology quizzes.',
      icon: Icons.quiz_rounded,
      accent: Color(0xFF9EDCFF),
    ),
    const _CarouselSlideData(
      eyebrow: 'YOUR ACHIEVEMENTS',
      title: 'Celebrate every discovery.',
      description: 'Unlock badges as you make progress through biology topics.',
      icon: Icons.emoji_events_rounded,
      accent: Color(0xFFFFD779),
    ),
    const _CarouselSlideData(
      eyebrow: 'MAKE IT YOURS',
      title: 'Show your personality.',
      description: 'Customize your avatar and make your learning profile your own.',
      icon: Icons.face_rounded,
      accent: Color(0xFFC9B5FF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), _autoAdvance);
  }

  void _autoAdvance() {
    if (!mounted) return;
    if (!_paused && _controller.hasClients) {
      final next = (_currentPage + 1) % _slides.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
    Future.delayed(const Duration(seconds: 5), _autoAdvance);
  }

  void _goToPage(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _paused = true),
      onExit: (_) => setState(() => _paused = false),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 260,
          maxHeight: 275,
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF174936),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withValues(alpha: .11),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .14),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned(
              top: 2,
              right: 2,
              child: Icon(
                Icons.lock_rounded,
                color: Colors.white54,
                size: 20,
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return _buildSlide(_slides[index]);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (index) {
                      final selected = index == _currentPage;

                      return GestureDetector(
                        onTap: () => _goToPage(index),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: selected ? 25 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF8BE0A7)
                                  : Colors.white.withValues(alpha: .3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 6),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      minimumSize: const Size(0, 40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSlide(_CarouselSlideData slide) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  slide.eyebrow,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFB6E9C5),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: slide.accent.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: slide.accent.withValues(alpha: .24)),
                  ),
                  child: Icon(slide.icon, color: slide.accent, size: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 300,
                    maxHeight: constraints.maxHeight * .30,
                  ),
                  child: Text(
                    slide.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: const TextStyle(
                      color: Color(0xFFC3D6CA),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CarouselSlideData {
  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;
  final Color accent;

  const _CarouselSlideData({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
  });
}

class _HeroFact extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroFact(this.icon, this.label);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF8BE0A7), size: 18),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFFD1E2D6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      );
}
