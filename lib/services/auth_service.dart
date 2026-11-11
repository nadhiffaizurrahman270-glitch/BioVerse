import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/v1'),
  );
  static const String _tokenKey = 'jwt_token';

  // ==========================================
  // REGISTER
  // ==========================================

  static Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post('/auth/register', data: {
        'username': name.trim(),
        'email': email.trim(),
        'password': password,
      });

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return 'Email sudah terdaftar atau format tidak valid.';
      }
      return 'Registrasi gagal: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan saat registrasi.';
    }
  }

  // ==========================================
  // GOOGLE
  // ==========================================

  static Future<String?> signInWithGoogle() async {
    return 'Fitur Login Google sedang dialihkan ke server utama. Silakan gunakan email.';
  }

  // ==========================================
  // LOGIN
  // ==========================================

  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email.trim(),
        'password': password,
      });

      final token = response.data['access_token'];

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        return null;
      } else {
        return 'Token tidak ditemukan dari server.';
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
        return 'Email atau password salah.';
      }
      return 'Login gagal: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan saat login.';
    }
  }

  // RESET PASSWORD

  static Future<String?> resetPassword({
    required String email,
  }) async {
    try {
      await _dio.post('/auth/reset-password', data: {
        'email': email.trim(),
      });

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return 'Akun tidak ditemukan.';
      }
      return 'Gagal mengirim permintaan reset password.';
    } catch (e) {
      return 'Terjadi kesalahan. Periksa koneksi internetmu.';
    }
  }

  // ==========================================
  // LOGOUT
  // ==========================================

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ==========================================
  // CEK LOGIN
  // ==========================================

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  // Fungsi tambahan untuk mengambil token untuk dikirim di Header API lainnya
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}