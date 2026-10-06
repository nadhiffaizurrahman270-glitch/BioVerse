import 'package:flutter/material.dart';
import '../models/biology_topic.dart';
import '../models/quiz_data.dart';
import '../models/quiz_question.dart';
import '../models/progress_manager.dart';

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

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = -1;
        answered = false;
      });
    } else {
      ProgressManager.saveProgress(
        widget.topic.title,
        score,
        questions.length,
      );
      setState(() {
        quizFinished = true;
      });
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildMaterial(),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF166534),
            Color(0xFF15803D),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.topic.category.toUpperCase(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.topic.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.topic.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Level: ${widget.topic.level}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterial() {
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Materi Pembelajaran',
                style: TextStyle(
                  color: darkColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            widget.topic.content,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              height: 1.8,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quiz',
                style: TextStyle(
                  color: darkColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${currentQuestion + 1}/${questions.length}',
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          LinearProgressIndicator(
            value: (currentQuestion + 1) / questions.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              primaryColor,
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
        color: isCorrect
            ? Colors.green.shade50
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect
                ? Icons.check_circle
                : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isCorrect
                  ? 'Jawaban kamu benar! 🎉'
                  : 'Jawaban kamu belum tepat.',
              style: TextStyle(
                color: isCorrect
                    ? Colors.green.shade800
                    : Colors.red.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizResult() {
    double percentage =
        (score / questions.length) * 100;

    String message;

    if (percentage == 100) {
      message = 'Sempurna! Kamu menguasai materi DNA dengan sangat baik.';
    } else if (percentage >= 80) {
      message = 'Mantap! Pemahaman kamu tentang DNA sudah sangat baik.';
    } else if (percentage >= 60) {
      message = 'Lumayan! Coba pelajari kembali beberapa bagian materi.';
    } else {
      message = 'Jangan menyerah! Baca kembali materi lalu coba lagi.';
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
          const Icon(
            Icons.emoji_events_rounded,
            color: primaryColor,
            size: 70,
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