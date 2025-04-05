import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';

class AIInterviewInterfaceScreen extends StatefulWidget {
  final String category;

  const AIInterviewInterfaceScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _AIInterviewInterfaceScreenState createState() =>
      _AIInterviewInterfaceScreenState();
}

class _AIInterviewInterfaceScreenState
    extends State<AIInterviewInterfaceScreen> {
  // Speech recognition
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _transcribedText = '';

  // Gemini API
  late final GenerativeModel _model;
  final apiKey = 'AIzaSyAFgcyNMpAv_EHuqjmRD2Z349xHW286kYk';

  // Interview state
  String _currentQuestion = '';
  String _currentFeedback = '';
  bool _isLoading = true;
  bool _isProcessing = false;
  bool _interviewStarted = false;
  int _currentQuestionNumber = 1;
  final int _totalQuestions = 7;
  List<Map<String, String>> _interviewHistory = [];

  // Scroll controller for chat history
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeGeminiAPI();
    _initializeSpeechRecognition();
    _startInterview();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeGeminiAPI() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  Future<void> _initializeSpeechRecognition() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Speech recognition status: $status');
          if (status == 'done' || status == 'notListening') {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (error) {
          print('Speech recognition error: $error');
          setState(() {
            _isListening = false;
          });

          // Show error snackbar
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error with speech recognition: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );

      setState(() {
        // Update UI if speech recognition is available
      });
    } catch (e) {
      print('Error initializing speech recognition: $e');
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing speech recognition: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _startInterview() async {
    setState(() {
      _isLoading = true;
      _interviewStarted = true;
    });

    try {
      // Make initial API call to get first question
      String firstQuestion = await _generateInterviewQuestion();

      setState(() {
        _currentQuestion = firstQuestion;
        _isLoading = false;
        _interviewHistory.add({
          'role': 'interviewer',
          'content': firstQuestion,
        });
      });

      // Scroll to bottom of conversation
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting interview: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String> _generateInterviewQuestion() async {
    try {
      final prompt = '''
You are conducting a technical interview for ${widget.category}.
Generate a relevant technical interview question (question #$_currentQuestionNumber out of $_totalQuestions).
The question should be challenging but appropriate for an interview setting.
Provide just the question without any additional text or context.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      String questionText = response.text?.trim() ??
          "What experience do you have with ${widget.category}?";

      return questionText;
    } catch (e) {
      print('Error generating question: $e');
      return "What are your experiences with ${widget.category}?";
    }
  }

  Future<String> _generateFeedback(String answer) async {
    try {
      final prompt = '''
You are conducting a technical interview for ${widget.category}.
The candidate was asked: $_currentQuestion
The candidate's answer was: $answer

Provide a brief but constructive feedback on this answer addressing:
1. Strengths of the answer
2. Areas that could be improved
3. A brief suggestion to enhance the answer

Keep the feedback concise, professional and constructive.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      String feedbackText = response.text?.trim() ??
          "Your answer shows some understanding, but try to provide more specific examples next time.";

      return feedbackText;
    } catch (e) {
      print('Error generating feedback: $e');
      return "Thank you for your answer. Try to provide more specific examples and details in your future responses.";
    }
  }

  Future<void> _submitAnswer() async {
    if (_transcribedText.isEmpty) return;

    final String answer = _transcribedText;

    setState(() {
      _isProcessing = true;
      _interviewHistory.add({
        'role': 'candidate',
        'content': answer,
      });
    });

    // Scroll to bottom of conversation
    _scrollToBottom();

    try {
      // Generate feedback based on the answer
      String feedback = await _generateFeedback(answer);

      setState(() {
        _currentFeedback = feedback;
        _interviewHistory.add({
          'role': 'feedback',
          'content': feedback,
        });
      });

      // Scroll to show feedback
      _scrollToBottom();

      // Check if we've reached the maximum number of questions
      if (_currentQuestionNumber < _totalQuestions) {
        // Increment question number and generate next question
        _currentQuestionNumber++;
        String nextQuestion = await _generateInterviewQuestion();

        setState(() {
          _currentQuestion = nextQuestion;
          _transcribedText = '';
          _isProcessing = false;
          _interviewHistory.add({
            'role': 'interviewer',
            'content': nextQuestion,
          });
        });
      } else {
        // Interview is complete
        setState(() {
          _isProcessing = false;
          _interviewHistory.add({
            'role': 'interviewer',
            'content':
                'Thank you for completing the interview! I hope the feedback has been helpful.',
          });
        });
      }

      // Scroll to bottom to show new content
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing response: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _transcribedText = '';
        });
        await _speech.listen(
          onResult: (result) {
            setState(() {
              _transcribedText = result.recognizedWords;
            });
          },
          listenFor: const Duration(seconds: 60),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          localeId: 'en_US',
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        );
      } else {
        // Show error if speech recognition is not available
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Speech recognition not available'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog if interview is in progress
        if (_interviewStarted && _interviewHistory.length > 1) {
          bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1F38),
                  title: const Text(
                    'End Interview?',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Are you sure you want to end this interview? Your progress will be lost.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('CONTINUE',
                          style: TextStyle(color: Colors.purpleAccent)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('END INTERVIEW',
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
            '${widget.category} Interview',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Interview progress indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.black26,
              child: Row(
                children: [
                  const Icon(Icons.mic, color: Colors.purpleAccent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isListening
                          ? 'Listening...'
                          : 'Tap the microphone to answer',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purpleAccent.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'Question $_currentQuestionNumber/$_totalQuestions',
                      style: TextStyle(
                        color: Colors.purpleAccent[100],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Interview conversation
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.purpleAccent,
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _interviewHistory.length,
                      itemBuilder: (context, index) {
                        final entry = _interviewHistory[index];
                        final String role = entry['role'] ?? '';
                        final String content = entry['content'] ?? '';

                        if (role == 'interviewer') {
                          return _buildInterviewerMessage(content);
                        } else if (role == 'candidate') {
                          return _buildCandidateMessage(content);
                        } else if (role == 'feedback') {
                          return _buildFeedbackMessage(content);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
            ),

            // Input area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Transcribed text display
                  if (_transcribedText.isNotEmpty || _isListening)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isListening
                              ? Colors.purpleAccent
                              : Colors.grey[700]!,
                        ),
                      ),
                      child: Text(
                        _transcribedText.isEmpty
                            ? 'Listening...'
                            : _transcribedText,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16,
                        ),
                      ),
                    ),

                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Microphone button
                      _buildMicrophoneButton(),

                      // Submit button
                      _buildSubmitButton(),
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

  Widget _buildInterviewerMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.purpleAccent.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.purpleAccent.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.psychology,
                color: Colors.purpleAccent,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Message bubble
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Interviewer',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(
                      color: Colors.deepPurple.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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

  Widget _buildCandidateMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Message bubble
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'You',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 52),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.amber.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: Colors.amber,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Feedback',
                  style: TextStyle(
                    color: Colors.amber[300],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMicrophoneButton() {
    return GestureDetector(
      onTap: _isProcessing ? null : _startListening,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isProcessing
              ? Colors.grey[700]
              : (_isListening ? Colors.red : Colors.purpleAccent),
          boxShadow: [
            BoxShadow(
              color: (_isListening ? Colors.red : Colors.purpleAccent)
                  .withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          _isListening ? Icons.stop : Icons.mic,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed:
          _isProcessing || _transcribedText.isEmpty ? null : _submitAnswer,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purpleAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        disabledBackgroundColor: Colors.grey[700],
        elevation: 5,
      ),
      child: Row(
        children: [
          Text(
            _isProcessing ? 'Processing...' : 'Submit Answer',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            _isProcessing ? Icons.hourglass_top : Icons.send,
            size: 20,
          ),
        ],
      ),
    );
  }
}
