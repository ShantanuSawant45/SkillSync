import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF090116), // Deep purple
              Color(0xFF1D0F31), // Mid purple
              Color(0xFF1D1040), // Dark indigo
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: _buildLogoSection(),
                ),
              ),
              Expanded(
                flex: 3,
                child: _buildAuthOptions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo container with more subtle glowing effect
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FFFF).withOpacity(0.15),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/logo/Screenshot 2025-04-05 000055.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // App name with gradient
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00FFFF), Color(0xFFFF00FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "SKILLSYNC",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3.0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "AI Career Assistant",
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthOptions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Get Started",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Choose an option to continue",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 36),

          // Login Button - More subdued colors
          _buildAuthButton(
            context: context,
            title: 'LOGIN',
            icon: Icons.login_rounded,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2D5A7A),
                Color(0xFF3A6E95)
              ], // More subdued blue
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () {
              // Navigate to login screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Signup Button - More subdued colors
          _buildAuthButton(
            context: context,
            title: 'SIGN UP',
            icon: Icons.person_add_rounded,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF5D3A72),
                Color(0xFF6E4585)
              ], // More subdued purple
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () {
              // Navigate to signup screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignupScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          // Guest mode option
          TextButton(
            onPressed: () {
              // Navigate to home screen directly
              _navigateToHomeForDemo(context);
            },
            child: Text(
              "Continue as Guest",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // This is a temporary function for demo purposes
  void _navigateToHomeForDemo(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}
