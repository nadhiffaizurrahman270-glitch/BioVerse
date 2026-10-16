import 'package:flutter/material.dart';
import 'package:flutter_projek_1/views/pages/home_page.dart';
import 'package:flutter_projek_1/controllers/learning_stats_controller.dart';
import 'package:flutter_projek_1/controllers/progress_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Memuat data statistik
  await LearningStatsController.init();

  runApp(const BioVerseApp());
}

class BioVerseApp extends StatelessWidget {
  const BioVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BioVerse',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}