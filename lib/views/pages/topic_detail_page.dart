import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Import markdown
import '../../models/biology_topic.dart';
import '../../models/quiz_data.dart';
import '../../models/quiz_question.dart';
import '../../controllers/progress_controller.dart';
import '../../controllers/learning_stats_controller.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TopicDetailPage extends StatefulWidget {
  final BiologyTopic topic;

  const TopicDetailPage({
    super.key,
    required this.topic,
  });

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);
  static const Color lightGreen = Color(0xFFF0FDF4);

  int currentQuestion = 0;
  int selectedAnswer = -1;
  int score = 0;
  bool answered = false;
  bool quizFinished = false;

  List<QuizQuestion> get questions {
    return quizData[widget.topic.title] ?? [];
  }

  void selectAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedAnswer = index;
    });
  }

  void checkAnswer() {
    if (selectedAnswer == -1) return;

    setState(() {
      answered = true;

      if (questions[currentQuestion].isCorrectAnswer(selectedAnswer)) {
        score++;
      }
    });
  }

  Future<void> nextQuestion() async {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = -1;
        answered = false;
      });
    } else {
      await ProgressController.saveProgress(
        widget.topic.title,
        score,
        questions.length,
      );

      final xpEarned = await LearningStatsController.recordQuizCompletion(
        topicTitle: widget.topic.title,
        score: score,
        totalQuestions: questions.length,
      );

      if (!mounted) return;
      setState(() {
        quizFinished = true;
      });

      if (xpEarned) {
        final perfectScore = score == questions.length;
        final earnedXp = perfectScore ? 75 : 50;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Keren! Kamu mendapatkan $earnedXp XP!'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void resetQuiz() {
    setState(() {
      currentQuestion = 0;
      selectedAnswer = -1;
      score = 0;
      answered = false;
      quizFinished = false;
    });
  }

  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi video jika videoId tersedia dari Firebase
    if (widget.topic.videoId != null && widget.topic.videoId!.isNotEmpty) {
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: widget.topic.videoId!,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          mute: false,
          showFullscreenButton: true,
          loop: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.topic.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width < 600 ? 16 : 24,
                vertical: MediaQuery.sizeOf(context).width < 600 ? 18 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildBiologyIllustration(),
                  const SizedBox(height: 24),
                  _buildMaterial(),
                  const SizedBox(height: 24),
                  _buildVideoSection(),
                  const SizedBox(height: 24),
                  if (questions.isNotEmpty) _buildQuiz(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _topicIcon() {
    final title = widget.topic.title.toLowerCase();

    if (title.contains('dna') || title.contains('genetic')) {
      return Icons.biotech_rounded;
    }
    if (title.contains('cell')) return Icons.grain_rounded;
    if (title.contains('virus')) return Icons.coronavirus_rounded;
    if (title.contains('ecosystem') || title.contains('life')) {
      return Icons.eco_rounded;
    }
    return Icons.science_rounded;
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF12372A),
            Color(0xFF166534),
            Color(0xFF22A06B),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;

          final topicArtwork = Container(
            width: compact ? 72 : 104,
            height: compact ? 72 : 104,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22),
              ),
            ),
            child: Icon(
              _topicIcon(),
              size: compact ? 40 : 58,
              color: Colors.white,
            ),
          );

          final topicText = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.topic.category.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFC9F5D8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.topic.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 25 : 34,
                  fontWeight: FontWeight.w800,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.topic.description,
                style: const TextStyle(
                  color: Color(0xFFE5F5E9),
                  fontSize: 15,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _headerBadge(
                    Icons.signal_cellular_alt_rounded,
                    'Level: ${widget.topic.level}',
                  ),
                  _headerBadge(
                    Icons.menu_book_rounded,
                    'Materi & Quiz',
                  ),
                ],
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topicArtwork,
                const SizedBox(height: 22),
                topicText,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topicArtwork,
              const SizedBox(width: 24),
              Expanded(child: topicText),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBiologyIllustration() {
    final title = widget.topic.title.toLowerCase();
    String visualTitle;
    String visualDescription;
    IconData visualIcon;

    if (title.contains('dna') || title.contains('genetic')) {
      visualTitle = 'DNA Double Helix';
      visualDescription =
          'Dua untai DNA terhubung melalui pasangan basa nitrogen.';
      visualIcon = Icons.biotech_rounded;
    } else if (title.contains('cell')) {
      visualTitle = 'Inside a Cell';
      visualDescription =
          'Sel memiliki membran, inti, dan organel dengan fungsi berbeda.';
      visualIcon = Icons.grain_rounded;
    } else if (title.contains('virus')) {
      visualTitle = 'Virus Structure';
      visualDescription =
          'Materi genetik dilindungi kapsid dan pada sebagian virus terdapat selubung.';
      visualIcon = Icons.coronavirus_rounded;
    } else if (title.contains('ecosystem') || title.contains('life')) {
      visualTitle = 'Ecosystem Connections';
      visualDescription =
          'Produsen, konsumen, dan pengurai saling terhubung dalam ekosistem.';
      visualIcon = Icons.eco_rounded;
    } else {
      visualTitle = 'Biology Visual Lab';
      visualDescription =
          'Amati gambaran sederhana konsep biologi pada topik ini.';
      visualIcon = Icons.science_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE4EFE7)),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(visualIcon, color: primaryColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visualTitle,
                      style: const TextStyle(
                        color: darkColor,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Ilustrasi konsep',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.auto_awesome_rounded, color: Color(0xFF65A30D)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 210,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF0FDF4), Color(0xFFE7F7EC)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(
              painter:
                  _BiologyIllustrationPainter(topicTitle: widget.topic.title),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            visualDescription,
            style: const TextStyle(
              color: Color(0xFF405247),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Skema ilustratif untuk membantu memahami konsep, bukan gambar mikroskopis berskala.',
            style: TextStyle(color: Colors.black45, fontSize: 11, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _headerBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterial() {
    final title = widget.topic.title.toLowerCase();

    String topicEmoji = '🔬';
    String topicFact = 'Setiap organisme memiliki karakteristik biologis '
        'yang membantu kita memahami kehidupan.';

    List<Map<String, String>> infoCards = [];

    List<Map<String, String>> summaries = [];

    if (title.contains('dna') || title.contains('genetic')) {
      topicEmoji = '🧬';
      topicFact = 'Urutan basa nitrogen pada DNA menyimpan informasi '
          'genetik yang diwariskan dari satu generasi ke generasi berikutnya.';

      infoCards = [
        {
          'title': 'Gula deoksiribosa',
          'subtitle': 'Komponen gula DNA',
          'description': 'Gula deoksiribosa merupakan bagian dari '
              'tulang punggung DNA dan terhubung dengan gugus fosfat.',
          'icon': '🍬',
        },
        {
          'title': 'Gugus fosfat',
          'subtitle': 'Penghubung nukleotida',
          'description': 'Gugus fosfat membantu menghubungkan gula '
              'antar-nukleotida dalam untai DNA.',
          'icon': '⚛️',
        },
        {
          'title': 'Basa nitrogen',
          'subtitle': 'Penyimpan informasi genetik',
          'description': 'DNA memiliki empat basa nitrogen, yaitu '
              'Adenine, Thymine, Guanine, dan Cytosine.',
          'icon': '🧩',
        },
      ];

      summaries = [
        {
          'title': 'Apa fungsi DNA?',
          'content': 'DNA menyimpan informasi genetik yang berperan '
              'dalam perkembangan, fungsi, dan pewarisan sifat organisme.',
        },
        {
          'title': 'Bagaimana pasangan basa DNA?',
          'content': 'Adenine (A) berpasangan dengan Thymine (T), '
              'sedangkan Guanine (G) berpasangan dengan Cytosine (C).',
        },
        {
          'title': 'Apa itu nukleotida?',
          'content': 'Nukleotida DNA tersusun atas gula deoksiribosa, '
              'gugus fosfat, dan basa nitrogen.',
        },
      ];
    } else if (title.contains('cell')) {
      topicEmoji = '🔬';
      topicFact = 'Meskipun ukurannya sangat kecil, sel memiliki '
          'struktur khusus yang menjalankan fungsi penting bagi kehidupan.';

      infoCards = [
        {
          'title': 'Membran sel',
          'subtitle': 'Pembatas sel',
          'description': 'Membran sel membatasi sel dan membantu '
              'mengatur keluar masuknya berbagai zat.',
          'icon': '🫧',
        },
        {
          'title': 'Inti sel',
          'subtitle': 'Pusat pengaturan',
          'description': 'Pada sel eukariotik, inti menyimpan sebagian '
              'besar materi genetik dan berperan dalam pengaturan aktivitas sel.',
          'icon': '🔵',
        },
        {
          'title': 'Mitokondria',
          'subtitle': 'Produksi energi',
          'description': 'Mitokondria menjadi tempat berlangsungnya '
              'sebagian besar produksi ATP melalui respirasi seluler pada '
              'sel eukariotik.',
          'icon': '⚡',
        },
      ];

      summaries = [
        {
          'title': 'Apa unit dasar kehidupan?',
          'content': 'Sel merupakan unit struktural dan fungsional dasar '
              'kehidupan.',
        },
        {
          'title': 'Apa fungsi membran sel?',
          'content': 'Membran sel membantu mengatur pertukaran zat '
              'antara sel dan lingkungannya.',
        },
      ];
    } else if (title.contains('virus')) {
      topicEmoji = '🦠';
      topicFact = 'Virus memerlukan sel inang untuk memperbanyak diri '
          'karena tidak memiliki seluruh perangkat yang diperlukan '
          'untuk reproduksi mandiri.';

      infoCards = [
        {
          'title': 'Materi genetik',
          'subtitle': 'DNA atau RNA',
          'description': 'Virus membawa materi genetik berupa DNA '
              'atau RNA yang berisi informasi untuk pembentukan virus.',
          'icon': '🧬',
        },
        {
          'title': 'Kapsid',
          'subtitle': 'Pelindung materi genetik',
          'description': 'Kapsid merupakan selubung protein yang '
              'melindungi materi genetik virus.',
          'icon': '🛡️',
        },
        {
          'title': 'Sel inang',
          'subtitle': 'Tempat replikasi',
          'description': 'Virus memanfaatkan mesin sel inang untuk '
              'menghasilkan komponen virus dan membentuk partikel virus baru.',
          'icon': '🔬',
        },
      ];

      summaries = [
        {
          'title': 'Apakah virus dapat bereproduksi sendiri?',
          'content': 'Virus memerlukan sel inang untuk melakukan '
              'replikasi.',
        },
        {
          'title': 'Apa fungsi kapsid?',
          'content': 'Kapsid melindungi materi genetik virus dan '
              'membantu membentuk struktur partikelnya.',
        },
      ];
    } else if (title.contains('ecosystem') || title.contains('life')) {
      topicEmoji = '🌿';
      topicFact = 'Perubahan pada satu komponen ekosistem dapat '
          'memengaruhi hubungan antara organisme dan lingkungannya.';

      infoCards = [
        {
          'title': 'Produsen',
          'subtitle': 'Pembuat bahan organik',
          'description': 'Produsen menghasilkan bahan organik, '
              'umumnya melalui fotosintesis pada ekosistem yang '
              'bergantung pada energi matahari.',
          'icon': '🌱',
        },
        {
          'title': 'Konsumen',
          'subtitle': 'Pemakan organisme lain',
          'description': 'Konsumen memperoleh energi dan bahan '
              'organik dengan memakan organisme lain atau bahan organik.',
          'icon': '🐇',
        },
        {
          'title': 'Dekomposer',
          'subtitle': 'Pengurai',
          'description': 'Organisme seperti banyak jenis jamur dan '
              'bakteri menguraikan bahan organik dan membantu '
              'mendaur ulang unsur hara.',
          'icon': '🍄',
        },
      ];

      summaries = [
        {
          'title': 'Apa itu ekosistem?',
          'content': 'Ekosistem mencakup interaksi antara makhluk hidup '
              'dan lingkungan fisiknya.',
        },
        {
          'title': 'Apa peran produsen?',
          'content': 'Produsen membentuk bahan organik yang menjadi '
              'sumber energi bagi organisme lain dalam rantai makanan.',
        },
      ];

      } else if (title.contains('fotosintesis')) {
      topicEmoji = '🍃';
      topicFact = 'Tanpa fotosintesis, hampir tidak akan ada oksigen di atmosfer bumi untuk kita bernapas.';

      infoCards = [
        {
          'title': 'Kloroplas',
          'subtitle': 'Dapur sel tumbuhan',
          'description': 'Kloroplas adalah organel tempat terjadinya seluruh proses fotosintesis.',
          'icon': '🔋',
        },
        {
          'title': 'Klorofil',
          'subtitle': 'Penangkap cahaya',
          'description': 'Pigmen hijau yang menyerap energi matahari untuk memecah molekul air.',
          'icon': '☀️',
        },
        {
          'title': 'Stomata',
          'subtitle': 'Pintu pertukaran gas',
          'description': 'Pori-pori kecil di daun tempat masuknya karbon dioksida dan keluarnya oksigen.',
          'icon': '💨',
        },
      ];

      summaries = [
        {
          'title': 'Apa hasil akhir fotosintesis?',
          'content': 'Proses ini menghasilkan glukosa (makanan tumbuhan) dan oksigen sebagai produk sampingan yang dilepaskan ke udara.',
        },
        {
          'title': 'Reaksi terang vs gelap',
          'content': 'Reaksi terang butuh cahaya untuk menghasilkan energi, sedangkan reaksi gelap (Siklus Calvin) menggunakan energi tersebut untuk membentuk glukosa.',
        },
      ];
    } else if (title.contains('keanekaragaman') || title.contains('hayati')) {
      topicEmoji = '🌍';
      topicFact = 'Indonesia adalah salah satu dari 17 negara megabiodiversitas di dunia, rumah bagi jutaan spesies flora dan fauna endemik.';

      infoCards = [
        {
          'title': 'Tingkat Gen',
          'subtitle': 'Variasi individu',
          'description': 'Perbedaan susunan genetik yang menciptakan variasi dalam satu spesies yang sama.',
          'icon': '🧬',
        },
        {
          'title': 'Tingkat Spesies',
          'subtitle': 'Perbedaan jenis',
          'description': 'Variasi antar spesies yang berbeda di suatu tempat, seperti perbedaan antara kucing dan harimau.',
          'icon': '🐅',
        },
        {
          'title': 'Tingkat Ekosistem',
          'subtitle': 'Keragaman habitat',
          'description': 'Kumpulan ekosistem yang berbeda seperti hutan hujan, sabana, dan terumbu karang.',
          'icon': '🏝️',
        },
      ];

      summaries = [
        {
          'title': 'Mengapa biodiversitas penting?',
          'content': 'Keberagaman makhluk hidup menjaga keseimbangan ekosistem, sumber pangan, dan obat-obatan.',
        },
      ];
    } else if (title.contains('anatomi') || title.contains('tubuh')) {
      topicEmoji = '🫀';
      topicFact = 'Jantung manusia rata-rata memompa sekitar 7.500 liter darah setiap harinya tanpa pernah berhenti beristirahat.';

      infoCards = [
        {
          'title': 'Sistem Pencernaan',
          'subtitle': 'Penyerapan nutrisi',
          'description': 'Memproses makanan menjadi molekul kecil agar nutrisinya bisa diserap oleh sel tubuh.',
          'icon': '🍎',
        },
        {
          'title': 'Sistem Pernapasan',
          'subtitle': 'Pertukaran gas',
          'description': 'Memasukkan oksigen ke dalam darah dan membuang karbon dioksida melalui paru-paru.',
          'icon': '🫁',
        },
        {
          'title': 'Sistem Saraf',
          'subtitle': 'Pusat kendali',
          'description': 'Otak dan jaringan saraf mengontrol seluruh aktivitas dan respons tubuh.',
          'icon': '🧠',
        },
      ];

      summaries = [
        {
          'title': 'Bagaimana sistem organ bekerja?',
          'content': 'Sistem organ tidak bekerja sendiri-sendiri, melainkan saling terhubung (contoh: darah mengangkut oksigen dari paru-paru dan nutrisi dari usus).',
        },
      ];
      
    } else {
      infoCards = [
        {
          'title': 'Konsep utama',
          'subtitle': 'Pahami dasar materi',
          'description': 'Baca materi utama untuk memahami konsep '
              'dasar dari topik ini.',
          'icon': '📖',
        },
        {
          'title': 'Hubungan biologis',
          'subtitle': 'Pelajari keterkaitannya',
          'description': 'Perhatikan bagaimana konsep yang dipelajari '
              'berhubungan dengan struktur, fungsi, atau proses kehidupan.',
          'icon': '🔬',
        },
        {
          'title': 'Penerapan',
          'subtitle': 'Hubungkan dengan kehidupan',
          'description': 'Cobalah menghubungkan konsep dalam materi '
              'dengan fenomena biologis di sekitar kita.',
          'icon': '🌱',
        },
      ];

      summaries = [
        {
          'title': 'Apa inti materi ini?',
          'content': 'Pelajari penjelasan utama di bagian materi '
              'pembelajaran dan identifikasi konsep yang paling penting.',
        },
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER MATERI
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE4EFE7)),
            boxShadow: [
              BoxShadow(
                color: darkColor.withValues(alpha: 0.05),
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
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: primaryColor,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Materi Pembelajaran',
                          style: TextStyle(
                            color: darkColor,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Jelajahi dan pahami setiap konsep',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // MATERI DARI FIREBASE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFCFA),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE6EEE8),
                  ),
                ),
                child: widget.topic.content.trim().isEmpty
                    ? const Text(
                        'Materi belum tersedia.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      )
                    : MarkdownBody(
                        data: widget.topic.content,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(
                            color: Color(0xFF26352C),
                            fontSize: 15,
                            height: 1.8,
                          ),
                          h1: const TextStyle(
                            color: Color(0xFF16804A),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                          h2: const TextStyle(
                            color: Color(0xFF16804A),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          h3: const TextStyle(
                            color: darkColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          listBullet: const TextStyle(
                            color: primaryColor,
                            fontSize: 15,
                          ),
                          blockquote: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // KARTU INFORMASI INTERAKTIF
        Row(
          children: [
            const Icon(
              Icons.explore_rounded,
              color: primaryColor,
              size: 25,
            ),
            const SizedBox(width: 9),
            const Expanded(
              child: Text(
                'Jelajahi Konsep',
                style: TextStyle(
                  color: darkColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...infoCards.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(
                  color: Color(0xFFE4EFE7),
                ),
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(
                  18,
                  0,
                  18,
                  18,
                ),
                leading: Text(
                  item['icon']!,
                  style: const TextStyle(fontSize: 27),
                ),
                title: Text(
                  item['title']!,
                  style: const TextStyle(
                    color: darkColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(item['subtitle']!),
                iconColor: primaryColor,
                collapsedIconColor: Colors.black54,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item['description']!,
                      style: const TextStyle(
                        color: Color(0xFF37443A),
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // FAKTA MENARIK
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFE8F8ED),
                Color(0xFFF5FCF6),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFD2EED9),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    topicEmoji,
                    style: const TextStyle(fontSize: 27),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Fakta Menarik',
                      style: TextStyle(
                        color: darkColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.lightbulb_rounded,
                    color: Color(0xFFB7791F),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                topicFact,
                style: const TextStyle(
                  color: Color(0xFF37443A),
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // RINGKASAN BUKA-TUTUP
        Row(
          children: [
            const Icon(
              Icons.checklist_rounded,
              color: primaryColor,
              size: 25,
            ),
            const SizedBox(width: 9),
            const Expanded(
              child: Text(
                'Ringkasan Materi',
                style: TextStyle(
                  color: darkColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE4EFE7),
            ),
          ),
          child: Column(
            children: [
              for (int i = 0; i < summaries.length; i++) ...[
                ExpansionTile(
                  initiallyExpanded: i == 0,
                  leading: CircleAvatar(
                    radius: 17,
                    backgroundColor: lightGreen,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    summaries[i]['title']!,
                    style: const TextStyle(
                      color: darkColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    18,
                  ),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        summaries[i]['content']!,
                        style: const TextStyle(
                          color: Color(0xFF37443A),
                          height: 1.7,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                if (i < summaries.length - 1)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoSection() {
    if (_youtubeController == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE4EFE7)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF12372A).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Color(0xFFDC2626), // Warna merah ala YouTube
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video Pembelajaran',
                      style: TextStyle(
                        color: darkColor,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Tonton video animasi untuk pemahaman lebih baik',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: YoutubePlayer(
              controller: _youtubeController!,
              aspectRatio: 16 / 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuiz() {
    if (quizFinished) {
      return _buildQuizResult();
    }

    final QuizQuestion question = questions[currentQuestion];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7EC),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: primaryColor,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uji Pemahaman',
                      style: TextStyle(
                        color: darkColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Pilih jawaban yang paling tepat',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${currentQuestion + 1}/${questions.length}',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: (currentQuestion + 1) / questions.length,
              backgroundColor: const Color(0xFFE7EEE9),
              valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            question.question,
            style: const TextStyle(
              color: darkColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            question.answers.length,
            (index) => _buildAnswerOption(
              index,
              question.answers[index],
              question.correctAnswer,
            ),
          ),
          const SizedBox(height: 20),
          if (!answered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedAnswer == -1 ? null : checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Jawab',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (answered) ...[
            _buildAnswerFeedback(question.correctAnswer),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  currentQuestion == questions.length - 1
                      ? 'Lihat Hasil'
                      : 'Soal Berikutnya',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerOption(
    int index,
    String answer,
    int correctAnswer,
  ) {
    bool isSelected = selectedAnswer == index;
    bool isCorrect = index == correctAnswer;

    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Color textColor = Colors.black87;

    if (answered && isCorrect) {
      backgroundColor = Colors.green.shade50;
      borderColor = Colors.green;
      textColor = Colors.green.shade800;
    } else if (answered && isSelected && !isCorrect) {
      backgroundColor = Colors.red.shade50;
      borderColor = Colors.red;
      textColor = Colors.red.shade800;
    } else if (isSelected) {
      backgroundColor = lightGreen;
      borderColor = primaryColor;
      textColor = primaryColor;
    }

    return GestureDetector(
      onTap: () => selectAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: borderColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Text(
                String.fromCharCode(65 + index),
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                answer,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
            if (answered && isCorrect)
              const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 21)
            else if (answered && isSelected && !isCorrect)
              const Icon(Icons.cancel_rounded, color: Colors.red, size: 21)
            else if (isSelected)
              const Icon(Icons.radio_button_checked_rounded,
                  color: primaryColor, size: 21),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerFeedback(int correctAnswer) {
    final isCorrect = selectedAnswer == correctAnswer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isCorrect
                  ? 'Jawaban kamu benar!'
                  : 'Jawaban kamu belum tepat.',
              style: TextStyle(
                color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizResult() {
    double percentage = (score / questions.length) * 100;

    String message;

    if (percentage == 100) {
      message =
          'Sempurna! Kamu menguasai materi ${widget.topic.title} dengan sangat baik.';
    } else if (percentage >= 80) {
      message =
          'Mantap! Pemahaman kamu tentang ${widget.topic.title} sudah sangat baik.';
    } else if (percentage >= 60) {
      message =
          'Lumayan! Pelajari kembali beberapa bagian materi ${widget.topic.title}, lalu coba lagi.';
    } else {
      message =
          'Jangan menyerah! Baca kembali materi ${widget.topic.title} dan coba lagi.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE8F7EC),
              border: Border.all(color: const Color(0xFFB7E4C7), width: 2),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: primaryColor,
              size: 54,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Quiz Selesai!',
            style: TextStyle(
              color: darkColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$score / ${questions.length}',
            style: const TextStyle(
              color: primaryColor,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${percentage.toInt()}%',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: resetQuiz,
              icon: const Icon(Icons.refresh),
              label: const Text('Ulangi Quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BiologyIllustrationPainter extends CustomPainter {
  final String topicTitle;

  _BiologyIllustrationPainter({required this.topicTitle});

  @override
  void paint(Canvas canvas, Size size) {
    final title = topicTitle.toLowerCase();
    if (title.contains('dna') || title.contains('genetic')) {
      _drawDna(canvas, size);
    } else if (title.contains('cell')) {
      _drawCell(canvas, size);
    } else if (title.contains('virus')) {
      _drawVirus(canvas, size);
    } else if (title.contains('ecosystem') || title.contains('life')) {
      _drawEcosystem(canvas, size);
    } else {
      _drawDna(canvas, size);
    }
  }

  void _drawDna(Canvas canvas, Size size) {
    final center = size.width / 2;
    final strandA = Paint()
      ..color = const Color(0xFF15803D)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final strandB = Paint()
      ..color = const Color(0xFF0EA5E9)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final rung = Paint()
      ..color = const Color(0xFF86B99A)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final pointsA = <Offset>[];
    final pointsB = <Offset>[];
    for (int i = 0; i <= 80; i++) {
      final y = 16 + (size.height - 32) * i / 80;
      final angle = i / 80 * 2 * 3.141592653589793 * 2.2;
      pointsA.add(Offset(center - 48 + 42 * _sin(angle), y));
      pointsB.add(Offset(center + 48 - 42 * _sin(angle), y));
    }
    for (int i = 0; i < pointsA.length - 1; i++) {
      canvas.drawLine(pointsA[i], pointsA[i + 1], strandA);
      canvas.drawLine(pointsB[i], pointsB[i + 1], strandB);
    }
    for (int i = 3; i < pointsA.length; i += 8) {
      canvas.drawLine(pointsA[i], pointsB[i], rung);
      canvas.drawCircle(
          pointsA[i], 3.2, Paint()..color = const Color(0xFF166534));
      canvas.drawCircle(
          pointsB[i], 3.2, Paint()..color = const Color(0xFF0284C7));
    }
    _label(canvas, 'A', Offset(center - 108, 30), const Color(0xFF166534));
    _label(canvas, 'T', Offset(center + 92, 58), const Color(0xFF0284C7));
    _label(canvas, 'G', Offset(center - 110, size.height - 42),
        const Color(0xFF166534));
    _label(canvas, 'C', Offset(center + 92, size.height - 36),
        const Color(0xFF0284C7));
  }

  void _drawCell(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final membrane = Paint()
      ..color = const Color(0xFF65A30D).withValues(alpha: 0.20)
      ..style = PaintingStyle.fill;
    final membraneBorder = Paint()
      ..color = const Color(0xFF4D8B50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawOval(
        Rect.fromCenter(
            center: center,
            width: size.width * 0.64,
            height: size.height * 0.72),
        membrane);
    canvas.drawOval(
        Rect.fromCenter(
            center: center,
            width: size.width * 0.64,
            height: size.height * 0.72),
        membraneBorder);
    final nucleus = Offset(center.dx - 12, center.dy - 5);
    canvas.drawCircle(nucleus, 28,
        Paint()..color = const Color(0xFF8B5CF6).withValues(alpha: 0.8));
    canvas.drawCircle(nucleus, 10, Paint()..color = const Color(0xFFC4B5FD));
    _organelle(
        canvas, Offset(center.dx + 52, center.dy - 36), 23, const Color(0xFFF59E0B));
    _organelle(
        canvas, Offset(center.dx + 55, center.dy + 35), 18, const Color(0xFF0EA5E9));
    _organelle(
        canvas, Offset(center.dx - 65, center.dy + 40), 16, const Color(0xFFEC4899));
    _organelle(
        canvas, Offset(center.dx - 65, center.dy - 42), 13, const Color(0xFF16A34A));
    _label(canvas, 'Nucleus', Offset(12, 14), const Color(0xFF6D28D9));
    _label(canvas, 'Organelles', Offset(size.width - 105, size.height - 27),
        const Color(0xFF166534));
  }

  void _drawVirus(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.height * 0.28;
    final spikePaint = Paint()
      ..color = const Color(0xFFEA580C)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final corePaint = Paint()
      ..color = const Color(0xFFFB923C).withValues(alpha: 0.75);
    final capsidPaint = Paint()
      ..color = const Color(0xFFB45309)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    for (int i = 0; i < 18; i++) {
      final angle = i * 2 * 3.141592653589793 / 18;
      final inner = Offset(
          center.dx + radius * _cos(angle), center.dy + radius * _sin(angle));
      final outer = Offset(center.dx + (radius + 18) * _cos(angle),
          center.dy + (radius + 18) * _sin(angle));
      canvas.drawLine(inner, outer, spikePaint);
      canvas.drawCircle(outer, 4, Paint()..color = const Color(0xFFEA580C));
    }
    canvas.drawCircle(center, radius, corePaint);
    canvas.drawCircle(center, radius, capsidPaint);
    final genome = Paint()
      ..color = const Color(0xFF7C2D12)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(center.dx - 20, center.dy - 22);
    for (int i = 0; i <= 30; i++) {
      path.lineTo(center.dx - 20 + i * 1.3,
          center.dy + 18 * _sin(i / 30 * 4 * 3.141592653589793));
    }
    canvas.drawPath(path, genome);
    _label(canvas, 'Capsid', Offset(18, 18), const Color(0xFF9A3412));
    _label(canvas, 'Genetic material',
        Offset(size.width - 145, size.height - 28), const Color(0xFF9A3412));
  }

  void _drawEcosystem(Canvas canvas, Size size) {
    final ground = Paint()
      ..color = const Color(0xFF86B77A)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(20, size.height - 30),
        Offset(size.width - 20, size.height - 30), ground);
    final sunCenter = Offset(size.width - 55, 42);
    canvas.drawCircle(sunCenter, 20, Paint()..color = const Color(0xFFFBBF24));
    for (int i = 0; i < 8; i++) {
      final angle = i * 2 * 3.141592653589793 / 8;
      canvas.drawLine(
        Offset(
            sunCenter.dx + 25 * _cos(angle), sunCenter.dy + 25 * _sin(angle)),
        Offset(
            sunCenter.dx + 32 * _cos(angle), sunCenter.dy + 32 * _sin(angle)),
        Paint()
          ..color = const Color(0xFFF59E0B)
          ..strokeWidth = 3,
      );
    }
    // Plant / producer
    final plant = Paint()
      ..color = const Color(0xFF15803D)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * 0.28, size.height - 30),
        Offset(size.width * 0.28, size.height * 0.43), plant);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.23, size.height * 0.55),
            width: 35,
            height: 16),
        Paint()..color = const Color(0xFF22C55E));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.34, size.height * 0.48),
            width: 35,
            height: 16),
        Paint()..color = const Color(0xFF4DAD63));
    // Simple consumer
    final animal = Paint()..color = const Color(0xFFB77945);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.56, size.height * 0.67),
            width: 62,
            height: 34),
        animal);
    canvas.drawCircle(
        Offset(size.width * 0.61, size.height * 0.58), 15, animal);
    canvas.drawCircle(Offset(size.width * 0.615, size.height * 0.575), 2.5,
        Paint()..color = Colors.white);
    // Decomposer / mushroom
    final mushroomX = size.width * 0.79;
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(mushroomX, size.height - 43), width: 10, height: 22),
        Paint()..color = const Color(0xFFD6B58B));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(mushroomX, size.height - 55), width: 32, height: 17),
        Paint()..color = const Color(0xFFDC7865));
    _label(canvas, 'Producer', Offset(size.width * 0.12, 18),
        const Color(0xFF166534));
    _label(canvas, 'Consumer', Offset(size.width * 0.43, 18),
        const Color(0xFF8A4B20));
    _label(canvas, 'Decomposer', Offset(size.width * 0.69, size.height - 22),
        const Color(0xFF9A3412));
    final arrow = Paint()
      ..color = const Color(0xFF739B78)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * 0.34, size.height * 0.33),
        Offset(size.width * 0.48, size.height * 0.33), arrow);
    canvas.drawLine(Offset(size.width * 0.48, size.height * 0.33),
        Offset(size.width * 0.44, size.height * 0.29), arrow);
    canvas.drawLine(Offset(size.width * 0.48, size.height * 0.33),
        Offset(size.width * 0.44, size.height * 0.37), arrow);
  }

  void _organelle(Canvas canvas, Offset center, double radius, Color color) {
    canvas.drawOval(
      Rect.fromCenter(
          center: center, width: radius * 2.1, height: radius * 1.35),
      Paint()..color = color.withValues(alpha: 0.82),
    );
    final inner = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(
          center: center, width: radius * 1.3, height: radius * 0.7),
      0.2,
      4.8,
      false,
      inner,
    );
  }

  void _label(Canvas canvas, String text, Offset offset, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 130);
    painter.paint(canvas, offset);
  }

  double _sin(double value) => math.sin(value);
  double _cos(double value) => math.cos(value);

  @override
  bool shouldRepaint(covariant _BiologyIllustrationPainter oldDelegate) {
    return oldDelegate.topicTitle != topicTitle;
  }
}