import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static Future<String> getResponse(String prompt) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      return "Error: API Key tidak ditemukan. Pastikan file .env sudah diatur.";
    }

    try {
      final model = GenerativeModel(
        model: dotenv.env['GEMINI_MODEL'] ?? 'gemini-3.1-flash-lite',
        apiKey: apiKey,
      );
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? "Tidak ada respon dari Gemini.";
    } catch (e) {
      return "Error: Terjadi kesalahan saat menghubungi Gemini. ($e)";
    }
  }
}