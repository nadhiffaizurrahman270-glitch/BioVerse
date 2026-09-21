import 'package:flutter/material.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  //Primarycolor
  static const Color primaryColor = Color(0xFF166534);
  static const Color darkColor= Color(0xFF12372A);
  static const Color lightColor = Color(0xFFE8F5E9);

  Widget _biologyCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 60,
              vertical: 20,
              ),
            child: Row(
              children: [
                // Logo
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.eco,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      'BioVerse',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: darkColor,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Navigation Menu
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Learn',
                    style: TextStyle(
                      color: darkColor,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(width: 12),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Explore',
                    style: TextStyle(
                      color: darkColor,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(width: 12),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'About',
                    style: TextStyle(
                      color: darkColor,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(width: 25),

                //SIGN IN
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the LoginPage when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 15,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),

                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hero Section

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 70,
              vertical: 80,
            ),
            decoration: const BoxDecoration(
              color: lightColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LEFT SIDE
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: primaryColor,
                              size: 16,
                            ),
                            SizedBox(width: 7),
                            Text(
                              'INTERACTIVE BIOLOGY',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Explore the Wonders of Biology',
                        style: TextStyle(
                          fontSize: 58,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                          color: darkColor,
                        ),
                      ),

                      const SizedBox(height: 25),

                      const SizedBox(
                        width: 550,
                        child: Text(
                          'Discover biology through interactive '
                          'learning, visual exploration, and '
                          'engaging experiences.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to the LoginPage when the button is pressed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'Start Learning',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 15),

                          OutlinedButton(
                            onPressed: () {
                              // Navigate to the LoginPage when the button is pressed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 18,
                              ),
                              side: const BorderSide(
                                color: Color(0xFFB7C9BE),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Explore Biology',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // RIGHT SIDE
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:  0.08),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.biotech,
                          size: 150,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Discover Biology Section

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 70,
              vertical: 80,
            ),
            child: Column(
              children: [
                const Text(
                  'Discover Biology',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: darkColor,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Start exploring the fundamental concepts of life',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: _biologyCard(
                        icon: Icons.biotech,
                        title: 'DNA',
                        description: 'Explore genetic information and DNA structures.',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _biologyCard(
                        icon: Icons.coronavirus_outlined,
                        title: 'Virus',
                        description: 'Understand virus structures and their life cycles.',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _biologyCard(
                        icon: Icons.science_outlined,
                        title: 'Cell',
                        description: 'Discover cells, organelles, and their functions.',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
}

