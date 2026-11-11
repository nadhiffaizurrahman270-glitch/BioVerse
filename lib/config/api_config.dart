/// Konfigurasi alamat backend BioVerse.
/// Bisa dioverride saat build dengan --dart-define=API_BASE_URL=...
class ApiConfig {
  const ApiConfig._();

  static const String _override = String.fromEnvironment('API_BASE_URL');

  /// Backend FastAPI pada home server.
  static const String _productionBaseUrl =
      'https://api.ancode.my.id/api/v1';

  static String get baseUrl {
    final configured = _override.trim();

    if (configured.isEmpty) {
      return _productionBaseUrl;
    }

    return configured.endsWith('/')
        ? configured.substring(0, configured.length - 1)
        : configured;
  }

  static String get materiUrl => '$baseUrl/materi';

  static String get aiTutorUrl => '$baseUrl/ai/tutor';
}
