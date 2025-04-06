import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Feature_pages/AI_mock_interview_screen.dart';
import '../Feature_pages/Quiz_screen.dart';
import '../Feature_pages/resume_analyser.dart';
import '../Feature_pages/posture_detector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _backgroundAnimController;
  late AnimationController _cardsAnimController;

  final List<FeatureCard> _featureCards = [
    FeatureCard(
      title: 'QuizCraft: Tech Edition',
      description: 'Test your skills with  quizzes',
      iconData: Icons.record_voice_over,
      gradient: const LinearGradient(
        colors: [Color(0xFF2D5A7A), Color(0xFF3A6E95)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      screen: const Quizscreen(),
    ),
    FeatureCard(
      title: 'AI Mock Interview',
      description: 'Practice interviews with AI feedback and coaching',
      iconData: Icons.record_voice_over,
      gradient: const LinearGradient(
        colors: [Color(0xFF2D5A7A), Color(0xFF3A6E95)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      screen: const AIMockInterviewScreen(),
    ),
    FeatureCard(
      title: 'Resume Analyzer',
      description: 'Get professional insights on your resume',
      iconData: Icons.description,
      gradient: const LinearGradient(
        colors: [Color(0xFF5D3A72), Color(0xFF6E4585)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      screen: const ResumeAnalyser(),
    ),
    FeatureCard(
      title: 'Posture Detector',
      description: 'Get a score on your posture',
      iconData: Icons.text_fields,
      gradient: const LinearGradient(
        colors: [Color(0xFF00667C), Color(0xFF127E83)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      screen: const Posturedetector(),
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _backgroundAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _cardsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _backgroundAnimController.dispose();
    _cardsAnimController.dispose();
    super.dispose();
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      // Navigation will be handled by the auth state listener in main.dart
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated background
          AnimatedBackground(controller: _backgroundAnimController),

          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar
                _buildAppBar(),

                // Welcome message
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${_auth.currentUser?.displayName?.split(' ')[0] ?? 'User'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Orbitron',
                          letterSpacing: 1,
                          shadows: [
                            Shadow(
                              color: Color(0xFF00FFFF),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enhance your career with AI-powered tools',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Feature cards
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: _featureCards.length,
                      itemBuilder: (context, index) {
                        return _buildFeatureCardItem(
                          context,
                          _featureCards[index],
                          index,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00FFFF), Color(0xFF00AAFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FFFF).withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'SS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'SkillSync',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Orbitron',
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: _signOut,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCardItem(
    BuildContext context,
    FeatureCard card,
    int index,
  ) {
    // Staggered animation for cards
    final Animation<double> animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _cardsAnimController,
        curve: Interval(
          index * 0.1,
          0.6 + index * 0.1,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Clamp the opacity value between 0.0 and 1.0
        final clampedOpacity = animation.value.clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(0, 50 * (1 - animation.value)),
          child: Opacity(
            opacity: clampedOpacity,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: GlassmorphicCard(
          gradient: card.gradient,
          title: card.title,
          description: card.description,
          iconData: card.iconData,
          onTap: () => _navigateToFeatureScreen(context, card.screen),
        ),
      ),
    );
  }

  void _navigateToFeatureScreen(BuildContext context, Widget targetScreen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}

// Classes and widgets for the home screen

class FeatureCard {
  final String title;
  final String description;
  final IconData iconData;
  final Gradient gradient;
  final Widget screen;

  FeatureCard({
    required this.title,
    required this.description,
    required this.iconData,
    required this.gradient,
    required this.screen,
  });
}

class GlassmorphicCard extends StatefulWidget {
  final Gradient gradient;
  final String title;
  final String description;
  final IconData iconData;
  final VoidCallback onTap;

  const GlassmorphicCard({
    Key? key,
    required this.gradient,
    required this.title,
    required this.description,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  State<GlassmorphicCard> createState() => _GlassmorphicCardState();
}

class _GlassmorphicCardState extends State<GlassmorphicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.colors.first
                        .withOpacity(0.3 * _glowAnimation.value),
                    blurRadius: 15 * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Icon with gradient background
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: widget.gradient,
                            boxShadow: [
                              BoxShadow(
                                color: widget.gradient.colors.first
                                    .withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.iconData,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Orbitron',
                                  shadows: [
                                    Shadow(
                                      color: widget.gradient.colors.first
                                          .withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Arrow icon
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedBackground extends StatelessWidget {
  final AnimationController controller;

  const AnimatedBackground({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF090116), // Deep purple
                Color(0xFF1D0F31), // Mid purple
                Color(0xFF1D1040), // Dark indigo
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Grid lines
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return CustomPaint(
              size: MediaQuery.of(context).size,
              painter: GridPainter(
                progress: controller.value,
              ),
            );
          },
        ),

        // Particles
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return CustomPaint(
              size: MediaQuery.of(context).size,
              painter: ParticlesPainter(
                progress: controller.value,
              ),
            );
          },
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  final double progress;

  GridPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paintH = Paint()
      ..color = Colors.blue.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final paintV = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 30.0;

    // Animate the lines with a wave effect
    for (double i = 0; i < size.width; i += spacing) {
      // Apply a sine wave to the horizontal lines
      double offsetY = 5 * sin((progress * 2 * pi) + (i / 30));

      canvas.drawLine(
        Offset(0, i + offsetY),
        Offset(size.width, i + offsetY),
        paintH,
      );
    }

    for (double i = 0; i < size.height; i += spacing) {
      // Apply a sine wave to the vertical lines
      double offsetX = 5 * sin((progress * 2 * pi) + (i / 30));

      canvas.drawLine(
        Offset(i + offsetX, 0),
        Offset(i + offsetX, size.height),
        paintV,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class ParticlesPainter extends CustomPainter {
  final double progress;
  final Random _random = Random(42); // Fixed seed for consistent particles
  final int particleCount = 50;

  ParticlesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Generate and draw particles
    for (int i = 0; i < particleCount; i++) {
      // Determine size and opacity based on index
      double particleSize = 1 + _random.nextDouble() * 3;
      double opacity = 0.3 + _random.nextDouble() * 0.5;

      // Calculate position with animation
      double x = (_random.nextDouble() * size.width);
      double baseY = (_random.nextDouble() * size.height);

      // Move particles upward slowly and loop
      double animatedY = (baseY - (progress * 100)) % size.height;

      // Flickering effect
      double flicker = 0.7 + 0.3 * sin((progress * 10) + (i * 0.2));

      // Different colors for variety
      Color particleColor;
      int colorChoice = i % 3;

      switch (colorChoice) {
        case 0:
          particleColor = const Color(0xFF00FFFF); // Cyan
          break;
        case 1:
          particleColor = const Color(0xFF1E90FF); // Blue
          break;
        default:
          particleColor = const Color(0xFFFF00FF); // Magenta
      }

      final paint = Paint()
        ..color = particleColor.withOpacity(opacity * flicker)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, animatedY),
        particleSize,
        paint,
      );

      // Draw a small glow around larger particles
      if (particleSize > 2) {
        final glowPaint = Paint()
          ..color = particleColor.withOpacity(opacity * flicker * 0.5)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

        canvas.drawCircle(
          Offset(x, animatedY),
          particleSize * 2,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
