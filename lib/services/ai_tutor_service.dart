import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AITutorService {
  static Future<String> askBioBot(String pertanyaan) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.aiTutorUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pertanyaan': pertanyaan}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['jawaban'];
      } else {
        return 'Gagal mendapatkan jawaban dari BioBot.';
      }
    } catch (e) {
      return 'Terjadi kesalahan koneksi: $e';
    }
  }
}