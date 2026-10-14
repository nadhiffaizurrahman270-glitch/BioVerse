import 'package:flutter/material.dart';
import 'package:flutter_projek_1/pages/home_page.dart';
import 'package:flutter_projek_1/managers/learning_stats_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Muat data statistik yang tersimpan.
  await LearningStatsManager.init();

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