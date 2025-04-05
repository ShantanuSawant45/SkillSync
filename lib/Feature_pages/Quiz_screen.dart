import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Quiz_interface_screen.dart';


class Quizscreen extends StatefulWidget {
  const Quizscreen({super.key});

  @override
  State<Quizscreen> createState() => _QuizscreenState();
}

class _QuizscreenState extends State<Quizscreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = "All";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _isSearching = _searchQuery.isNotEmpty;
    });
  }

  List<String> _getFilteredCategories() {
    List<String> displayCategories = [];

    // First apply category filter
    if (_selectedCategory == "All" || _selectedCategory == "Tech Stack") {
      displayCategories.addAll(techStackCategories);
    }

    if (_selectedCategory == "All" || _selectedCategory == "Companies") {
      displayCategories.addAll(companyCategories);
    }

    // Then apply search filter if search is active
    if (_isSearching) {
      displayCategories = displayCategories
          .where((category) => category.toLowerCase().contains(_searchQuery))
          .toList();
    }

    return displayCategories;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> filteredCategories = _getFilteredCategories();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0A0E21),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'QuizCraft: Tech Edition',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.cyanAccent.withOpacity(0.7),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.withOpacity(0.4),
                      const Color(0xFF0A0E21),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.code,
                      size: 80,
                      color: Colors.blue.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search categories...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.blueAccent),
                  suffixIcon: _isSearching
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF1A1F38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.blueAccent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
              ),
            ),
          ),

          // Category Filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryChip("All"),
                    _buildCategoryChip("Tech Stack"),
                    _buildCategoryChip("Companies"),
                    _buildCategoryChip("Popular"),
                    _buildCategoryChip("Recently Added"),
                  ],
                ),
              ),
            ),
          ),

          // Search results indicator
          if (_isSearching)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Text(
                  filteredCategories.isEmpty
                      ? 'No results found for "$_searchQuery"'
                      : 'Found ${filteredCategories.length} result${filteredCategories.length != 1 ? 's' : ''} for "$_searchQuery"',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ),
            ),

          // Empty state for no results
          if (_isSearching && filteredCategories.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 80,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No matching categories found',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try a different search term',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Categories Grid
          if (filteredCategories.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Single column for larger cards
                  childAspectRatio: 2.5, // Wider cards
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < filteredCategories.length) {
                      final category = filteredCategories[index];
                      final bool isTechStack =
                          techStackCategories.contains(category);

                      return _buildQuizCard(
                        context,
                        category,
                        isTechStack ? Icons.code : Icons.business,
                        isTechStack
                            ? [Colors.blue.shade800, Colors.blue.shade500]
                            : [Colors.purple.shade800, Colors.purple.shade500],
                      );
                    }
                    return null;
                  },
                  childCount: filteredCategories.length,
                ),
              ),
            ),

          // Bottom padding for better scrolling experience
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[300],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: const Color(0xFF1A1F38),
        selectedColor: Colors.blueAccent,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
          ),
        ),
        elevation: isSelected ? 3 : 0,
        shadowColor: Colors.blueAccent.withOpacity(0.3),
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, String title, IconData icon,
      List<Color> gradientColors) {
    return GestureDetector(
      onTap: () => _navigateToQuizInterface(context, title),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background patterns
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomPaint(
                  painter: CircuitBoardPainter(
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Icon or Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHighlightedText(
                          title,
                          _searchQuery,
                          baseStyle: GoogleFonts.orbitron(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          highlightStyle: GoogleFonts.orbitron(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                            backgroundColor: Colors.black26,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Prepare for your tech interview with real-world questions',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arrow indicator
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to highlight search query in text
  Widget _buildHighlightedText(
    String text,
    String query, {
    required TextStyle baseStyle,
    required TextStyle highlightStyle,
  }) {
    if (query.isEmpty) {
      return Text(text, style: baseStyle);
    }

    final queryLC = query.toLowerCase();
    final textLC = text.toLowerCase();

    if (!textLC.contains(queryLC)) {
      return Text(text, style: baseStyle);
    }

    List<TextSpan> spans = [];
    int start = 0;
    int indexOfQuery;

    while (true) {
      indexOfQuery = textLC.indexOf(queryLC, start);
      if (indexOfQuery == -1) {
        // Add the remainder of the string
        spans.add(TextSpan(text: text.substring(start), style: baseStyle));
        break;
      }

      // Add the text before the query match
      if (indexOfQuery > start) {
        spans.add(TextSpan(
          text: text.substring(start, indexOfQuery),
          style: baseStyle,
        ));
      }

      // Add the highlighted query match
      spans.add(TextSpan(
        text: text.substring(indexOfQuery, indexOfQuery + query.length),
        style: highlightStyle,
      ));

      // Move start index past the current match
      start = indexOfQuery + query.length;
    }

    return RichText(text: TextSpan(children: spans));
  }

  void _navigateToQuizInterface(BuildContext context, String category) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            QuizInterfaceScreen(category: category),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.5);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

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

  // Category data
  final List<String> techStackCategories = [
    'Flutter Development',
    'React.js (Frontend Development)',
    'MERN Stack',
    'MEAN Stack',
    'Java Spring Boot',
    'Python Django / Flask',
    'Full Stack Web Development',
    'Android Native (Java/Kotlin)',
    'iOS Development (Swift)',
    'Blockchain Development',
    'Machine Learning / AI',
    'Data Science',
    'DevOps',
    'Cloud Computing',
    'Database Systems',
    'Cybersecurity / Ethical Hacking',
    'Game Development',
    'Software Testing / QA Automation',
    'System Design',
    'Data Structures and Algorithms',
  ];

  final List<String> companyCategories = [
    'Google Quiz Prep',
    'Amazon Quiz Prep',
    'Meta/Facebook Quiz Prep',
    'Microsoft Quiz Prep',
    'Flipkart Quiz Prep',
  ];
}

class CircuitBoardPainter extends CustomPainter {
  final Color color;

  CircuitBoardPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final double stepSize = 20;

    // Draw horizontal and vertical lines
    for (double x = 0; x < size.width; x += stepSize) {
      final path = Path();
      path.moveTo(x, 0);
      path.lineTo(x, size.height);
      canvas.drawPath(path, paint);
    }

    for (double y = 0; y < size.height; y += stepSize) {
      final path = Path();
      path.moveTo(0, y);
      path.lineTo(size.width, y);
      canvas.drawPath(path, paint);
    }

    // Draw some random circuit-like patterns
    final random = DateTime.now().millisecondsSinceEpoch;
    final doubleRandom = random % 5;

    final circuitPath = Path();
    circuitPath.moveTo(0, stepSize * doubleRandom);
    circuitPath.lineTo(size.width * 0.3, stepSize * doubleRandom);
    circuitPath.lineTo(size.width * 0.3, size.height * 0.7);
    circuitPath.lineTo(size.width * 0.7, size.height * 0.7);
    circuitPath.lineTo(size.width * 0.7, size.height * 0.3);
    circuitPath.lineTo(size.width, size.height * 0.3);

    canvas.drawPath(circuitPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
