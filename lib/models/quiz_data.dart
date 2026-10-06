import 'quiz_question.dart';

final Map<String, List<QuizQuestion>> quizData = {
  'DNA & Genetics': [
    QuizQuestion(
      question: 'Apa kepanjangan dari DNA?',
      answers: [
        'Deoxyribonucleic Acid',
        'Dinucleic Acid',
        'Deoxyribose Nitrogen Acid',
        'DNA Nuclear Acid',
      ],
      correctAnswer: 0,
    ),
    QuizQuestion(
      question: 'Basa nitrogen Adenine (A) berpasangan dengan...',
      answers: [
        'Guanine',
        'Thymine',
        'Cytosine',
        'Adenine',
      ],
      correctAnswer: 1,
    ),
    QuizQuestion(
      question: 'Basa nitrogen Guanine (G) berpasangan dengan...',
      answers: [
        'Adenine',
        'Thymine',
        'Cytosine',
        'Guanine',
      ],
      correctAnswer: 2,
    ),
    QuizQuestion(
      question: 'DNA memiliki bentuk struktur...',
      answers: [
        'Single helix',
        'Double helix',
        'Triple helix',
        'Circular helix',
      ],
      correctAnswer: 1,
    ),
    QuizQuestion(
      question: 'Berikut yang bukan merupakan bagian dari nukleotida adalah...',
      answers: [
        'Gula deoksiribosa',
        'Gugus fosfat',
        'Basa nitrogen',
        'Protein',
      ],
      correctAnswer: 3,
    ),
  ],

  'Cell Biology': [
    QuizQuestion(
      question: 'Apa yang merupakan unit dasar kehidupan?',
      answers: [
        'Jaringan',
        'Organ',
        'Sel',
        'Organisme',
      ],
      correctAnswer: 2,
    ),
    QuizQuestion(
      question: 'Organel yang berfungsi menghasilkan energi adalah...',
      answers: [
        'Ribosom',
        'Mitokondria',
        'Inti sel',
        'Membran sel',
      ],
      correctAnswer: 1,
    ),
    QuizQuestion(
      question: 'Organel yang berfungsi memproduksi protein adalah...',
      answers: [
        'Ribosom',
        'Mitokondria',
        'Lisosom',
        'Membran sel',
      ],
      correctAnswer: 0,
    ),
    QuizQuestion(
      question: 'Bagian sel yang mengendalikan aktivitas sel adalah...',
      answers: [
        'Ribosom',
        'Membran sel',
        'Inti sel',
        'Sitoplasma',
      ],
      correctAnswer: 2,
    ),
    QuizQuestion(
      question: 'Fungsi utama membran sel adalah...',
      answers: [
        'Menghasilkan energi',
        'Mengatur keluar masuk zat',
        'Membuat protein',
        'Menyimpan DNA',
      ],
      correctAnswer: 1,
    ),
  ],

  'Viruses': [
    QuizQuestion(
      question: 'Virus hanya dapat berkembang biak pada...',
      answers: [
        'Air',
        'Tanah',
        'Sel inang',
        'Udara',
      ],
      correctAnswer: 2,
    ),
    QuizQuestion(
      question: 'Bagian virus yang melindungi materi genetik disebut...',
      answers: [
        'Kapsid',
        'Ribosom',
        'Mitokondria',
        'Nukleus',
      ],
      correctAnswer: 0,
    ),
    QuizQuestion(
      question: 'Materi genetik virus dapat berupa...',
      answers: [
        'DNA atau RNA',
        'Protein saja',
        'Lemak saja',
        'Karbohidrat saja',
      ],
      correctAnswer: 0,
    ),
    QuizQuestion(
      question: 'Virus membutuhkan sel inang untuk...',
      answers: [
        'Mendapatkan warna',
        'Melakukan reproduksi',
        'Membentuk jaringan',
        'Menghasilkan oksigen',
      ],
      correctAnswer: 1,
    ),
    QuizQuestion(
      question: 'Tahap awal infeksi virus biasanya dimulai dengan...',
      answers: [
        'Pembelahan sel',
        'Virus menempel pada sel inang',
        'Pembentukan jaringan',
        'Produksi energi',
      ],
      correctAnswer: 1,
    ),
  ],

  'Life & Ecosystems': [
    QuizQuestion(
      question: 'Apa yang dimaksud dengan ekosistem?',
      answers: [
        'Kumpulan organ dalam tubuh',
        'Hubungan makhluk hidup dengan lingkungannya',
        'Kumpulan sel yang sama',
        'Tempat hidup satu organisme',
      ],
      correctAnswer: 1,
    ),
    QuizQuestion(
      question: 'Organisme yang membuat makanannya sendiri disebut...',
      answers: [
        'Konsumen',
        'Dekomposer',
        'Produsen',
        'Predator',
      ],
      correctAnswer: 2,
    ),
    QuizQuestion(
      question: 'Organisme yang menguraikan sisa makhluk hidup disebut...',
      answers: [
        'Produsen',
        'Konsumen',
        'Dekomposer',
        'Predator',
      ],
      correctAnswer: 2,
    ),
    QuizQuestion(
      question: 'Ketidakseimbangan ekosistem dapat...',
      answers: [
        'Tidak memberikan pengaruh',
        'Memengaruhi kehidupan organisme',
        'Menghentikan fotosintesis seluruh dunia',
        'Menghilangkan semua organisme',
      ],
      correctAnswer: 1,
    ),
    QuizQuestion(
      question: 'Berikut yang termasuk komponen biotik adalah...',
      answers: [
        'Air',
        'Tanah',
        'Cahaya matahari',
        'Tumbuhan',
      ],
      correctAnswer: 3,
    ),
  ],
};