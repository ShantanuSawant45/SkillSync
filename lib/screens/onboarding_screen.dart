import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background gradient
          Container(
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
          ),

          // Page View
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _isLastPage = index == 2;
              });
            },
            children: [
              _buildOnboardingPage(
                context: context,
                lottieAsset: 'assets/animations/ai_interview.json',
                title: 'AI Mock Interview',
                description:
                    'Prepare for job interviews with our AI-powered mock interview system. Get real-time feedback, personalized tips, and improve your interview skills with realistic scenarios tailored to your industry.',
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BFFF), Color(0xFF1E90FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              _buildOnboardingPage(
                context: context,
                lottieAsset: 'assets/animations/resume_analyser.json',
                title: 'Resume Analyzer',
                description:
                    'Optimize your resume with our AI resume analyzer. Get professional insights on how to improve your resume, highlight key skills, and increase your chances of standing out to recruiters.',
                gradient: const LinearGradient(
                  colors: [Color(0xFF32CD32), Color(0xFF228B22)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              _buildOnboardingPage(
                context: context,
                lottieAsset: 'assets/animations/summary_generator.json',
                title: 'Summary Maker',
                description:
                    'Convert your handwritten notes into concise digital summaries. Save time and enhance productivity with our AI-powered text recognition and summarization technology.',
                gradient: const LinearGradient(
                  colors: [Color(0xFFDA70D6), Color(0xFF8A2BE2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ],
          ),

          // Bottom navigation and indicator
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip button
                TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(2);
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Dot indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Color(0xFF00FFFF),
                    dotColor: Colors.white54,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 4,
                    spacing: 8,
                  ),
                ),

                // Next/Done button
                TextButton(
                  onPressed: () {
                    if (_isLastPage) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _isLastPage ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      color: Color(0xFF00FFFF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget _buildOnboardingPage({
    required BuildContext context,
    required String lottieAsset,
    required String title,
    required String description,
    required Gradient gradient,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie animation
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Lottie.asset(
              lottieAsset,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 40),

          // Title with gradient
          ShaderMask(
            shaderCallback: (bounds) => gradient.createShader(bounds),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
