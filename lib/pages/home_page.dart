import 'package:flutter/material.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const green = Color(0xFF16804A);
  static const darkGreen = Color(0xFF12372A);
  static const paleGreen = Color(0xFFE8F5EC);

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

  Widget _nav(BuildContext context, String label, GlobalKey key) => TextButton(
        onPressed: () => _scroll(context, key),
        child: Text(label,
            style: const TextStyle(
                color: darkGreen, fontWeight: FontWeight.w600)),
      );

  Widget _topic(IconData icon, String number, String title,
      String description, String tag) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE3ECE5)),
          boxShadow: [
            BoxShadow(
              color: darkGreen.withValues(alpha: .04),
              blurRadius: 20,
              offset: const Offset(0, 7),
            )
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                  color: paleGreen, borderRadius: BorderRadius.circular(17)),
              child: Icon(icon, color: green, size: 30),
            ),
            Text(number,
                style: const TextStyle(
                    color: Color(0xFFD6E5D9),
                    fontSize: 25,
                    fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 20),
          Text(title,
              style: const TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 9),
          Expanded(
            child: Text(description,
                style: const TextStyle(
                    color: Color(0xFF68766D), fontSize: 13, height: 1.6)),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
                color: paleGreen, borderRadius: BorderRadius.circular(30)),
            child: Text(tag,
                style: const TextStyle(
                    color: green,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .5)),
          ),
        ]),
      );

  Widget _feature(IconData icon, String title, String description) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
                color: paleGreen, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: green, size: 27),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      color: darkGreen,
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
    final homeKey = GlobalKey();
    final learnKey = GlobalKey();
    final exploreKey = GlobalKey();
    final aboutKey = GlobalKey();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      body: SingleChildScrollView(
        child: Column(children: [
          // White navbar
          Container(
            key: homeKey,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
            child: Row(children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: green, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.eco_rounded,
                    color: Colors.white, size: 25),
              ),
              const SizedBox(width: 10),
              const Text('BioVerse',
                  style: TextStyle(
                      color: darkGreen,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.5)),
              const Spacer(),
              if (wide) ...[
                _nav(context, 'Home', homeKey),
                _nav(context, 'Learn', learnKey),
                _nav(context, 'Explore', exploreKey),
                _nav(context, 'About', aboutKey),
                const SizedBox(width: 12),
              ],
              ElevatedButton(
                onPressed: () => _login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Sign In',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ]),
          ),

          // Dark green hero with an auto-playing feature carousel
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
                      color: green.withValues(alpha: .16)),
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
                  const Expanded(flex: 5, child: _HeroCarousel()),
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
                    const _HeroCarousel(),
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
                crossAxisCount: width >= 1100 ? 4 : width >= 650 ? 2 : 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: width >= 1100
                    ? .95
                    : width >= 650
                        ? 1.1
                        : 1.7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _topic(Icons.biotech_rounded, '01', 'DNA & Genetics',
                      'Explore genetic information, DNA structures, and the traits that make organisms unique.', 'GENETICS'),
                  _topic(Icons.bubble_chart_rounded, '02', 'Cell Biology',
                      'Discover cells, their organelles, and how these tiny building blocks keep life running.', 'MICRO WORLD'),
                  _topic(Icons.coronavirus_outlined, '03', 'Viruses',
                      'Understand virus structures, how they spread, and their relationship with living organisms.', 'VIROLOGY'),
                  _topic(Icons.eco_rounded, '04', 'Life & Ecosystems',
                      'Learn how organisms interact with each other and the environments they call home.', 'ECOLOGY'),
                ],
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
                                color: green,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2)),
                        SizedBox(height: 12),
                        Text('Learn biology\nyour way.',
                            style: TextStyle(
                                color: darkGreen,
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
                          backgroundColor: green,
                          foregroundColor: Colors.white,
                          elevation: 0),
                      child: const Text('Continue Learning'),
                    ),
                  ])
                : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('YOUR LEARNING SPACE',
                        style: TextStyle(
                            color: green,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2)),
                    const SizedBox(height: 12),
                    const Text('Learn biology your way.',
                        style: TextStyle(
                            color: darkGreen,
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
                          backgroundColor: green,
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
            OutlinedButton(
              onPressed: onExplore,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 17),
                side: BorderSide(color: Colors.white.withValues(alpha: .3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11)),
              ),
              child: const Text('Explore Topics',
                  style: TextStyle(fontWeight: FontWeight.w700)),
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
  const _HeroCarousel();

  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  bool _paused = false;
  late final List<_CarouselSlideData> _slides = [
    _CarouselSlideData(
      eyebrow: 'YOUR LEARNING JOURNEY',
      title: 'Build your\nlearning streak.',
      description: 'Small steps every day lead to big discoveries.',
      icon: Icons.local_fire_department_rounded,
      accent: const Color(0xFFFFC36A),
      action: 'Start your journey',
      type: _SlideType.progress,
    ),
    _CarouselSlideData(
      eyebrow: 'FEATURED TOPIC',
      title: 'Explore the\nworld of cells.',
      description: 'Discover organelles and the tiny systems that make life work.',
      icon: Icons.bubble_chart_rounded,
      accent: const Color(0xFF8BE0A7),
      action: 'Discover biology',
      type: _SlideType.topic,
    ),
    _CarouselSlideData(
      eyebrow: 'LEARN BY PLAYING',
      title: 'Ready for a\nbiology challenge?',
      description: 'Test your knowledge with quick interactive quizzes.',
      icon: Icons.quiz_rounded,
      accent: const Color(0xFF9EDCFF),
      action: 'Try a quiz',
      type: _SlideType.quiz,
    ),
    _CarouselSlideData(
      eyebrow: 'YOUR ACHIEVEMENTS',
      title: 'Every discovery\ndeserves a badge.',
      description: 'Collect milestones as you explore more biology topics.',
      icon: Icons.emoji_events_rounded,
      accent: const Color(0xFFFFD779),
      action: 'View achievements',
      type: _SlideType.achievement,
    ),
    _CarouselSlideData(
      eyebrow: 'MAKE IT YOURS',
      title: 'Meet your\nBioVerse avatar.',
      description: 'Choose an avatar and make your learning profile your own.',
      icon: Icons.face_rounded,
      accent: const Color(0xFFC9B5FF),
      action: 'Customize avatar',
      type: _SlideType.avatar,
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
        constraints: const BoxConstraints(minHeight: 390, maxHeight: 440),
        decoration: BoxDecoration(
          color: const Color(0xFF174936),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withValues(alpha: .11)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .14),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) => _buildSlide(_slides[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                final selected = index == _currentPage;
                return GestureDetector(
                  onTap: () => _goToPage(index),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
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
        ]),
      ),
    );
  }

  Widget _buildSlide(_CarouselSlideData slide) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(slide.eyebrow,
                  style: const TextStyle(
                      color: Color(0xFFB6E9C5),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4)),
            ),
            Text('${_currentPage + 1}'.padLeft(2, '0') + ' / 05',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: .45),
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 24),
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: slide.accent.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: slide.accent.withValues(alpha: .24)),
            ),
            child: Icon(slide.icon, color: slide.accent, size: 40),
          ),
          const SizedBox(height: 22),
          Text(slide.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  height: 1.12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.5)),
          const SizedBox(height: 12),
          Text(slide.description,
              style: const TextStyle(
                  color: Color(0xFFC3D6CA), fontSize: 13, height: 1.6)),
          const SizedBox(height: 18),
          _slideExtra(slide),
          const Spacer(),
          Row(children: [
            Text(slide.action,
                style: TextStyle(
                    color: slide.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w800)),
            const SizedBox(width: 7),
            Icon(Icons.arrow_forward_rounded, color: slide.accent, size: 16),
          ]),
        ],
      ),
    );
  }

  Widget _slideExtra(_CarouselSlideData slide) {
    switch (slide.type) {
      case _SlideType.progress:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('LEVEL 04',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12)),
            const Spacer(),
            Text('750 / 1000 XP',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: .7), fontSize: 10)),
          ]),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: .75,
              minHeight: 7,
              backgroundColor: Color(0xFF315D49),
              valueColor: AlwaysStoppedAnimation(Color(0xFF8BE0A7)),
            ),
          ),
        ]);
      case _SlideType.topic:
        return const _MiniPill(icon: Icons.menu_book_rounded, label: 'BIOLOGY TOPICS');
      case _SlideType.quiz:
        return const _MiniPill(icon: Icons.bolt_rounded, label: 'EARN XP AS YOU LEARN');
      case _SlideType.achievement:
        return const Row(children: [
          _MiniBadge(icon: Icons.eco_rounded),
          SizedBox(width: 9),
          _MiniBadge(icon: Icons.biotech_rounded),
          SizedBox(width: 9),
          _MiniBadge(icon: Icons.science_rounded),
        ]);
      case _SlideType.avatar:
        return Row(children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: slide.accent.withValues(alpha: .16),
              border: Border.all(color: slide.accent.withValues(alpha: .55)),
            ),
            child: Icon(Icons.face_rounded, color: slide.accent, size: 29),
          ),
          const SizedBox(width: 11),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Biology Explorer',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800)),
            SizedBox(height: 3),
            Text('Your profile, your style',
                style: TextStyle(color: Color(0xFFB6E9C5), fontSize: 10)),
          ]),
        ]);
    }
  }
}

enum _SlideType { progress, topic, quiz, achievement, avatar }

class _CarouselSlideData {
  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final String action;
  final _SlideType type;

  const _CarouselSlideData({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.action,
    required this.type,
  });
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MiniPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: .1)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: const Color(0xFF8BE0A7), size: 15),
          const SizedBox(width: 7),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFFD1E2D6),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .5)),
        ]),
      );
}

class _MiniBadge extends StatelessWidget {
  final IconData icon;
  const _MiniBadge({required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD779).withValues(alpha: .13),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFFFFD779).withValues(alpha: .3)),
        ),
        child: Icon(icon, color: const Color(0xFFFFD779), size: 20),
      );
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
