import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';

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

  // Text to speech
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  // Gemini API
  late final GenerativeModel _model;
  final apiKey = 'AIzaSyAFgcyNMpAv_EHuqjmRD2Z349xHW286kYk';
  final apiBaseUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

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
    _initializeTextToSpeech();
    _startInterview();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _initializeGeminiAPI() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  Future<void> _initializeTextToSpeech() async {
    try {
      print("TTS: Initializing");
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      // Try to get available voices
      try {
        var voices = await _flutterTts.getVoices;
        print("TTS: Available voices: $voices");
      } catch (e) {
        print("TTS: Could not get voices: $e");
      }

      // Try to get available languages
      try {
        var languages = await _flutterTts.getLanguages;
        print("TTS: Available languages: $languages");
      } catch (e) {
        print("TTS: Could not get languages: $e");
      }

      _flutterTts.setStartHandler(() {
        print("TTS: Start handler called");
        setState(() {
          _isSpeaking = true;
        });
      });

      _flutterTts.setCompletionHandler(() {
        print("TTS: Completion handler called");
        setState(() {
          _isSpeaking = false;
        });
      });

      _flutterTts.setErrorHandler((error) {
        print("TTS Error: $error");
        setState(() {
          _isSpeaking = false;
        });
      });

      // Try a test speech
      print("TTS: Trying test speech");
      await _flutterTts.speak("TTS initialization complete");
    } catch (e) {
      print("TTS: Error during initialization: $e");
    }
  }

  Future<void> _speak(String text) async {
    if (text.isEmpty) {
      print("TTS: Text is empty, not speaking");
      return;
    }

    print(
        "TTS: About to speak: '${text.substring(0, text.length > 50 ? 50 : text.length)}...'");

    if (_isSpeaking) {
      print("TTS: Already speaking, stopping first");
      await _flutterTts.stop();
    }

    try {
      print("TTS: Speaking now");
      var result = await _flutterTts.speak(text);
      print("TTS: Speak result: $result");
    } catch (e) {
      print("TTS: Error while speaking: $e");
    }
  }

  // A helper method to speak with completion callback
  Future<void> _speakWithCallback(String text, {Function? onComplete}) async {
    if (text.isEmpty) {
      print("TTS: Text is empty, not speaking");
      if (onComplete != null) {
        onComplete();
      }
      return;
    }

    print(
        "TTS: About to speak with callback: '${text.substring(0, text.length > 50 ? 50 : text.length)}...'");

    if (_isSpeaking) {
      print("TTS: Already speaking, stopping first");
      await _flutterTts.stop();
    }

    // Set up a one-time completion listener
    void onCompleteHandler() {
      print("TTS: Completion handler for callback speaking");
      if (onComplete != null) {
        onComplete();
      }
      // Remove the handler after it's called
      _flutterTts.setCompletionHandler(() {
        print("TTS: Regular completion handler called");
        setState(() {
          _isSpeaking = false;
        });
      });
    }

    // Temporarily override completion handler
    _flutterTts.setCompletionHandler(onCompleteHandler);

    setState(() {
      _isSpeaking = true;
    });

    try {
      print("TTS: Speaking with callback now");
      var result = await _flutterTts.speak(text);
      print("TTS: Speak with callback result: $result");
      if (result != 1) {
        // If speak failed, manually call the completion handler
        onCompleteHandler();
      }
    } catch (e) {
      print("TTS: Error while speaking with callback: $e");
      // Make sure to call completion handler even on error
      onCompleteHandler();
    }
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

      // If we got an empty question back, use a default one
      if (firstQuestion.trim().isEmpty) {
        print("INTERVIEW: Received empty question, using default");
        firstQuestion = _getDefaultQuestion(_currentQuestionNumber);
      }

      setState(() {
        _currentQuestion = firstQuestion;
        _isLoading = false;
        _interviewHistory.add({
          'role': 'interviewer',
          'content': firstQuestion,
        });
      });

      print("INTERVIEW: First question added to history, now calling speak");
      // Read the question aloud
      _speak(firstQuestion);

      // Scroll to bottom of conversation
      _scrollToBottom();
    } catch (e) {
      // Use default question if API fails
      final defaultQuestion = _getDefaultQuestion(_currentQuestionNumber);

      setState(() {
        _currentQuestion = defaultQuestion;
        _isLoading = false;
        _interviewHistory.add({
          'role': 'interviewer',
          'content': defaultQuestion,
        });
      });

      print("INTERVIEW: Using default question due to error: $e");
      _speak(defaultQuestion);
      _scrollToBottom();
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

      final response = await http.post(
        Uri.parse('$apiBaseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("API Response Structure: ${jsonResponse.keys}");

        try {
          // Attempt to parse the question from the response
          String questionText = "";
          if (jsonResponse.containsKey('candidates') &&
              jsonResponse['candidates'].isNotEmpty &&
              jsonResponse['candidates'][0].containsKey('content') &&
              jsonResponse['candidates'][0]['content'].containsKey('parts') &&
              jsonResponse['candidates'][0]['content']['parts'].isNotEmpty) {
            questionText = jsonResponse['candidates'][0]['content']['parts'][0]
                        ['text']
                    ?.trim() ??
                "";
            print(
                "Successfully extracted question text: ${questionText.substring(0, questionText.length > 50 ? 50 : questionText.length)}...");
          } else {
            print(
                "Cannot find expected fields in response structure: $jsonResponse");
            // Fallback to default question
            questionText =
                "What experience do you have with ${widget.category}?";
          }

          // After getting the text, schedule to speak it (for debugging)
          print(
              "Will speak question text: ${questionText.substring(0, questionText.length > 50 ? 50 : questionText.length)}...");

          return questionText;
        } catch (e) {
          print("Error parsing response: $e");
          return "What experience do you have with ${widget.category}?";
        }
      } else {
        print(
            'Error from Gemini API: ${response.statusCode}, ${response.body}');
        return "What are your experiences with ${widget.category}?";
      }
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

      final response = await http.post(
        Uri.parse('$apiBaseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("Feedback API Response Structure: ${jsonResponse.keys}");

        try {
          // Attempt to parse the feedback from the response
          String feedbackText = "";
          if (jsonResponse.containsKey('candidates') &&
              jsonResponse['candidates'].isNotEmpty &&
              jsonResponse['candidates'][0].containsKey('content') &&
              jsonResponse['candidates'][0]['content'].containsKey('parts') &&
              jsonResponse['candidates'][0]['content']['parts'].isNotEmpty) {
            feedbackText = jsonResponse['candidates'][0]['content']['parts'][0]
                        ['text']
                    ?.trim() ??
                "";
            print(
                "Successfully extracted feedback text: ${feedbackText.substring(0, feedbackText.length > 50 ? 50 : feedbackText.length)}...");
          } else {
            print(
                "Cannot find expected fields in feedback response: $jsonResponse");
            // Fallback to default feedback
            feedbackText =
                "Your answer shows some understanding, but try to provide more specific examples next time.";
          }

          // After getting the text, schedule to speak it (for debugging)
          print(
              "Will speak feedback text: ${feedbackText.substring(0, feedbackText.length > 50 ? 50 : feedbackText.length)}...");

          return feedbackText;
        } catch (e) {
          print("Error parsing feedback response: $e");
          return "Your answer shows some understanding, but try to provide more specific examples next time.";
        }
      } else {
        print(
            'Error from Gemini API: ${response.statusCode}, ${response.body}');
        return "Thank you for your answer. Try to provide more specific examples and details in your future responses.";
      }
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

      // If feedback is empty, use default
      if (feedback.trim().isEmpty) {
        print("FEEDBACK: Received empty feedback, using default");
        feedback = _getDefaultFeedback();
      }

      setState(() {
        _currentFeedback = feedback;
        _interviewHistory.add({
          'role': 'feedback',
          'content': feedback,
        });
      });

      print("FEEDBACK: Feedback added to history, now calling speak");

      // Check if we've reached the maximum number of questions
      if (_currentQuestionNumber < _totalQuestions) {
        // Increment question number and generate next question
        _currentQuestionNumber++;
        String nextQuestion = await _generateInterviewQuestion();

        // If we got an empty question back, use a default one
        if (nextQuestion.trim().isEmpty) {
          print("INTERVIEW: Received empty next question, using default");
          nextQuestion = _getDefaultQuestion(_currentQuestionNumber);
        }

        // Store the next question for later use
        final String currentNextQuestion = nextQuestion;

        setState(() {
          _currentQuestion = nextQuestion;
          _transcribedText = '';
          _isProcessing = false;
          _interviewHistory.add({
            'role': 'interviewer',
            'content': nextQuestion,
          });
        });

        // Read the feedback aloud first, then speak the next question when feedback is complete
        print(
            "INTERVIEW: Speaking feedback, will speak next question when complete");

        // Scroll to show feedback
        _scrollToBottom();

        // Use the callback version to ensure next question is read only after feedback completes
        _speakWithCallback(feedback, onComplete: () {
          print(
              "FEEDBACK: Completed speaking feedback, now scheduling next question");
          // Additional delay after feedback completes before reading the next question
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              print("INTERVIEW: Now speaking next question");
              _speak(currentNextQuestion);
            }
          });
        });
      } else {
        // Interview is complete
        final String completionMessage =
            'Thank you for completing the interview! I hope the feedback has been helpful.';

        setState(() {
          _isProcessing = false;
          _interviewHistory.add({
            'role': 'interviewer',
            'content': completionMessage,
          });
        });

        // Read the feedback aloud first, then speak the completion message
        print(
            "INTERVIEW: Speaking feedback, will speak completion when complete");

        // Scroll to show feedback
        _scrollToBottom();

        // Use the callback version for feedback
        _speakWithCallback(feedback, onComplete: () {
          print(
              "FEEDBACK: Completed speaking feedback, now scheduling completion message");
          // Additional delay after feedback completes before reading the completion message
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              print("INTERVIEW: Now speaking completion message");
              _speak(completionMessage);
            }
          });
        });
      }

      // Scroll to bottom to show new content
      _scrollToBottom();
    } catch (e) {
      print("ERROR: Exception in submit answer: $e");

      // Use default feedback
      final defaultFeedback = _getDefaultFeedback();

      setState(() {
        _currentFeedback = defaultFeedback;
        _interviewHistory.add({
          'role': 'feedback',
          'content': defaultFeedback,
        });
      });

      print("FEEDBACK: Using default feedback due to error");

      // Continue with next question if not at the end
      if (_currentQuestionNumber < _totalQuestions) {
        // Increment question number and use default question
        _currentQuestionNumber++;
        final defaultQuestion = _getDefaultQuestion(_currentQuestionNumber);

        final String currentDefaultQuestion = defaultQuestion;

        setState(() {
          _currentQuestion = defaultQuestion;
          _transcribedText = '';
          _isProcessing = false;
          _interviewHistory.add({
            'role': 'interviewer',
            'content': defaultQuestion,
          });
        });

        // Speak the default feedback first, then proceed to the question
        _speakWithCallback(defaultFeedback, onComplete: () {
          // Additional delay after feedback completes
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              _speak(currentDefaultQuestion);
            }
          });
        });

        _scrollToBottom();
      } else {
        // End the interview with default completion message
        final completionMessage = 'Thank you for completing the interview!';
        setState(() {
          _isProcessing = false;
          _interviewHistory.add({
            'role': 'interviewer',
            'content': completionMessage,
          });
        });

        // Speak the default feedback first, then proceed to the completion message
        _speakWithCallback(defaultFeedback, onComplete: () {
          // Additional delay after feedback completes
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              _speak(completionMessage);
            }
          });
        });
      }
    }
  }

  // Default feedback if API fails
  String _getDefaultFeedback() {
    final List<String> defaultFeedback = [
      "Your answer shows understanding of the topic. To improve, consider providing more specific examples from your experience.",
      "You've covered the basics well. For a stronger answer, try to include technical details and measurable outcomes.",
      "Good points were made in your response. To enhance it further, consider discussing real-world applications.",
      "Your answer demonstrates knowledge. To make it more compelling, try structuring it with a clear beginning, middle, and conclusion.",
      "You've shared some interesting insights. Adding specific technical challenges you've overcome would make it stronger.",
    ];

    // Get random feedback
    return defaultFeedback[
        DateTime.now().millisecondsSinceEpoch % defaultFeedback.length];
  }

  Future<void> _startListening() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    }

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

  // Fallback questions if API fails
  String _getDefaultQuestion(int questionNumber) {
    final List<String> defaultQuestions = [
      "Tell me about your experience with ${widget.category}.",
      "What challenging problems have you solved in ${widget.category}?",
      "How do you keep your ${widget.category} skills up to date?",
      "What's your approach to learning new concepts in ${widget.category}?",
      "Describe a project where you used ${widget.category} effectively.",
      "What are the most important skills for someone working with ${widget.category}?",
      "Where do you see ${widget.category} evolving in the next few years?",
    ];

    // Get question based on current number (with wraparound)
    int index = (questionNumber - 1) % defaultQuestions.length;
    return defaultQuestions[index];
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AI Interviewer',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // TTS Button
                    InkWell(
                      onTap: () => _speak(message),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.volume_up,
                          color: Colors.purpleAccent,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                // TTS Button
                InkWell(
                  onTap: () => _speak(message),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.volume_up,
                      color: Colors.amber,
                      size: 16,
                    ),
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
