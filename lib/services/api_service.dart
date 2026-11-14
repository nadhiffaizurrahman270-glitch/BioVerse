import 'dart:convert';
import 'package:http/http.dart';
import '../config/api_config.dart';
import '../models/biology_topic.dart';
import 'auth_service.dart';

class ApiService {
  Future<List<BiologyTopic>> fetchMateri() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      final response = await get(Uri.parse(ApiConfig.materiUrl));

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

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await AuthService.getToken();
      final response = await get(
        Uri.parse('${ApiConfig.baseUrl}/users/me'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Gagal memuat profil: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}