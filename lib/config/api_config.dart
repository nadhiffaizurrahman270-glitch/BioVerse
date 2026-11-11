import 'package:flutter/foundation.dart';

/// Konfigurasi alamat backend API, dipakai bersama oleh semua service
/// yang bicara ke backend (ApiService, AITutorService).
///
/// Satu-satunya cara mengubah alamat production adalah lewat
/// `--dart-define=API_BASE_URL=...` saat build (lihat
/// .github/workflows/deploy.yml). Endpoint di bawah backend ini
/// (/materi, /ai/tutor) TIDAK berubah, cuma base URL-nya yang pindah
/// antara development dan production.
class ApiConfig {
  const ApiConfig._();

  /// Diisi lewat `--dart-define=API_BASE_URL=https://domain-backend/api/v1`.
  /// String kosong kalau tidak diisi (misal: `flutter run` biasa).
  static const String _override = String.fromEnvironment('API_BASE_URL');

  /// Base URL REST API, tanpa trailing slash.
  ///
  /// - Kalau `API_BASE_URL` diisi saat build (biasanya untuk production),
  ///   nilai itu yang dipakai.
  /// - Kalau tidak diisi, dipakai alamat development:
  ///   - Web (`flutter run -d chrome`) -> `http://127.0.0.1:8000`
  ///   - Android emulator -> `http://10.0.2.2:8000` (alias host
  ///     komputer dari dalam emulator)
  ///   - Platform lain (iOS simulator, desktop) -> `http://127.0.0.1:8000`
  static String get baseUrl {
    if (_override.isNotEmpty) {
      // Buang trailing slash kalau ada, supaya aman digabung '/materi' dsb.
      return _override.endsWith('/')
          ? _override.substring(0, _override.length - 1)
          : _override;
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api/v1';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api/v1';
    }

    return 'http://127.0.0.1:8000/api/v1';
  }

  static String get materiUrl => '$baseUrl/materi';

  static String get aiTutorUrl => '$baseUrl/ai/tutor';
}
