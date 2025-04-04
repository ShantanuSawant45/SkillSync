import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({
    Key? key,
    required this.nextScreen,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _particleAnimationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  // For particle animation
  final List<Particle> _particles = [];
  final int _particleCount = 35;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Initialize main animation controller
    _mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Initialize pulse animation controller for the neon glow effect
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Initialize particle animation controller
    _particleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    )..repeat();

    // Setup fade-in animation
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
      ),
    );

    // Setup scale animation
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutBack),
      ),
    );

    // Setup pulse animation for the glowing effect
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Generate random particles for background animation
    _generateParticles();

    // Start animations
    _mainAnimationController.forward();

    // Navigate to next screen after 3.8 seconds
    Timer(const Duration(milliseconds: 3800), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              widget.nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Blend two transition effects: fade and slide
            var fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutQuint,
              ),
            );

            var slideAnim = Tween<Offset>(
              begin: const Offset(0.0, 0.05),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutQuint,
              ),
            );

            return FadeTransition(
              opacity: fadeAnim,
              child: SlideTransition(position: slideAnim, child: child),
            );
          },
          transitionDuration: const Duration(milliseconds: 900),
        ),
      );
    });
  }

  void _generateParticles() {
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        position: Offset(
          _random.nextDouble() * 400,
          _random.nextDouble() * 800,
        ),
        speed: 0.5 + _random.nextDouble() * 1.5,
        size: 1 + _random.nextDouble() * 2,
        color:
            _getRandomNeonColor().withOpacity(0.4 + _random.nextDouble() * 0.4),
      ));
    }
  }

  Color _getRandomNeonColor() {
    final colors = [
      const Color(0xFF00FFFF), // Cyan
      const Color(0xFF0066FF), // Blue
      const Color(0xFFFF00FF), // Magenta
      const Color(0xFF7700FF), // Purple
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _pulseAnimationController.dispose();
    _particleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF090116), // Deep purple
                  Color(0xFF1D0F31), // Mid purple
                  Color(0xFF1D1040), // Dark indigo
                  Color(0xFF000814), // Almost black
                ],
              ),
            ),
          ),

          // Animated particles
          AnimatedBuilder(
            animation: _particleAnimationController,
            builder: (context, _) {
              return CustomPaint(
                size: Size(size.width, size.height),
                painter: ParticlesPainter(
                  particles: _particles,
                  animationValue: _particleAnimationController.value,
                ),
              );
            },
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo with neon glow effect
                AnimatedBuilder(
                  animation: Listenable.merge(
                      [_mainAnimationController, _pulseAnimationController]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeInAnimation.value,
                        child: Container(
                          width: 220,
                          height: 220,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xFF00FFFF).withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00FFFF)
                                    .withOpacity(0.1 * _pulseAnimation.value),
                                blurRadius: 20 * _pulseAnimation.value,
                                spreadRadius: 5 * _pulseAnimation.value,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/logo/new_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 45),

                // Animated text with cyberpunk style
                AnimatedBuilder(
                  animation: _mainAnimationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeInAnimation.value,
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [Color(0xFF00FFFF), Color(0xFFFF00FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: const Text(
                              "SKILLSYNC",
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 3.0,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "AI CAREER ASSISTANT",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.7),
                              letterSpacing: 2.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 80),

                // Futuristic loading animation
                AnimatedBuilder(
                  animation: Listenable.merge(
                      [_mainAnimationController, _pulseAnimationController]),
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeInAnimation.value,
                      child: Container(
                        width: 180,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.easeInOut,
                              left: 0,
                              right: 180 * (1 - _mainAnimationController.value),
                              top: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF00FFFF),
                                      Color(0xFFFF00FF)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00FFFF)
                                          .withOpacity(0.5),
                                      blurRadius: 8.0,
                                      spreadRadius: 0.5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Particle class for the background animation
class Particle {
  Offset position;
  double speed;
  double size;
  Color color;

  Particle({
    required this.position,
    required this.speed,
    required this.size,
    required this.color,
  });
}

// CustomPainter for rendering particles
class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlesPainter({required this.particles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < particles.length; i++) {
      final particle = particles[i];

      // Update position based on animation value
      final yOffset = (particle.speed * animationValue * 300) % size.height;
      final adjustedY = (particle.position.dy + yOffset) % size.height;

      // Longer particles appear as light streaks
      if (i % 5 == 0) {
        // Light streak effect
        final paint = Paint()
          ..color = particle.color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = particle.size;

        canvas.drawLine(
          Offset(particle.position.dx, adjustedY),
          Offset(particle.position.dx, adjustedY - 10 - 40 * particle.speed),
          paint,
        );
      } else {
        // Regular dot particle
        final paint = Paint()
          ..color = particle.color
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(particle.position.dx, adjustedY),
          particle.size,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}
