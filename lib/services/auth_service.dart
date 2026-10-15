import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // User yang sedang login
  static User? get currentUser => _auth.currentUser;

  // ==========================================
  // REGISTER
  // ==========================================

  static Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await credential.user?.updateDisplayName(name.trim());

      await credential.user?.reload();

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Email sudah terdaftar.';
        case 'invalid-email':
          return 'Format email tidak valid.';
        case 'weak-password':
          return 'Password terlalu lemah. Gunakan password yang lebih kuat.';
        case 'operation-not-allowed':
          return 'Login email dan password belum diaktifkan di Firebase.';
        default:
          return 'Registrasi gagal: ${e.message ?? e.code}';
      }
    } catch (e) {
      return 'Terjadi kesalahan saat registrasi.';
    }
  }

  // ==========================================
  // GOOGLE
  // ==========================================

    static Future<String?> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();

      await FirebaseAuth.instance.signInWithPopup(provider);

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'popup-closed-by-user':
          return 'Login Google dibatalkan.';
        case 'account-exists-with-different-credential':
          return 'Email sudah terdaftar menggunakan metode login lain.';
        default:
          return 'Login Google gagal: ${e.message ?? e.code}';
      }
    } catch (e) {
      return 'Terjadi kesalahan saat login dengan Google.';
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
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'Format email tidak valid.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email atau password salah.';
        case 'user-disabled':
          return 'Akun ini telah dinonaktifkan.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan. Coba lagi nanti.';
        default:
          return 'Login gagal: ${e.message ?? e.code}';
      }
    } catch (e) {
      return 'Terjadi kesalahan saat login.';
    }
  }

  static Future<String?> resetPassword({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.trim(),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'Format email tidak valid.';
        case 'user-not-found':
          return 'Akun tidak ditemukan.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan. Coba lagi nanti.';
        default:
          return 'Gagal mengirim email reset password.';
      }
    } catch (e) {
      return 'Terjadi kesalahan. Periksa koneksi internetmu.';
    }
  }

  // ==========================================
  // LOGOUT
  // ==========================================

  static Future<void> logout() async {
    await _auth.signOut();
  }

  // ==========================================
  // CEK LOGIN
  // ==========================================

  static bool get isLoggedIn => _auth.currentUser != null;
}