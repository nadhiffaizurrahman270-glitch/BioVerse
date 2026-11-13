import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final Dio _dio = Dio(
    BaseOptions(baseUrl: ApiConfig.baseUrl),
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
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        return 'Gagal mendapatkan token Google. Pastikan Client ID sudah diatur di web/index.html.';
      }

      final response = await _dio.post('/auth/google', data: {
        'id_token': idToken,
      });

      final token = response.data['access_token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        return null;
      }
      return 'Token tidak ditemukan dari server.';
    } on DioException catch (e) {
      return 'Login Google gagal: ${e.response?.data['detail'] ?? e.message}';
    } catch (e) {
      return 'Terjadi kesalahan saat login dengan Google: $e';
    }
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