import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
        'nama': name.trim(), // backend (schemas.UserCreate) memakai field 'nama'
        'email': email.trim(),
        'password': password,
      });

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return 'Email sudah terdaftar atau format tidak valid.';
      }
      if (e.response?.statusCode == 422) {
        return 'Data tidak valid. Periksa nama, email, dan password.';
      }
      return 'Registrasi gagal: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan saat registrasi.';
    }
  }

  // ==========================================
  // GOOGLE
  // ==========================================

  static Future<void>? _googleInit;

  /// Inisialisasi Google Sign-In satu kali saja.
  /// Di web, Client ID dibaca dari <meta name="google-signin-client_id">
  /// di web/index.html.
  static Future<void> ensureGoogleInitialized() {
    return _googleInit ??= GoogleSignIn.instance.initialize();
  }

  /// Stream hasil login Google. Di Flutter Web, hasil login dari tombol
  /// resmi Google masuk lewat stream ini (authenticate() tidak didukung web).
  static Future<Stream<GoogleSignInAuthenticationEvent>>
      googleAuthEvents() async {
    await ensureGoogleInitialized();
    return GoogleSignIn.instance.authenticationEvents;
  }

  /// Tukar id_token Google dengan JWT BioVerse dari backend.
  /// Mengembalikan null jika sukses, atau pesan error.
  static Future<String?> loginWithGoogleIdToken(String idToken) async {
    try {
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
      final data = e.response?.data;
      final detail = data is Map ? data['detail'] : null;
      return 'Login Google gagal: ${detail ?? e.message}';
    } catch (e) {
      return 'Terjadi kesalahan saat login dengan Google: $e';
    }
  }

  /// Login Google untuk Android/iOS/desktop (tombol kustom).
  /// Di web gunakan tombol resmi + googleAuthEvents().
  static Future<String?> signInWithGoogle() async {
    if (kIsWeb) {
      return 'Di web, gunakan tombol resmi Google.';
    }
    try {
      await ensureGoogleInitialized();

      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        return 'Platform ini belum mendukung login Google.';
      }

      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();
      final String? idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        return 'Gagal mendapatkan token Google.';
      }
      return loginWithGoogleIdToken(idToken);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return 'Login Google dibatalkan.';
      }
      return 'Login Google gagal: ${e.description ?? e.code.name}';
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
      // Backend memakai OAuth2PasswordRequestForm: form-urlencoded,
      // dan email dikirim lewat field 'username'.
      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': email.trim(),
          'password': password,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

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