import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);
  static const Color backgroundColor = Color(0xFFF0FDF4);
  static const List<Map<String, String>> teamMembers = [
    {
      'name': 'M. Nadhif Faizurrahman',
      'role': 'Lead Developer & Creator',
      'university': 'Universitas Negeri Surabaya',
      'bio': 'Mengembangkan arsitektur utama aplikasi dan merancang pengalaman interaktif di BioVerse.',
      'imagePath': 'assets/image/NADIP DI TP.png',
      'github': 'https://github.com/nadhiffaizurrahman270-glitch',
      'initial': 'NF',
    },
    {
      'name': 'Nama Teman 1',
      'role': 'UI/UX Designer',
      'university': 'Universitas Negeri Surabaya',
      'bio': 'Fokus pada riset pengguna, desain antarmuka, dan memastikan aplikasi nyaman digunakan.',
      'imagePath': 'assets/image/kucing.jpg',
      'github': 'https://github.com/teman1',
      'initial': 'T1',
    },
    {
      'name': 'Indasyifa Debian Wirajati',
      'role': 'Quality Control',
      'university': 'Universitas Negeri Surabaya',
      'bio': 'Menjaga kualitas, menekan angka defect, dan memastikan standar terbaik setiap harinya',
      'imagePath': 'assets/image/Indasyifa Debian.jpeg',
      'github': 'https://github.com/teman2',
      'initial': 'T2',
    },
    {
      'name': 'Akhdan Farrel Bernadine',
      'role': 'Flutter / Frontend Developer',
      'university': 'Universitas Negeri Surabaya',
      'bio': 'jangan lupa makan,kesehatan lebih penting',
      'imagePath': 'assets/image/profil.png',
      'github': 'https://github.com/AKHDAN-ctrl',
      'initial': 'T3',
    },
    {
      'name': 'Nama Teman 4',
      'role': 'Backend & Database',
      'university': 'Universitas Negeri Surabaya',
      'bio': 'Mengelola sistem penyimpanan data, progres belajar pengguna, dan infrastruktur server BioVerse.',
      'imagePath': '',
      'github': 'https://github.com/teman4',
      'initial': 'T4',
    },
    {
      'name': 'Nama Teman 5',
      'role': 'Visual & Asset Creator',
      'university': 'Universitas Negeri Surabaya',
      'bio': 'Membuat ilustrasi dan aset visual interaktif seperti struktur sel, DNA, dan anatomi biologi.',
      'imagePath': '',
      'github': 'https://github.com/teman5',
      'initial': 'T5',
    },
    {
      'name': 'Ratriska Elvina Velyani',
      'role': 'Quality Assurance (QA)',
      'university': 'Universitas Negeri Surabaya',
      'bio': 'Menguji fitur aplikasi di berbagai skenario untuk memastikan BioVerse berjalan lancar tanpa bug.',
      'imagePath': 'assets/image/Ratriska.jpeg',
      'github': 'https://github.com/Ratriska-Elvina-Velyani-414',
      'initial': 'T6',
    },
  ];

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
            'Meet The Team',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Kolaborator di balik pengembangan BioVerse.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 35),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 900
                      ? 3
                      : (constraints.maxWidth > 600 ? 2 : 1);

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      mainAxisExtent: 400,
                    ),
                    itemCount: teamMembers.length,
                    itemBuilder: (context, index) {
                      final member = teamMembers[index];
                      return _TeamMemberCard(
                        name: member['name']!,
                        role: member['role']!,
                        university: member['university']!,
                        bio: member['bio']!,
                        imagePath: member['imagePath']!,
                        githubUrl: member['github']!,
                        initial: member['initial']!,
                      );
                    },
                  );
                },
              ),
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
  static const Color darkColor = Color(0xFF12372A);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 32),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: darkColor,
                  ),
                ),
                const SizedBox(height: 6),
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
  static const Color darkColor = Color(0xFF12372A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 32),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: darkColor,
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

class _TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String university;
  final String bio;
  final String imagePath;
  final String githubUrl;
  final String initial;

  const _TeamMemberCard({
    required this.name,
    required this.role,
    required this.university,
    required this.bio,
    required this.imagePath,
    required this.githubUrl,
    required this.initial,
  });

  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // FOTO PROFIL
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withValues(alpha: 0.1),
              image: imagePath.isNotEmpty
                  ? DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imagePath.isEmpty
                ? Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
          
          const SizedBox(height: 16),
          
          // NAMA & PERAN
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            role,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 12),
          
          // INSTANSI & BIO
          Text(
            university,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              bio,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
          
          // TOMBOL GITHUB
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.code, size: 18),
              label: const Text('GitHub'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final Uri url = Uri.parse(githubUrl);

                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url, 
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal membuka link GitHub: $githubUrl'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
