import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'quiz_report_screen.dart';

class QuizInterfaceScreen extends StatefulWidget {
  final String category;

  const QuizInterfaceScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _QuizInterfaceScreenState createState() => _QuizInterfaceScreenState();
}

class _QuizInterfaceScreenState extends State<QuizInterfaceScreen> {
  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  final DatabaseService _databaseService = DatabaseService();

  // Track quiz performance
  final List<bool> _userAnswers = [];
  final List<int> _selectedAnswerIndices = [];
  bool _optionSelected = false;
  int? _selectedOptionIndex;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() => _isLoading = true);

      // Get questions from the database service
      final questions =
          await _databaseService.getQuestionsForCategory(widget.category);

      setState(() {
        _questions = questions;
        _isLoading = false;

        // Initialize tracking lists
        _userAnswers.clear();
        _selectedAnswerIndices.clear();
        for (int i = 0; i < questions.length; i++) {
          _userAnswers.add(false);
          _selectedAnswerIndices.add(-1);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading questions: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _optionSelected = false;
        _selectedOptionIndex = null;
      });
    } else {
      // End of quiz, show results
      _showQuizReport();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _optionSelected = _selectedAnswerIndices[_currentQuestionIndex] != -1;
        _selectedOptionIndex =
            _selectedAnswerIndices[_currentQuestionIndex] != -1
                ? _selectedAnswerIndices[_currentQuestionIndex]
                : null;
      });
    }
  }

  void _handleAnswerSelection(int answerIndex) {
    if (_optionSelected) return; // Prevent multiple selections

    final answer = _questions[_currentQuestionIndex]['answers'][answerIndex];
    final bool isCorrect = answer['isCorrect'];

    setState(() {
      _optionSelected = true;
      _selectedOptionIndex = answerIndex;
      _userAnswers[_currentQuestionIndex] = isCorrect;
      _selectedAnswerIndices[_currentQuestionIndex] = answerIndex;
    });

    // Show feedback
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                isCorrect
                    ? 'Correct answer!'
                    : 'Incorrect. The correct answer will be shown.',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: isCorrect
            ? Colors.green.withOpacity(0.7)
            : Colors.red.withOpacity(0.7),
        duration: const Duration(seconds: 2),
      ),
    );

    // Automatically move to next question after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_currentQuestionIndex < _questions.length - 1) {
          _nextQuestion();
        } else {
          // Last question - show report
          _showQuizReport();
        }
      }
    });
  }

  void _showQuizReport() {
    // Calculate results
    int correctAnswers = _userAnswers.where((answer) => answer).length;
    int incorrectAnswers = _userAnswers.where((answer) => !answer).length;
    int totalQuestions = _questions.length;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizReportScreen(
          category: widget.category,
          correctAnswers: correctAnswers,
          incorrectAnswers: incorrectAnswers,
          totalQuestions: totalQuestions,
          questions: _questions,
          userSelectedIndices: _selectedAnswerIndices,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog if quiz is started
        if (_currentQuestionIndex > 0 || _optionSelected) {
          bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1F38),
                  title: const Text(
                    'Quit Quiz?',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Your progress will be lost. Are you sure you want to quit?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('CONTINUE',
                          style: TextStyle(color: Colors.cyanAccent)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('QUIT',
                          style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ) ??
              false;
          return confirm;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: Text(
            widget.category,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.cyanAccent,
                ),
              )
            : _questions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No questions available for ${widget.category}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 12.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Go Back'),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress indicator
                        LinearProgressIndicator(
                          value:
                              (_currentQuestionIndex + 1) / _questions.length,
                          backgroundColor: Colors.grey[800],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.cyanAccent),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // Difficulty badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(
                                _questions[_currentQuestionIndex]
                                    ['difficulty']),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _questions[_currentQuestionIndex]['difficulty']
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Question
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey[800]!,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _questions[_currentQuestionIndex]['question'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Answers
                        Expanded(
                          child: ListView.builder(
                            itemCount: _questions[_currentQuestionIndex]
                                    ['answers']
                                .length,
                            itemBuilder: (context, index) {
                              final answer = _questions[_currentQuestionIndex]
                                  ['answers'][index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildAnswerOption(answer, index),
                              );
                            },
                          ),
                        ),

                        // Navigation buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: _currentQuestionIndex > 0
                                  ? _previousQuestion
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Previous'),
                            ),
                            if (_currentQuestionIndex < _questions.length - 1)
                              ElevatedButton(
                                onPressed:
                                    _optionSelected ? _nextQuestion : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyanAccent,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Next'),
                              )
                            else
                              ElevatedButton(
                                onPressed:
                                    _optionSelected ? _showQuizReport : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('View Results'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildAnswerOption(Map<String, dynamic> answer, int index) {
    final bool isSelected = _selectedOptionIndex == index;
    final bool isCorrect = answer['isCorrect'];
    final bool showResult = _optionSelected;

    // Determine container color based on selection and correctness
    Color containerColor = Colors.grey[850]!;
    Color borderColor = Colors.grey[700]!;

    if (showResult && isSelected) {
      // If this option was selected
      containerColor = isCorrect
          ? Colors.green.withOpacity(0.2)
          : Colors.red.withOpacity(0.2);
      borderColor = isCorrect ? Colors.green : Colors.red;
    } else if (showResult && isCorrect) {
      // Always highlight the correct answer when any option is selected
      containerColor = Colors.green.withOpacity(0.1);
      borderColor = Colors.green.withOpacity(0.5);
    }

    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: _optionSelected ? null : () => _handleAnswerSelection(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: showResult && isSelected
                      ? (isCorrect ? Colors.green : Colors.red)
                      : Colors.grey[800],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: showResult && isSelected
                        ? (isCorrect ? Colors.green : Colors.red)
                        : Colors.grey[600]!,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D, E
                    style: TextStyle(
                      color: showResult && isSelected && !isCorrect
                          ? Colors.white
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  answer['text'],
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 16,
                  ),
                ),
              ),
              if (showResult && isCorrect)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              if (showResult && isSelected && !isCorrect)
                const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
