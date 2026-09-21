class AuthService {
  // Menyimpan akun sementara selama aplikasi berjalan.
  static final List<Map<String, String>> _users = [];

  // User yang sedang login
  static Map<String, String>? currentUser;

  // ==========================================
  // REGISTER
  // ==========================================

  static String? register({
    required String name,
    required String email,
    required String password,
  }) {
    // Cek apakah email sudah digunakan
    final existingUser = _users.any(
      (user) => user['email'] == email,
    );

    if (existingUser) {
      return 'Email sudah terdaftar.';
    }

    // Simpan akun
    _users.add({
      'name': name,
      'email': email,
      'password': password,
    });

    return null;
  }

  // ==========================================
  // LOGIN
  // ==========================================

  static String? login({
    required String email,
    required String password,
  }) {
    Map<String, String>? user;

    try {
      user = _users.firstWhere(
        (user) =>
            user['email'] == email &&
            user['password'] == password,
      );
    } catch (_) {
      user = null;
    }

    // Akun tidak ditemukan
    if (user == null) {
      return 'Email atau password salah.';
    }

    // Simpan user yang sedang login
    currentUser = user;

    return null;
  }

  // ==========================================
  // LOGOUT
  // ==========================================

  static void logout() {
    currentUser = null;
  }

  // ==========================================
  // CEK LOGIN
  // ==========================================

  static bool get isLoggedIn {
    return currentUser != null;
  }
}