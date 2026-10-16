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
                  'BioVerse merupakan platform pembelajaran biologi interaktif '
                  'yang dirancang untuk mempermudah pemahaman konsep-konsep biologi '
                  'melalui eksplorasi visual dan '
                  'pengalaman belajar yang interaktif.',

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
            'BioVerse dirancang untuk melakukan pendekatan biologi melalui sebuah '
            'kombinasi konten visual dan interaktif '
            'experimen, dan pembelajaran terstruktur.',

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
                          'Memahami biologi melalui representasi visual.',
                    },
                    {
                      'icon': Icons.touch_app_outlined,
                      'title': 'Interactive',
                      'description':
                          'Menjelajahi berbagai konsep melalui pengalaman interaktif.',
                    },
                    {
                      'icon': Icons.school_outlined,
                      'title': 'Structured Learning',
                      'description':
                          'Mempelajari konsep-konsep biologi secara terorganisasi.',
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
                'Menjelajahi informasi genetik dan struktur DNA., '
                'Replikasi, dan Pewarisan.',
          ),

          _TopicCard(
            icon: Icons.coronavirus_outlined,
            title: 'Viruses',
            description:
                'Mempelajari struktur virus dan siklus replikasinya., '
                'dan bagaimana virus berinteraksi dengan organisme hidup.',
          ),

          _TopicCard(
            icon: Icons.cell_tower,
            title: 'Cells',
            description:
                'Mempelajari tentang struktur sel dan organel., '
                'and the processes that keep cells alive.',
          ),

          _TopicCard(
            icon: Icons.eco_outlined,
            title: 'Life & Ecosystems',
            description:
                'Menjelajahi organisme, ekosistem, dan '
                'hubungan antara makhluk hidup.',
          ),

          const SizedBox(height: 20),

          // ==========================================
          // MEET THE CREATOR
          // ==========================================

          const SizedBox(height: 10),

const Text(
  'Meet the Creator',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: darkColor,
  ),
  textAlign: TextAlign.center,
),

const SizedBox(height: 10),

Text(
  'Get to know the person behind BioVerse.',
  style: TextStyle(
    fontSize: 15,
    color: Colors.black.withValues(alpha: 0.55),
  ),
  textAlign: TextAlign.center,
),

const SizedBox(height: 35),

Container(
  width: double.infinity,
  padding: const EdgeInsets.all(32),
  decoration: BoxDecoration(
    color: Colors.white.withValues(alpha: 0.95),
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.08),
        blurRadius: 25,
        offset: const Offset(0, 10),
      ),
    ],
  ),
  child: Column(
    children: [

      // ===============================
      // PROFILE
      // ===============================

      Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          image: const DecorationImage(
            image: AssetImage(
              'assets/image/NADIP DI TP.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),

      const SizedBox(height: 20),

      const Text(
        'Muhammad Nadhif Faizurrahman',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          color: darkColor,
        ),
        textAlign: TextAlign.center,
      ),

      const SizedBox(height: 5),

      Text(
        'Nadip',
        style: TextStyle(
          fontSize: 15,
          color: primaryColor.withValues(alpha: 0.8),
          fontWeight: FontWeight.w600,
        ),
      ),

      const SizedBox(height: 8),

      Text(
        'Student & BioVerse Creator',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black.withValues(alpha: 0.5),
        ),
      ),

      const SizedBox(height: 40),

      // ===============================
      // PERSONAL INFORMATION
      // ===============================

      _CreatorSectionTitle(
        icon: Icons.person_outline,
        title: 'Personal Information',
      ),

      const SizedBox(height: 18),

      _CreatorInfoGrid(
        items: const [
          _CreatorInfoItem(
            icon: Icons.badge_outlined,
            title: 'Full Name',
            value: 'Muhammad Nadhif Faizurrahman',
          ),
          _CreatorInfoItem(
            icon: Icons.face_outlined,
            title: 'Nickname',
            value: 'Nadip',
          ),
          _CreatorInfoItem(
            icon: Icons.cake_outlined,
            title: 'Place & Date of Birth',
            value: 'Ngawi, 26 November 2006',
          ),
          _CreatorInfoItem(
            icon: Icons.location_on_outlined,
            title: 'Address',
            value: 'H8M7+VGG, Jl. Raya Kedunggalar, RT.01/RW.11, Ngarengan, Jenggrik, Kec. Kedunggalar, Kabupaten Ngawi, Jawa Timur 63254',
          ),
          _CreatorInfoItem(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: '085336017722',
          ),
          _CreatorInfoItem(
            icon: Icons.email_outlined,
            title: 'Email',
            value: 'nadhiffaizurrahman270@gmail.com',
          ),
        ],
      ),

      const SizedBox(height: 45),

      // ===============================
      // EDUCATION
      // ===============================

      _CreatorSectionTitle(
        icon: Icons.school_outlined,
        title: 'Education',
      ),

      const SizedBox(height: 18),

      _EducationCard(
        icon: Icons.account_balance,
        title: 'University',
        institution: 'Universitas Negeri Surabaya',
        detail: 'Teknik Informatika • Fakultas Teknik • Angkatan 2025',
      ),

      const SizedBox(height: 14),

      _EducationCard(
        icon: Icons.school_outlined,
        title: 'Sekolah Menengah Atas',
        institution: 'MA Darul Huda',
        detail: 'Agama',
      ),

      const SizedBox(height: 45),

      // ===============================
      // ABOUT ME
      // ===============================

      _CreatorSectionTitle(
        icon: Icons.auto_awesome_outlined,
        title: 'About Me',
      ),

      const SizedBox(height: 18),

      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.08),
          ),
        ),
        child: const Text(
          'Saya adalah mahasiswa Teknik Informatika yang tertarik pada pengembangan perangkat lunak,  '
          'platform pembelajaran interaktif, dan teknologi '
          'BioVerse merupakan salah satu proyek saya yang dikembangkan untuk memadukan teknologi dan pendidikan biologi menjadi sebuah pengalaman belajar yang interaktif.',
          style: TextStyle(
            fontSize: 15,
            height: 1.7,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ),

      const SizedBox(height: 45),

      // ===============================
      // CONNECT WITH ME
      // ===============================

      _CreatorSectionTitle(
        icon: Icons.link_outlined,
        title: 'Connect With Me',
      ),

      const SizedBox(height: 18),

      Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          _SocialButton(
            icon: Icons.code,
            label: 'GitHub',
            onTap: () {
              // TODO: buka GitHub
            },
          ),

          _SocialButton(
            icon: Icons.camera_alt_outlined,
            label: 'Instagram',
            onTap: () {
              // TODO: buka Instagram
            },
          ),

          _SocialButton(
            icon: Icons.work_outline,
            label: 'LinkedIn',
            onTap: () {
              // TODO: buka LinkedIn
            },
          ),

          _SocialButton(
            icon: Icons.email_outlined,
            label: 'Email',
            onTap: () {
              // TODO: buka Email
            },
          ),

          _SocialButton(
            icon: Icons.language,
            label: 'Portfolio',
            onTap: () {
              // TODO: buka Portfolio
            },
          ),
        ],
      ),

      ],
    ),
  ),

      const SizedBox(height: 45),

          const SizedBox(height: 10),

          // ==========================================
          // GOAL
          // ==========================================

          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Membuat biologi lebih mudah dilihat, dijelajahi, dan dipahami.',
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
              'BioVerse • Platform Pembelajaran Biologi Interaktif',
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

  static const Color primaryColor = Color(0xFF166534);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  static const Color primaryColor = Color(0xFF166534);

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
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

