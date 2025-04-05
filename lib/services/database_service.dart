import 'package:flutter/material.dart';

/// A service class to handle database operations for the SkillSync app.
///
/// This is a mock implementation that can be replaced with an actual MySQL
/// database connection in the future.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  /// Fetches mock interview questions for a specific tech stack or company category.
  ///
  /// In a real implementation, this would connect to a MySQL database
  /// and execute the appropriate queries.
  Future<List<Map<String, dynamic>>> getQuestionsForCategory(
      String category) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // This is mock data - in a real implementation, you would query your MySQL database
    // Example SQL query:
    // SELECT q.id, q.question_text, q.difficulty, a.answer_text, a.is_correct
    // FROM Questions q
    // JOIN Answers a ON q.id = a.question_id
    // JOIN TechStacks t ON q.tech_stack_id = t.id
    // WHERE t.name = '$category'
    // ORDER BY q.id, a.id
    // LIMIT 20;

    // Generate mock questions with answers based on the category
    List<Map<String, dynamic>> questions = [];

    // Questions differ based on the category
    if (category.contains('Flutter')) {
      questions.addAll(_getFlutterQuestions());
    } else if (category.contains('React')) {
      questions.addAll(_getReactQuestions());
    } else if (category.contains('Google')) {
      questions.addAll(_getGoogleInterviewQuestions());
    } else {
      // Generic questions for other categories
      questions = List.generate(
          20,
          (index) => {
                'question': 'Sample $category question ${index + 1}?',
                'difficulty': ['easy', 'medium', 'hard'][index % 3],
                'answers': List.generate(
                    5,
                    (ansIndex) => {
                          'text':
                              'Answer option ${ansIndex + 1} for question ${index + 1}',
                          'isCorrect': ansIndex == 0,
                        }),
              });
    }

    return questions;
  }

  /// Returns a list of Flutter development interview questions.
  List<Map<String, dynamic>> _getFlutterQuestions() {
    return [
      {
        'question':
            'What is the difference between StatelessWidget and StatefulWidget?',
        'difficulty': 'easy',
        'answers': [
          {
            'text':
                'StatelessWidget cannot change its state during the lifetime of the widget, while StatefulWidget can.',
            'isCorrect': true,
          },
          {
            'text': 'StatelessWidget is faster than StatefulWidget.',
            'isCorrect': false,
          },
          {
            'text': 'StatefulWidget cannot be updated.',
            'isCorrect': false,
          },
          {
            'text': 'StatelessWidget uses more memory than StatefulWidget.',
            'isCorrect': false,
          },
          {
            'text': 'There is no difference.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
            'What is the purpose of the "pubspec.yaml" file in a Flutter project?',
        'difficulty': 'easy',
        'answers': [
          {
            'text':
                'It specifies the dependencies, assets, and metadata of the Flutter application.',
            'isCorrect': true,
          },
          {
            'text': 'It contains the compiled code of the application.',
            'isCorrect': false,
          },
          {
            'text': 'It is used to define widget layouts.',
            'isCorrect': false,
          },
          {
            'text': 'It is used for UI testing only.',
            'isCorrect': false,
          },
          {
            'text': 'It contains the Firebase configuration.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'Explain the concept of "hot reload" in Flutter.',
        'difficulty': 'easy',
        'answers': [
          {
            'text':
                'Hot reload injects updated source code files into the running Dart VM and rebuilds the widget tree, allowing quick preview of changes.',
            'isCorrect': true,
          },
          {
            'text': 'Hot reload completely restarts the application.',
            'isCorrect': false,
          },
          {
            'text': 'Hot reload is a tool to optimize app performance.',
            'isCorrect': false,
          },
          {
            'text': 'Hot reload is used to clear cache in a Flutter app.',
            'isCorrect': false,
          },
          {
            'text':
                'Hot reload compiles the entire application to native code.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the Flutter widget tree?',
        'difficulty': 'medium',
        'answers': [
          {
            'text':
                'A hierarchical structure of widgets that describes the user interface of the application.',
            'isCorrect': true,
          },
          {
            'text': 'A data structure that stores widget performance metrics.',
            'isCorrect': false,
          },
          {
            'text': 'A tool for visualizing memory usage in Flutter.',
            'isCorrect': false,
          },
          {
            'text': 'A file that contains all the widgets used in an app.',
            'isCorrect': false,
          },
          {
            'text': 'A database of pre-built Flutter widgets.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the purpose of the "BuildContext" in Flutter?',
        'difficulty': 'medium',
        'answers': [
          {
            'text':
                'BuildContext represents the location of a widget in the widget tree and provides access to theme, media queries, and inherited widgets.',
            'isCorrect': true,
          },
          {
            'text': 'BuildContext is used only to handle user input.',
            'isCorrect': false,
          },
          {
            'text': 'BuildContext stores the state of a StatefulWidget.',
            'isCorrect': false,
          },
          {
            'text':
                'BuildContext is used to compile the widget into native code.',
            'isCorrect': false,
          },
          {
            'text': 'BuildContext is a tool for debugging Flutter apps.',
            'isCorrect': false,
          },
        ],
      },
      // Additional Flutter questions would be added here...
    ];
  }

  /// Returns a list of React.js interview questions.
  List<Map<String, dynamic>> _getReactQuestions() {
    return [
      {
        'question': 'What is React.js?',
        'difficulty': 'easy',
        'answers': [
          {
            'text':
                'A JavaScript library for building user interfaces, particularly single-page applications.',
            'isCorrect': true,
          },
          {
            'text': 'A programming language developed by Facebook.',
            'isCorrect': false,
          },
          {
            'text': 'A database management system.',
            'isCorrect': false,
          },
          {
            'text': 'A full-stack framework similar to Angular.',
            'isCorrect': false,
          },
          {
            'text': 'A mobile application development platform.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is JSX in React?',
        'difficulty': 'easy',
        'answers': [
          {
            'text':
                'JSX is a syntax extension for JavaScript that looks similar to HTML and allows us to write HTML in React.',
            'isCorrect': true,
          },
          {
            'text': 'JSX is a JavaScript compiler.',
            'isCorrect': false,
          },
          {
            'text': 'JSX is a separate programming language used with React.',
            'isCorrect': false,
          },
          {
            'text': 'JSX is a database query language for React applications.',
            'isCorrect': false,
          },
          {
            'text': 'JSX is a testing framework for React components.',
            'isCorrect': false,
          },
        ],
      },
      // Additional React questions would be added here...
    ];
  }

  /// Returns a list of Google interview questions.
  List<Map<String, dynamic>> _getGoogleInterviewQuestions() {
    return [
      {
        'question':
            'Given an array of integers, find two numbers such that they add up to a specific target.',
        'difficulty': 'medium',
        'answers': [
          {
            'text':
                'Use a hash map to store values and check for the complement of each number.',
            'isCorrect': true,
          },
          {
            'text': 'Sort the array and use binary search.',
            'isCorrect': false,
          },
          {
            'text': 'Use nested loops to check all pairs.',
            'isCorrect': false,
          },
          {
            'text': 'This problem cannot be solved in less than O(n²) time.',
            'isCorrect': false,
          },
          {
            'text': 'Use a tree data structure to find the pairs.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
            'What is the time complexity of quicksort in the worst case?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'O(n²)',
            'isCorrect': true,
          },
          {
            'text': 'O(n log n)',
            'isCorrect': false,
          },
          {
            'text': 'O(n)',
            'isCorrect': false,
          },
          {
            'text': 'O(log n)',
            'isCorrect': false,
          },
          {
            'text': 'O(n³)',
            'isCorrect': false,
          },
        ],
      },
      // Additional Google interview questions would be added here...
    ];
  }
}
