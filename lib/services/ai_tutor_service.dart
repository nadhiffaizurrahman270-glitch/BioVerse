import 'dart:convert';
import 'package:http/http.dart' as http;

class AITutorService {
  // Ganti IP jika pakai emulator Android (misal: http://10.0.2.2:8000)
  // Atau gunakan http://127.0.0.1:8000 jika dijalankan di Chrome/Windows
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1/ai/tutor';

  static Future<String> askBioBot(String pertanyaan) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
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