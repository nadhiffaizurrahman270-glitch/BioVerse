import 'package:flutter/material.dart';
import '../widgets/cell_background.dart';
import '../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor = Color(0xFF12372A);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty) {
      _showError('Nama harus diisi.');
      return;
    }

    if (email.isEmpty) {
      _showError('Email harus diisi.');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showError('Masukkan alamat email yang valid.');
      return;
    }

    if (password.isEmpty) {
      _showError('Password harus diisi.');
      return;
    }

    if (password.length < 6) {
      _showError('Password minimal 6 karakter.');
      return;
    }

    if (confirmPassword != password) {
      _showError('Konfirmasi password tidak sama.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      final error = AuthService.register(
        name: name,
        email: email,
        password: password,
      );

      if (error != null) {
        setState(() {
          _isLoading = false;
        });

        _showError(error);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully! Please sign in.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade700,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),

      body: Stack(
        children: [
          const Positioned.fill(
            child: CellBackground(),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Container(
                width: 440,
                padding: const EdgeInsets.all(40),

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 35,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    // LOGO
                    Container(
                      width: 60,
                      height: 60,

                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const Icon(
                        Icons.person_add_alt_1,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // TITLE
                    const Text(
                      'Create your BioVerse Account',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: darkColor,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Create an account and start your biology journey.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // NAME
                    _buildLabel('Full Name'),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _nameController,
                      decoration: _inputDecoration(
                        hint: 'Enter your full name',
                        icon: Icons.person_outline,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // EMAIL
                    _buildLabel('Email'),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,

                      decoration: _inputDecoration(
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // PASSWORD
                    _buildLabel('Password'),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,

                      decoration: _inputDecoration(
                        hint: 'Create a password',
                        icon: Icons.lock_outline,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },

                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // CONFIRM PASSWORD
                    _buildLabel('Confirm Password'),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,

                      decoration: _inputDecoration(
                        hint: 'Confirm your password',
                        icon: Icons.lock_reset_outlined,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },

                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // SIGN UP BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 52,

                      child: ElevatedButton(
                        onPressed:
                            _isLoading ? null : _handleSignUp,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          disabledBackgroundColor:
                              primaryColor.withValues(alpha: 0.6),
                          foregroundColor: Colors.white,

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),

                          elevation: 0,
                        ),

                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,

                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // LOGIN
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // BACK
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.arrow_back,
                        size: 18,
                      ),

                      label: const Text(
                        'Back to Login',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,

      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: Icon(icon),

      suffixIcon: suffix,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),

        borderSide: const BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
    );
  }
}