import 'dart:convert';
import 'package:http/http.dart';
import '../models/biology_topic.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.110.241:8000/api/v1';

  Future<List<BiologyTopic>> fetchMateri() async {
    try {
      final response = await get(Uri.parse('$baseUrl/materi'));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        
        List listData;
        if (decodedData is List) {
          listData = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          listData = decodedData['data'];
        } else if (decodedData is Map && decodedData.containsKey('materi')) {
          listData = decodedData['materi'];
        } else {
          listData = [];
        }

        return listData.map((e) => BiologyTopic.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}