import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import '../models/biology_topic.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://192.168.110.241:8000/api/v1';
    }
    return 'http://192.168.110.241:8000/api/v1';
  }

  Future<List<BiologyTopic>> fetchMateri() async {
    try {
      final response = await get(Uri.parse('$baseUrl/materi'));

      if (response.statusCode == 200) {
        final List listData = jsonDecode(response.body) as List;
        return listData.map((e) => BiologyTopic.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}