// =====================================================
// CREATOR SECTION TITLE
// =====================================================

class _CreatorSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CreatorSectionTitle({
    required this.icon,
    required this.title,
  });

  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 22,
          ),
        ),

        const SizedBox(width: 12),

        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: darkColor,
          ),
        ),
      ],
    );
  }
}


// =====================================================
// CREATOR INFO ITEM
// =====================================================

class _CreatorInfoItem {
  final IconData icon;
  final String title;
  final String value;

  const _CreatorInfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });
}


// =====================================================
// CREATOR INFO GRID
// =====================================================

class _CreatorInfoGrid extends StatelessWidget {
  final List<_CreatorInfoItem> items;

  const _CreatorInfoGrid({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int count;

        if (constraints.maxWidth > 900) {
          count = 3;
        } else if (constraints.maxWidth > 600) {
          count = 2;
        } else {
          count = 1;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 135,
          ),

          itemCount: items.length,

          itemBuilder: (context, index) {
            final item = items[index];

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),

              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ICON
                  Icon(
                    item.icon,
                    color: const Color(0xFF166534),
                    size: 25,
                  ),

                  const SizedBox(width: 14),

                  // TEXT
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LABEL
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // VALUE
                        Text(
                          item.value,
                          maxLines: 3,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF12372A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}


// =====================================================
// EDUCATION CARD
// =====================================================

class _EducationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String institution;
  final String detail;

  const _EducationCard({
    required this.icon,
    required this.title,
    required this.institution,
    required this.detail,
  });

  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: primaryColor,
              size: 26,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  institution,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: darkColor,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 13,
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


// =====================================================
// SOCIAL BUTTON
// =====================================================

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() =>
      _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool hovered = false;

  static const Color primaryColor = Color(0xFF166534);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,

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

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),

          decoration: BoxDecoration(
            color: hovered
                ? primaryColor
                : primaryColor.withValues(
                    alpha: 0.08,
                  ),

            borderRadius: BorderRadius.circular(14),

            border: Border.all(
              color: primaryColor.withValues(
                alpha: hovered ? 0 : 0.15,
              ),
            ),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(
                widget.icon,
                size: 19,
                color: hovered
                    ? Colors.white
                    : primaryColor,
              ),

              const SizedBox(width: 8),

              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: hovered
                      ? Colors.white
                      : primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}