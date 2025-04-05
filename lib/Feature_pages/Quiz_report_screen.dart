import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizReportScreen extends StatelessWidget {
  final String category;
  final int correctAnswers;
  final int incorrectAnswers;
  final int totalQuestions;
  final List<Map<String, dynamic>> questions;
  final List<int> userSelectedIndices;

  const QuizReportScreen({
    Key? key,
    required this.category,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.totalQuestions,
    required this.questions,
    required this.userSelectedIndices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double score =
        totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;

    String performanceMessage = '';
    Color performanceColor = Colors.cyanAccent;

    if (score >= 90) {
      performanceMessage = 'Outstanding! You\'ve mastered this topic!';
      performanceColor = Colors.green;
    } else if (score >= 70) {
      performanceMessage = 'Good job! You\'re doing well!';
      performanceColor = Colors.greenAccent;
    } else if (score >= 50) {
      performanceMessage = 'Not bad, but you should practice more.';
      performanceColor = Colors.orangeAccent;
    } else {
      performanceMessage = 'You need more practice on this topic.';
      performanceColor = Colors.redAccent;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Quiz Results',
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            tooltip: 'Close Report',
          ),
        ],
      ),
      body: Column(
        children: [
          // Performance Summary Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1A1F38),
                    const Color(0xFF2D3250),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assessment,
                          color: performanceColor,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Performance Summary',
                          style: GoogleFonts.orbitron(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildScoreProgressBar(score),
                    const SizedBox(height: 12),
                    Text(
                      '${score.toStringAsFixed(1)}% Score',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: performanceColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      performanceMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildStatItem(
                      Icons.check_circle,
                      correctAnswers.toString(),
                      'Correct Answers',
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildStatItem(
                      Icons.cancel,
                      incorrectAnswers.toString(),
                      'Incorrect Answers',
                      Colors.red,
                    ),
                    const SizedBox(height: 12),
                    _buildStatItem(
                      Icons.question_answer,
                      totalQuestions.toString(),
                      'Total Questions',
                      Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Questions Section Title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Text(
                  'Question Details',
                  style: GoogleFonts.orbitron(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),

          // Questions List
          Expanded(
            child: questions.isEmpty
                ? Center(
                    child: Text(
                      'No questions data available',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: questions.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final int userSelectedIndex = userSelectedIndices[index];
                      final bool isAnsweredCorrectly = userSelectedIndex !=
                              -1 &&
                          question['answers'][userSelectedIndex]['isCorrect'];

                      // Find the correct answer index
                      int correctIndex = 0;
                      for (int i = 0; i < question['answers'].length; i++) {
                        if (question['answers'][i]['isCorrect']) {
                          correctIndex = i;
                          break;
                        }
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isAnsweredCorrectly
                                ? Colors.green.withOpacity(0.5)
                                : Colors.red.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: isAnsweredCorrectly
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            child: Icon(
                              isAnsweredCorrectly ? Icons.check : Icons.close,
                              color: isAnsweredCorrectly
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          title: Text(
                            'Question ${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            question['question'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          children: [
                            Text(
                              question['question'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Your Answer:',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (userSelectedIndex == -1)
                              Text(
                                'Not answered',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            else
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isAnsweredCorrectly
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${String.fromCharCode(65 + userSelectedIndex)}. ${question['answers'][userSelectedIndex]['text']}',
                                      style: TextStyle(
                                        color: isAnsweredCorrectly
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (!isAnsweredCorrectly) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Correct Answer:',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${String.fromCharCode(65 + correctIndex)}. ${question['answers'][correctIndex]['text']}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('TRY AGAIN'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate back to category selection
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.category),
                    label: const Text('NEW TOPIC'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  Widget _buildScoreProgressBar(double score) {
    return Stack(
      children: [
        // Background
        Container(
          height: 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // Progress
        Container(
          height: 10,
          width: (score / 100) * double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: score >= 70
                  ? [Colors.greenAccent, Colors.green]
                  : score >= 50
                      ? [Colors.yellowAccent, Colors.orange]
                      : [Colors.orange, Colors.red],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      IconData icon, String value, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
