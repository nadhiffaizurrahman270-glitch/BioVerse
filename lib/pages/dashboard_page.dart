import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/cell_background.dart';
import 'login_page.dart';
import 'about_page.dart';
import 'package:flutter_projek_1/models/biology_topic.dart';

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
        description: 'Explore DNA and Genetic information', 
        category: 'Genetics', 
        level: 'Beginner'
      ),
      BiologyTopic(
        title: 'Cell Biology',
        description: 'Learn about cells and their organelles', 
        category: 'Cells', 
        level: 'Beginner'
      ),
      BiologyTopic(
        title: 'Viruses',
        description: 'Explore virus structure and replication', 
        category: 'Microbiology', 
        level: 'Intermediate'
      ),
      BiologyTopic(
        title: 'Life & Ecosystems',
        description: 'Understand organisms and their environment', 
        category: 'Ecology', 
        level: 'Intermediate'
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
            'Welcome back,\n$userName 👋',
            style: const TextStyle(
              fontSize: 42,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: darkColor,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Explore the fascinating world of biology '
            'through interactive learning, visual exploration, '
            'and engaging experiences.',
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

// ======================================================
// TOPIC CARD
// ======================================================

class _TopicCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TopicCard({
    required this.icon,
    required this.title,
    required this.description,
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

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ),

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

                borderRadius:
                    BorderRadius.circular(15),
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
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                mainAxisAlignment:
                    MainAxisAlignment.center,

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
                ],
              ),
            ),

            AnimatedOpacity(
              opacity: hovered ? 1 : 0,

              duration:
                  const Duration(milliseconds: 200),

              child: const Icon(
                Icons.arrow_forward,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
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