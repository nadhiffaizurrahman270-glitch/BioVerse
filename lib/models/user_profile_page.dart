import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../views/pages/avatar_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);
  static const Color backgroundColor = Color(0xFFF0FDF4);

  final User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController _nameController = TextEditingController();

  int _selectedAvatar = 0;

  bool _loading = false;
  bool _initialized = false;

  String? _loadError;

  final List<String> _avatarPaths = List.generate(
    7,
    (index) => 'assets/avatars/avatar_${index + 1}.png',
  );

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Memuat profil pengguna dari Firebase.
  Future<void> _loadProfile() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception('Pengguna belum login.');
      }

      _nameController.text = currentUser.displayName ?? '';

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        _nameController.text =
            data['name'] as String? ??
            currentUser.displayName ??
            '';

        final avatarIndex = data['avatarIndex'];

        if (avatarIndex is num &&
            avatarIndex.toInt() >= 0 &&
            avatarIndex.toInt() < _avatarPaths.length) {
          _selectedAvatar = avatarIndex.toInt();
        }
      }
    } catch (e) {
      _loadError = e.toString();
      debugPrint('Gagal memuat profil: $e');
    } finally {
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    }
  }

  // Membuka halaman pemilihan avatar.
  Future<void> _changeAvatar() async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => ChooseAvatarPage(
          initialAvatarIndex: _selectedAvatar,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedAvatar = result;
    });
  }

  // Menyimpan nama dan avatar ke Firebase.
  Future<void> _saveProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login kembali.'),
        ),
      );
      return;
    }

    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama tidak boleh kosong.'),
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    String step = 'Memperbarui nama';

    try {
      await currentUser
          .updateDisplayName(name)
          .timeout(const Duration(seconds: 15));

      step = 'Menyimpan profil ke Firestore';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        'name': name,
        'email': currentUser.email,
        'avatarIndex': _selectedAvatar,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true))
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: primaryColor,
        ),
      );

      // Memberi tahu Dashboard bahwa profil telah diperbarui.
      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Save profile gagal pada tahap: $step');
      debugPrint('Detail error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$step gagal. Periksa koneksi dan konfigurasi Firebase.',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // Menampilkan PNG avatar.
  Widget _buildAvatar({
    required int index,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        _avatarPaths[index],
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: primaryColor,
            alignment: Alignment.center,
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: size * 0.48,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: darkColor,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Profile',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: darkColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Personalisasi identitasmu di BioVerse.',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Avatar yang sedang digunakan.
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor,
                                width: 3,
                              ),
                            ),
                            child: _buildAvatar(
                              index: _selectedAvatar,
                              size: 112,
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            'Your Avatar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'Pilih karakter favoritmu untuk BioVerse.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 18),

                          OutlinedButton.icon(
                            onPressed:
                                _initialized && !_loading
                                    ? _changeAvatar
                                    : null,
                            icon: const Icon(
                              Icons.face_retouching_natural_rounded,
                            ),
                            label: const Text('Change Avatar'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: const BorderSide(
                                color: primaryColor,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Nama pengguna.
                    const Text(
                      'Full Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: darkColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _nameController,
                      enabled: _initialized && !_loading,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Email pengguna.
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: darkColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      key: ValueKey(user?.email),
                      initialValue: user?.email ?? '-',
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F7F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    if (!_initialized)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                      ),

                    if (_loadError != null && _initialized)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Profil mungkin belum termuat sepenuhnya. '
                          'Coba periksa koneksi Firebase.\n$_loadError',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 28),

                    // Tombol simpan.
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            (!_initialized || _loading)
                                ? null
                                : _saveProfile,
                        icon: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(
                          _loading
                              ? 'Saving...'
                              : 'Save Changes',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}