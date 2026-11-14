import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_projek_1/controllers/learning_stats_controller.dart';
import 'package:flutter_projek_1/controllers/progress_controller.dart';
import 'package:provider/provider.dart';
import 'controllers/topic_controller.dart';
import 'views/pages/dashboard_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/gemini_chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await LearningStatsController.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<ProgressController>(create: (_) => ProgressController()),
        ChangeNotifierProvider(create: (_) => TopicController()),
      ],
      child: const BioVerseApp(),
    ),
  );
}

class BioVerseApp extends StatelessWidget {
  const BioVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BioVerse',
      theme: ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: Colors.white,
  useMaterial3: true,
  primarySwatch: Colors.blue,
),
      home: const DashboardPage(),
    );
  }
}