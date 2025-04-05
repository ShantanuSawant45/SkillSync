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
    }
    else if (category.contains('MERN Stack')) {
      questions.addAll(_getMERNStackQuestions());
    }else if (category.contains('MEAN Stack')) {
      questions.addAll(_getMEANStackQuestions());
    }
    else if (category.contains('Java Spring Boot')) {
      questions.addAll(_getSpringBootQuestions());
    }
    else if (category.contains('Python Django / Flask')) {
      questions.addAll(_getDjangoFlaskQuestions());
    }
    else if (category.contains('Full Stack Web Development')) {
      questions.addAll(_getFullStackWebDevQuestions());
    }
    else if (category.contains('Android Native (Java/Kotlin)')) {
      questions.addAll(_getAndroidNativeQuestions());
    }
    else if (category.contains('iOS Development (Swift)')) {
      questions.addAll(_getIOSSwiftQuestions());
    }
    else if (category.contains('Machine Learning / AI')) {
      questions.addAll(_getMachineLearningAIQuestions());
    }
    else {
      // Generic questions for other categories
      questions = List.generate(
          10,
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
            'text': 'StatelessWidget is faster than StatefulWidget.',
            'isCorrect': false,
          },
          {
            'text': 'StatefulWidget cannot be updated.',
            'isCorrect': false,
          },
          {
            'text':
            'StatelessWidget cannot change its state during the lifetime of the widget, while StatefulWidget can.',
            'isCorrect': true,
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
            'text':
            'A hierarchical structure of widgets that describes the user interface of the application.',
            'isCorrect': true,
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
      // New questions start here
      {
        'question': 'What is the purpose of the "setState()" method in Flutter?',
        'difficulty': 'medium',
        'answers': [
          {
            'text':
            'It notifies the framework that the internal state of an object has changed and triggers a rebuild of the widget.',
            'isCorrect': true,
          },
          {
            'text': 'It is used to create a new StatelessWidget.',
            'isCorrect': false,
          },
          {
            'text': 'It is used to optimize the performance of Flutter apps.',
            'isCorrect': false,
          },
          {
            'text': 'It is used to navigate between different screens.',
            'isCorrect': false,
          },
          {
            'text': 'It is used to access platform-specific APIs.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the difference between "main axis" and "cross axis" in Flutter layouts?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'They are different names for the same concept.',
            'isCorrect': false,
          },
          {
            'text':
            'In a Row, the main axis is horizontal and the cross axis is vertical. In a Column, the main axis is vertical and the cross axis is horizontal.',
            'isCorrect': true,
          },
          {
            'text': 'Main axis is always horizontal and cross axis is always vertical.',
            'isCorrect': false,
          },
          {
            'text': 'Main axis is used for positioning and cross axis is used for sizing.',
            'isCorrect': false,
          },
          {
            'text': 'Main axis applies to StatelessWidgets and cross axis applies to StatefulWidgets.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the purpose of the "Future" class in Dart/Flutter?',
        'difficulty': 'hard',
        'answers': [

          {
            'text': 'It is used to schedule UI updates at specific times.',
            'isCorrect': false,
          },
          {
            'text': 'It is used to predict user behavior in Flutter applications.',
            'isCorrect': false,
          },
          {
            'text': 'It is a widget that appears only after certain conditions are met.',
            'isCorrect': false,
          },
          {
            'text': 'It is used to define animations that will play in the future.',
            'isCorrect': false,
          },
          {
            'text':
            'It represents a potential value or error that will be available at some time in the future, used for asynchronous operations.',
            'isCorrect': true,
          },
        ],
      },
      {
        'question': 'What is Flutter\'s "Provider" package used for?',
        'difficulty': 'hard',
        'answers': [

          {
            'text': 'It\'s used to provide internet connectivity to Flutter apps.',
            'isCorrect': false,
          },
          {
            'text': 'It\'s used to provide access to hardware features like camera and GPS.',
            'isCorrect': false,
          },
          {
            'text':
            'It\'s a state management solution that uses the InheritedWidget to make it easier to pass data down the widget tree.',
            'isCorrect': true,
          },
          {
            'text': 'It\'s used to provide pre-built UI components.',
            'isCorrect': false,
          },
          {
            'text': 'It\'s used to provide translations for internationalization.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the purpose of the "Keys" in Flutter widgets?',
        'difficulty': 'hard',
        'answers': [

          {
            'text': 'Keys are used to encrypt data within Flutter applications.',
            'isCorrect': false,
          },
          {
            'text': 'Keys are used to lock specific widgets to prevent updates.',
            'isCorrect': false,
          },
          {
            'text':
            'Keys help Flutter identify widgets uniquely when they move around in the widget tree, especially in lists or collections of widgets.',
            'isCorrect': true,
          },
          {
            'text': 'Keys are used only for authentication purposes.',
            'isCorrect': false,
          },
          {
            'text': 'Keys are used to optimize the rendering of widgets.',
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
            'text': 'A programming language developed by Facebook.',
            'isCorrect': false,
          },
          {
            'text':
            'A JavaScript library for building user interfaces, particularly single-page applications.',
            'isCorrect': true,
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
            'text':
            'JSX is a syntax extension for JavaScript that looks similar to HTML and allows us to write HTML in React.',
            'isCorrect': true,
          },
          {
            'text': 'JSX is a testing framework for React components.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the purpose of state in React?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'State is used only for storing user input in forms.',
            'isCorrect': false,
          },
          {
            'text': 'State is used to style React components.',
            'isCorrect': false,
          },
          {
            'text': 'State is used only for communicating with a server.',
            'isCorrect': false,
          },
          {
            'text':
            'State is an object that contains data or information about the component that can change over time.',
            'isCorrect': true,
          },
          {
            'text': 'State is used to define the structure of a component.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What are props in React?',
        'difficulty': 'easy',
        'answers': [

          {
            'text': 'Props are functions used to update the state of a component.',
            'isCorrect': false,
          },
          {
            'text': 'Props are styling attributes for React components.',
            'isCorrect': false,
          },
          {
            'text': 'Props are libraries of pre-built React components.',
            'isCorrect': false,
          },
          {
            'text': 'Props are event handlers in React.',
            'isCorrect': false,
          },
          {
            'text':
            'Props are read-only data that are passed from a parent component to a child component.',
            'isCorrect': true,
          },
        ],
      },
      {
        'question': 'What is the virtual DOM in React?',
        'difficulty': 'medium',
        'answers': [
          {
            'text':
            'A lightweight copy of the actual DOM that React uses for performance optimization by minimizing direct DOM manipulation.',
            'isCorrect': true,
          },
          {
            'text': 'An alternative to the browser\'s DOM that only works in React.',
            'isCorrect': false,
          },
          {
            'text': 'A special database used by React to store component data.',
            'isCorrect': false,
          },
          {
            'text': 'A DOM created by virtual machines for React applications.',
            'isCorrect': false,
          },
          {
            'text': 'A tool for debugging React applications.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the purpose of the useEffect hook in React?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'useEffect is used only for API calls in React.',
            'isCorrect': false,
          },
          {
            'text': 'useEffect is used to create visual effects and animations.',
            'isCorrect': false,
          },
          {
            'text':
            'useEffect allows you to perform side effects in function components, similar to lifecycle methods in class components.',
            'isCorrect': true,
          },
          {
            'text': 'useEffect is a replacement for React state.',
            'isCorrect': false,
          },
          {
            'text': 'useEffect is used to optimize performance by preventing renders.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is React context?',
        'difficulty': 'hard',
        'answers': [
          {
            'text':
            'A way to pass data through the component tree without having to pass props down manually at every level.',
            'isCorrect': true,
          },
          {
            'text': 'A special type of React component that can only render once.',
            'isCorrect': false,
          },
          {
            'text': 'A debugging tool for React applications.',
            'isCorrect': false,
          },
          {
            'text': 'A method for connecting React to a database.',
            'isCorrect': false,
          },
          {
            'text': 'A replacement for React Router.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What are controlled components in React?',
        'difficulty': 'hard',
        'answers': [

          {
            'text': 'Components that cannot be modified by users.',
            'isCorrect': false,
          },
          {
            'text': 'Components that are under version control in Git.',
            'isCorrect': false,
          },
          {
            'text': 'Components that only render when instructed by parent components.',
            'isCorrect': false,
          },
          {
            'text':
            'Form elements that are controlled by React state, where the form\'s data is handled by the component rather than the DOM.',
            'isCorrect': true,
          },
          {
            'text': 'Components that are tested and verified by React\'s control system.',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the significance of keys in React lists?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'Keys are used to style individual list items differently.',
            'isCorrect': false,
          },
          {
            'text': 'Keys are required for all React components, not just lists.',
            'isCorrect': false,
          },
          {
            'text': 'Keys determine the order in which list items are displayed.',
            'isCorrect': false,
          },
          {
            'text': 'Keys are used to encrypt data in React applications.',
            'isCorrect': false,
          },
          {
            'text':
            'Keys help React identify which items have changed, are added, or are removed, which helps in efficient update of the user interface.',
            'isCorrect': true,
          },
        ],
      },
      {
        'question': 'What is Redux and how does it relate to React?',
        'difficulty': 'hard',
        'answers': [

          {
            'text': 'Redux is a replacement for React that offers better performance.',
            'isCorrect': false,
          },
          {
            'text': 'Redux is a testing framework specifically designed for React applications.',
            'isCorrect': false,
          },
          {
            'text': 'Redux is a CSS framework created by the React team.',
            'isCorrect': false,
          },
          {
            'text':
            'Redux is a state management library that can be used with React to manage the application\'s state in a predictable way.',
            'isCorrect': true,
          },
          {
            'text': 'Redux is a compiler that converts React code into optimized JavaScript.',
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
            'text': 'Sort the array and use binary search.',
            'isCorrect': false,
          },
          {
            'text': 'Use nested loops to check all pairs.',
            'isCorrect': false,
          },
          {
            'text':
            'Use a hash map to store values and check for the complement of each number.',
            'isCorrect': true,
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
            'text': 'O(n log n)',
            'isCorrect': false,
          },
          {
            'text': 'O(n²)',
            'isCorrect': true,
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
      // Added 5 more Google interview questions
      {
        'question':
        'What is the most efficient way to detect a cycle in a linked list?',
        'difficulty': 'hard',
        'answers': [

          {
            'text': 'Use a hash set to track visited nodes',
            'isCorrect': false,
          },
          {
            'text': 'Recursive depth-first traversal',
            'isCorrect': false,
          },
          {
            'text': 'Count the total number of nodes first',
            'isCorrect': false,
          },
          {
            'text': 'Floyd\'s Cycle-Finding Algorithm (Tortoise and Hare)',
            'isCorrect': true,
          },
          {
            'text': 'Mark visited nodes by modifying their values',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'In system design, what is the purpose of a load balancer?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To distribute network traffic across multiple servers to ensure high availability',
            'isCorrect': true,
          },
          {
            'text': 'To compress data before storage',
            'isCorrect': false,
          },
          {
            'text': 'To encrypt traffic between client and server',
            'isCorrect': false,
          },
          {
            'text': 'To cache frequently accessed data',
            'isCorrect': false,
          },
          {
            'text': 'To validate user authentication tokens',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What data structure would you use to implement an LRU (Least Recently Used) cache?',
        'difficulty': 'hard',
        'answers': [

          {
            'text': 'Binary search tree',
            'isCorrect': false,
          },
          {
            'text': 'Stack',
            'isCorrect': false,
          },
          {
            'text': 'Priority queue',
            'isCorrect': false,
          },
          {
            'text': 'Array',
            'isCorrect': false,
          },
          {
            'text': 'Hashmap + Doubly linked list',
            'isCorrect': true,
          },
        ],
      },
      {
        'question':
        'How would you find all anagrams of a string?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'Generate all permutations and check each one',
            'isCorrect': false,
          },
          {
            'text': 'Sort each string and compare',
            'isCorrect': false,
          },
          {
            'text': 'Use a trie data structure',
            'isCorrect': false,
          },
          {
            'text': 'Use a frequency counter/histogram of characters',
            'isCorrect': true,
          },
          {
            'text': 'Regular expressions',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the difference between process and thread?',
        'difficulty': 'easy',
        'answers': [

          {
            'text': 'Processes are faster than threads because they have less overhead',
            'isCorrect': false,
          },
          {
            'text': 'A process is an independent program with its own memory space, while threads share memory within the same process',
            'isCorrect': true,
          },
          {
            'text': 'Threads cannot communicate with each other, but processes can',
            'isCorrect': false,
          },
          {
            'text': 'Processes are managed by the application while threads are managed by the OS',
            'isCorrect': false,
          },
          {
            'text': 'There is no difference; the terms are interchangeable',
            'isCorrect': false,
          },
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _getMERNStackQuestions() {
    return [
      {
        'question':
        'What is the primary purpose of Express.js in the MERN stack?',
        'difficulty': 'easy',
        'answers': [

          {
            'text': 'To manage the front-end UI components',
            'isCorrect': false,
          },
          {
            'text': 'To create server-side web applications and APIs',
            'isCorrect': true,
          },
          {
            'text': 'To provide database functionality',
            'isCorrect': false,
          },
          {
            'text': 'To handle state management in React',
            'isCorrect': false,
          },
          {
            'text': 'To compile JavaScript code',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is MongoDB\'s primary data structure?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'JSON-like documents with dynamic schemas (BSON)',
            'isCorrect': true,
          },
          {
            'text': 'Tables with rows and columns',
            'isCorrect': false,
          },
          {
            'text': 'Key-value pairs',
            'isCorrect': false,
          },
          {
            'text': 'XML documents',
            'isCorrect': false,
          },
          {
            'text': 'Graph relationships',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of the useEffect Hook in React?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To perform side effects in function components',
            'isCorrect': true,
          },
          {
            'text': 'To create custom event handlers',
            'isCorrect': false,
          },
          {
            'text': 'To define component props',
            'isCorrect': false,
          },
          {
            'text': 'To connect to Redux store',
            'isCorrect': false,
          },
          {
            'text': 'To optimize component rendering',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'Which Node.js module is commonly used for environment variables in a MERN application?',
        'difficulty': 'easy',
        'answers': [

          {
            'text': 'envconfig',
            'isCorrect': false,
          },
          {
            'text': 'process-env',
            'isCorrect': false,
          },
          {
            'text': 'dotenv',
            'isCorrect': true,
          },
          {
            'text': 'node-config',
            'isCorrect': false,
          },
          {
            'text': 'env-vars',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the correct way to handle CORS issues in a MERN stack application?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'Disable browser security settings',
            'isCorrect': false,
          },
          {
            'text': 'Use only relative URLs in API requests',
            'isCorrect': false,
          },
          {
            'text': 'Use the cors middleware in Express',
            'isCorrect': true,
          },
          {
            'text': 'Always serve the React app from the same origin as the API',
            'isCorrect': false,
          },
          {
            'text': 'Set proxy in the React package.json file',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of JWT (JSON Web Tokens) in a MERN stack application?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'To format database queries',
            'isCorrect': false,
          },
          {
            'text': 'To manage state in React components',
            'isCorrect': false,
          },
          {
            'text': 'To compress JavaScript code',
            'isCorrect': false,
          },
          {
            'text': 'To securely transmit information between parties as a JSON object',
            'isCorrect': true,
          },
          {
            'text': 'To validate MongoDB schemas',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'In MongoDB, how do you create a reference relationship between documents?',
        'difficulty': 'hard',
        'answers': [

          {
            'text': 'Use JOIN statements like in SQL',
            'isCorrect': false,
          },
          {
            'text': 'Define foreign key constraints',
            'isCorrect': false,
          },
          {
            'text': 'Create a symbolic link between collections',
            'isCorrect': false,
          },
          {
            'text': 'MongoDB cannot create relationships between documents',
            'isCorrect': false,
          },
          {
            'text': 'Store the ObjectId of one document in another document',
            'isCorrect': true,
          },
        ],
      },
      {
        'question':
        'What is the primary advantage of using React\'s virtual DOM?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'It provides server-side rendering capabilities',
            'isCorrect': false,
          },
          {
            'text': 'It minimizes direct DOM manipulation for better performance',
            'isCorrect': true,
          },
          {
            'text': 'It allows direct access to browser APIs',
            'isCorrect': false,
          },
          {
            'text': 'It eliminates the need for JavaScript',
            'isCorrect': false,
          },
          {
            'text': 'It provides built-in state management',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Mongoose in a MERN stack application?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'To handle API routing in Express',
            'isCorrect': false,
          },
          {
            'text': 'To manage React component lifecycle',
            'isCorrect': false,
          },
          {
            'text': 'To optimize Node.js performance',
            'isCorrect': false,
          },
          {
            'text': 'To provide schema-based modeling for MongoDB',
            'isCorrect': true,
          },
          {
            'text': 'To provide user authentication',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the main difference between server-side rendering and client-side rendering in a MERN stack application?',
        'difficulty': 'hard',
        'answers': [

          {
            'text': 'Server-side rendering uses React while client-side rendering uses Angular',
            'isCorrect': false,
          },
          {
            'text': 'Server-side rendering is slower than client-side rendering',
            'isCorrect': false,
          },
          {
            'text': 'Server-side rendering generates HTML on the server, while client-side rendering generates HTML in the browser',
            'isCorrect': true,
          },
          {
            'text': 'Server-side rendering cannot work with APIs',
            'isCorrect': false,
          },
          {
            'text': 'Client-side rendering provides better security',
            'isCorrect': false,
          },
        ],
      },
    ];
  }
  List<Map<String, dynamic>> _getMEANStackQuestions() {
    return [
      {
        'question':
        'What is the primary difference between MEAN stack and MERN stack?',
        'difficulty': 'easy',
        'answers': [

          {
            'text': 'MEAN uses MySQL, while MERN uses MongoDB',
            'isCorrect': false,
          },
          {
            'text': 'MEAN uses Angular for frontend, while MERN uses React',
            'isCorrect': true,
          },

          {
            'text': 'MEAN uses Express.js, while MERN uses Koa.js',
            'isCorrect': false,
          },
          {
            'text': 'MEAN is server-side only, while MERN is full stack',
            'isCorrect': false,
          },
          {
            'text': 'MEAN uses Next.js, while MERN uses Node.js',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'Which language is Angular primarily written in?',
        'difficulty': 'easy',
        'answers': [

          {
            'text': 'JavaScript',
            'isCorrect': false,
          },
          {
            'text': 'Java',
            'isCorrect': false,
          },
          {
            'text': 'TypeScript',
            'isCorrect': true,
          },
          {
            'text': 'Python',
            'isCorrect': false,
          },
          {
            'text': 'C#',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Angular services?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'To handle HTTP requests exclusively',
            'isCorrect': false,
          },
          {
            'text': 'To create UI templates',
            'isCorrect': false,
          },
          {
            'text': 'To replace components entirely',
            'isCorrect': false,
          },
          {
            'text': 'To connect directly to MongoDB',
            'isCorrect': false,
          },
          {
            'text': 'To share data and functionality across components',
            'isCorrect': true,
          },
        ],
      },
      {
        'question':
        'What is AOT compilation in Angular?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'Ahead-of-Time compilation that converts Angular HTML and TypeScript into JavaScript during build',
            'isCorrect': true,
          },
          {
            'text': 'Angular Object Tracking for memory optimization',
            'isCorrect': false,
          },
          {
            'text': 'Asynchronous Operation Testing for performance testing',
            'isCorrect': false,
          },
          {
            'text': 'A special compiler that converts TypeScript to C++ for better performance',
            'isCorrect': false,
          },
          {
            'text': 'Angular\'s optional templating system',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Angular\'s NgModule?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'To connect to external APIs',
            'isCorrect': false,
          },
          {
            'text': 'To manage database operations',
            'isCorrect': false,
          },
          {
            'text': 'To organize the application into cohesive blocks of functionality',
            'isCorrect': true,
          },
          {
            'text': 'To replace traditional HTML elements',
            'isCorrect': false,
          },
          {
            'text': 'To optimize rendering performance',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the Angular CLI used for?',
        'difficulty': 'easy',
        'answers': [

          {
            'text': 'To connect Angular with MongoDB directly',
            'isCorrect': false,
          },
          {
            'text': 'To write server-side code in Node.js',
            'isCorrect': false,
          },
          {
            'text': 'To optimize images and assets only',
            'isCorrect': false,
          },
          {
            'text': 'To automate the development workflow with commands for creating, building, and testing Angular applications',
            'isCorrect': true,
          },
          {
            'text': 'To host the application on a production server',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'How does Angular handle dependency injection?',
        'difficulty': 'hard',
        'answers': [

          {
            'text': 'By requiring manual imports in every file',
            'isCorrect': false,
          },
          {
            'text': 'By using global variables',
            'isCorrect': false,
          },
          {
            'text': 'Through its built-in DI system that provides dependencies to components through constructors',
            'isCorrect': true,
          },
          {
            'text': 'Through the express.js middleware system',
            'isCorrect': false,
          },
          {
            'text': 'Angular does not support dependency injection',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is an Angular directive?',
        'difficulty': 'medium',
        'answers': [

          {
            'text': 'A database query helper',
            'isCorrect': false,
          },
          {
            'text': 'A type of Express.js route',
            'isCorrect': false,
          },
          {
            'text': 'A MongoDB collection',
            'isCorrect': false,
          },
          {
            'text': 'A class that adds behavior to elements in the DOM',
            'isCorrect': true,
          },
          {
            'text': 'A special CSS selector',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'How does Angular handle form validation?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'Through template-driven forms and reactive forms with built-in validators',
            'isCorrect': true,
          },
          {
            'text': 'Only through custom JavaScript functions',
            'isCorrect': false,
          },
          {
            'text': 'By sending all validation to the server',
            'isCorrect': false,
          },
          {
            'text': 'Through MongoDB schema validation',
            'isCorrect': false,
          },
          {
            'text': 'Angular does not provide form validation',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Angular\'s HttpClient module?',
        'difficulty': 'easy',
        'answers': [

          {
            'text': 'To create server-side code',
            'isCorrect': false,
          },
          {
            'text': 'To perform HTTP requests to remote servers and handle responses',
            'isCorrect': true,
          },
          {
            'text': 'To manage local storage',
            'isCorrect': false,
          },
          {
            'text': 'To handle database connections directly',
            'isCorrect': false,
          },
          {
            'text': 'To create animations',
            'isCorrect': false,
          },
        ],
      },
    ];
  }
  List<Map<String, dynamic>> _getSpringBootQuestions() {
    return [
      {
        'question':
        'What is the primary advantage of using Spring Boot over traditional Spring Framework?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'Auto-configuration and simplified dependency management with minimal setup',
            'isCorrect': true,
          },
          {
            'text': 'Better performance at runtime',
            'isCorrect': false,
          },
          {
            'text': 'Support for non-Java languages',
            'isCorrect': false,
          },
          {
            'text': 'Built-in frontend templating',
            'isCorrect': false,
          },
          {
            'text': 'Lower memory footprint',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of the @SpringBootApplication annotation?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'It combines @Configuration, @EnableAutoConfiguration, and @ComponentScan annotations',
            'isCorrect': true,
          },
          {
            'text': 'It only marks the entry point of the application',
            'isCorrect': false,
          },
          {
            'text': 'It is used to connect to databases only',
            'isCorrect': false,
          },
          {
            'text': 'It is a replacement for web.xml in traditional Java EE',
            'isCorrect': false,
          },
          {
            'text': 'It enables Spring Security features',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'How do you define application properties in a Spring Boot application?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'Using application.properties or application.yml files',
            'isCorrect': true,
          },
          {
            'text': 'By creating an XML configuration file',
            'isCorrect': false,
          },
          {
            'text': 'In the pom.xml file',
            'isCorrect': false,
          },
          {
            'text': 'By using annotations only',
            'isCorrect': false,
          },
          {
            'text': 'In a database table',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is Spring Data JPA?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'A Spring module that simplifies database access and provides repository support',
            'isCorrect': true,
          },
          {
            'text': 'A database system specifically designed for Spring Boot',
            'isCorrect': false,
          },
          {
            'text': 'A tool for migrating between different database systems',
            'isCorrect': false,
          },
          {
            'text': 'An ORM framework that replaces Hibernate entirely',
            'isCorrect': false,
          },
          {
            'text': 'A query language for Spring applications',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is a Spring Boot Actuator?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'A module that helps monitor and manage Spring Boot applications',
            'isCorrect': true,
          },
          {
            'text': 'A tool to automatically restart applications during development',
            'isCorrect': false,
          },
          {
            'text': 'A component that handles form submissions',
            'isCorrect': false,
          },
          {
            'text': 'A library for creating advanced UI components',
            'isCorrect': false,
          },
          {
            'text': 'A module for automating database migrations',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the default embedded servlet container in Spring Boot?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'Tomcat',
            'isCorrect': true,
          },
          {
            'text': 'Jetty',
            'isCorrect': false,
          },
          {
            'text': 'Undertow',
            'isCorrect': false,
          },
          {
            'text': 'WebSphere',
            'isCorrect': false,
          },
          {
            'text': 'GlassFish',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'How is dependency injection implemented in Spring Boot?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'Using annotations like @Autowired, constructor injection, and the IoC container',
            'isCorrect': true,
          },
          {
            'text': 'Through XML configurations only',
            'isCorrect': false,
          },
          {
            'text': 'By manually creating instances in the main method',
            'isCorrect': false,
          },
          {
            'text': 'Using the Service Locator pattern',
            'isCorrect': false,
          },
          {
            'text': 'Through static factory methods',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Spring Boot profiles?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To configure different environments (development, testing, production) with specific settings',
            'isCorrect': true,
          },
          {
            'text': 'To create user profiles and manage authentication',
            'isCorrect': false,
          },
          {
            'text': 'To profile application performance',
            'isCorrect': false,
          },
          {
            'text': 'To categorize Spring components by functionality',
            'isCorrect': false,
          },
          {
            'text': 'To configure different database schemas',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the difference between @Controller and @RestController in Spring Boot?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': '@RestController combines @Controller and @ResponseBody, automatically serializing responses to JSON/XML',
            'isCorrect': true,
          },
          {
            'text': '@Controller is used for REST APIs while @RestController is for web pages',
            'isCorrect': false,
          },
          {
            'text': '@RestController can\'t use view resolvers but @Controller can',
            'isCorrect': false,
          },
          {
            'text': '@RestController supports only GET requests',
            'isCorrect': false,
          },
          {
            'text': 'There is no difference between them',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'How can you secure a Spring Boot application?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'Using Spring Security with configurations for authentication, authorization, and protection against common vulnerabilities',
            'isCorrect': true,
          },
          {
            'text': 'Only by implementing custom security filters',
            'isCorrect': false,
          },
          {
            'text': 'Spring Boot applications are secure by default',
            'isCorrect': false,
          },
          {
            'text': 'By using third-party security libraries only',
            'isCorrect': false,
          },
          {
            'text': 'By restricting application.properties access',
            'isCorrect': false,
          },
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _getDjangoFlaskQuestions() {
    return [
      {
        'question':
        'What is the primary advantage of using Django over Flask?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'Django comes with a built-in admin interface, ORM, and many pre-built components',
            'isCorrect': true,
          },
          {
            'text': 'Django has better performance for high-traffic websites',
            'isCorrect': false,
          },
          {
            'text': 'Django supports Python 3 while Flask does not',
            'isCorrect': false,
          },
          {
            'text': 'Django has superior template rendering capabilities',
            'isCorrect': false,
          },
          {
            'text': 'Django requires less code to set up a basic application',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of a Django view function?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To receive HTTP requests and return HTTP responses',
            'isCorrect': true,
          },
          {
            'text': 'To define the database schema only',
            'isCorrect': false,
          },
          {
            'text': 'To handle only GET requests',
            'isCorrect': false,
          },
          {
            'text': 'To create HTML templates',
            'isCorrect': false,
          },
          {
            'text': 'To manage static files',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'How do you define application configuration in Flask?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'Using app.config dictionary or environment variables',
            'isCorrect': true,
          },
          {
            'text': 'In XML configuration files',
            'isCorrect': false,
          },
          {
            'text': 'In the requirements.txt file',
            'isCorrect': false,
          },
          {
            'text': 'Using annotations only',
            'isCorrect': false,
          },
          {
            'text': 'In a database table',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is Django ORM?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'An Object-Relational Mapping system that lets you interact with databases using Python objects',
            'isCorrect': true,
          },
          {
            'text': 'A database system specifically designed for Django',
            'isCorrect': false,
          },
          {
            'text': 'A tool for migrating between different Django versions',
            'isCorrect': false,
          },
          {
            'text': 'A front-end framework included with Django',
            'isCorrect': false,
          },
          {
            'text': 'A security feature that prevents SQL injection',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Flask Blueprint?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To organize a Flask application into modular components',
            'isCorrect': true,
          },
          {
            'text': 'To automatically restart Flask applications during development',
            'isCorrect': false,
          },
          {
            'text': 'To handle form submissions',
            'isCorrect': false,
          },
          {
            'text': 'To create advanced UI components',
            'isCorrect': false,
          },
          {
            'text': 'To automate database migrations',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the default template engine in Django?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'Django Template Language (DTL)',
            'isCorrect': true,
          },
          {
            'text': 'Jinja2',
            'isCorrect': false,
          },
          {
            'text': 'Mako',
            'isCorrect': false,
          },
          {
            'text': 'Thymeleaf',
            'isCorrect': false,
          },
          {
            'text': 'Pug',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'How does Flask handle database operations?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'Flask does not include a database abstraction layer and requires extensions like SQLAlchemy or Flask-SQLAlchemy',
            'isCorrect': true,
          },
          {
            'text': 'Through a built-in ORM similar to Django\'s',
            'isCorrect': false,
          },
          {
            'text': 'Using XML configurations only',
            'isCorrect': false,
          },
          {
            'text': 'Only through raw SQL queries',
            'isCorrect': false,
          },
          {
            'text': 'Flask has its own database engine built in',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Django\'s settings.py file?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To configure all aspects of a Django application including database connections, middleware, and installed apps',
            'isCorrect': true,
          },
          {
            'text': 'To create user profiles and manage authentication',
            'isCorrect': false,
          },
          {
            'text': 'To profile application performance',
            'isCorrect': false,
          },
          {
            'text': 'To define URL routing patterns',
            'isCorrect': false,
          },
          {
            'text': 'To store static files',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the difference between a Django Function-Based View and a Class-Based View?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'Class-Based Views offer built-in methods for HTTP verbs and inheritance features, while Function-Based Views are simpler but require more manual code',
            'isCorrect': true,
          },
          {
            'text': 'Function-Based Views can use templates but Class-Based Views cannot',
            'isCorrect': false,
          },
          {
            'text': 'Class-Based Views are deprecated in newer Django versions',
            'isCorrect': false,
          },
          {
            'text': 'Function-Based Views support only GET requests',
            'isCorrect': false,
          },
          {
            'text': 'There is no difference between them',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'How can you secure a Django application?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'Using Django\'s built-in security features like CSRF protection, authentication system, and password hashing',
            'isCorrect': true,
          },
          {
            'text': 'Only by implementing custom security middleware',
            'isCorrect': false,
          },
          {
            'text': 'Django applications are secure by default with no additional configuration',
            'isCorrect': false,
          },
          {
            'text': 'By using third-party security libraries only',
            'isCorrect': false,
          },
          {
            'text': 'By restricting settings.py access',
            'isCorrect': false,
          },
        ],
      },
    ];
  }
  List<Map<String, dynamic>> _getFullStackWebDevQuestions() {
    return [
      {
        'question':
        'What is the primary advantage of using React over vanilla JavaScript for front-end development?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'Virtual DOM implementation for improved performance and component-based architecture',
            'isCorrect': true,
          },
          {
            'text': 'React automatically handles all API calls',
            'isCorrect': false,
          },
          {
            'text': 'React doesn\'t require HTML knowledge',
            'isCorrect': false,
          },
          {
            'text': 'React performs server-side validation automatically',
            'isCorrect': false,
          },
          {
            'text': 'React doesn\'t use JavaScript syntax',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of RESTful API architecture?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To provide a standardized way for web services to communicate using HTTP methods with stateless operations',
            'isCorrect': true,
          },
          {
            'text': 'To handle only front-end rendering logic',
            'isCorrect': false,
          },
          {
            'text': 'To validate user input on the client side only',
            'isCorrect': false,
          },
          {
            'text': 'To directly connect with databases without middleware',
            'isCorrect': false,
          },
          {
            'text': 'To restrict APIs to JSON format only',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'How does CORS (Cross-Origin Resource Sharing) work?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'It uses HTTP headers to tell browsers to give a web application running at one origin access to resources from a different origin',
            'isCorrect': true,
          },
          {
            'text': 'It encrypts all data transferred between different domains',
            'isCorrect': false,
          },
          {
            'text': 'It is a client-side security mechanism only',
            'isCorrect': false,
          },
          {
            'text': 'It automatically redirects requests between domains',
            'isCorrect': false,
          },
          {
            'text': 'It is a type of authentication protocol',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the role of Node.js in full-stack JavaScript applications?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'It allows JavaScript to run on the server-side, enabling a unified language throughout the stack',
            'isCorrect': true,
          },
          {
            'text': 'It is primarily used for CSS preprocessing',
            'isCorrect': false,
          },
          {
            'text': 'It replaces the need for a database',
            'isCorrect': false,
          },
          {
            'text': 'It is a front-end framework for creating user interfaces',
            'isCorrect': false,
          },
          {
            'text': 'It is used exclusively for mobile application development',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Webpack in modern web development?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To bundle JavaScript files and other assets for usage in a browser, with features like code splitting and module loading',
            'isCorrect': true,
          },
          {
            'text': 'To create server-side rendering exclusively',
            'isCorrect': false,
          },
          {
            'text': 'To manage database migrations',
            'isCorrect': false,
          },
          {
            'text': 'To handle user authentication only',
            'isCorrect': false,
          },
          {
            'text': 'To replace CSS with JavaScript styling',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is JWT (JSON Web Token) used for in web applications?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'For securely transmitting information between parties as a compact, self-contained token, often used for authentication and authorization',
            'isCorrect': true,
          },
          {
            'text': 'For styling web pages with JavaScript',
            'isCorrect': false,
          },
          {
            'text': 'For compressing images in web applications',
            'isCorrect': false,
          },
          {
            'text': 'For creating dynamic database schemas',
            'isCorrect': false,
          },
          {
            'text': 'For connecting to multiple databases simultaneously',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What does GraphQL provide that traditional REST APIs do not?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'The ability for clients to request exactly the data they need in a single query and the flexibility to add fields without versioning',
            'isCorrect': true,
          },
          {
            'text': 'Automatic database normalization',
            'isCorrect': false,
          },
          {
            'text': 'Built-in authentication mechanisms',
            'isCorrect': false,
          },
          {
            'text': 'Faster server processing by default',
            'isCorrect': false,
          },
          {
            'text': 'Elimination of the need for front-end frameworks',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of containerization tools like Docker in web development?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To package an application with all its dependencies into a standardized unit for development, shipment, and deployment',
            'isCorrect': true,
          },
          {
            'text': 'To replace the need for back-end coding',
            'isCorrect': false,
          },
          {
            'text': 'To create responsive web designs',
            'isCorrect': false,
          },
          {
            'text': 'To optimize images and other static assets',
            'isCorrect': false,
          },
          {
            'text': 'To directly manage database connections',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the difference between localStorage and sessionStorage in web browsers?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'localStorage persists until explicitly deleted, while sessionStorage is cleared when the page session ends',
            'isCorrect': true,
          },
          {
            'text': 'localStorage is only for storing images, while sessionStorage is for text',
            'isCorrect': false,
          },
          {
            'text': 'localStorage is server-side storage, while sessionStorage is client-side',
            'isCorrect': false,
          },
          {
            'text': 'localStorage has smaller capacity than sessionStorage',
            'isCorrect': false,
          },
          {
            'text': 'There is no difference between them',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'How does Progressive Web App (PWA) technology enhance web applications?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'By enabling offline functionality, push notifications, device hardware access, and installation to the home screen, making web apps feel more like native apps',
            'isCorrect': true,
          },
          {
            'text': 'By automatically converting web code to native mobile code',
            'isCorrect': false,
          },
          {
            'text': 'By replacing the need for responsive design',
            'isCorrect': false,
          },
          {
            'text': 'By providing built-in payment processing',
            'isCorrect': false,
          },
          {
            'text': 'By eliminating the need for back-end development',
            'isCorrect': false,
          },
        ],
      },
    ];
  }
  List<Map<String, dynamic>> _getAndroidNativeQuestions() {
    return [
      {
        'question':
        'What is the primary advantage of using Kotlin over Java for Android development?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'Null safety, concise syntax, extension functions, and full interoperability with Java',
            'isCorrect': true,
          },
          {
            'text': 'Kotlin apps run twice as fast as Java apps',
            'isCorrect': false,
          },
          {
            'text': 'Kotlin requires less memory at runtime',
            'isCorrect': false,
          },
          {
            'text': 'Only Kotlin supports modern Android APIs',
            'isCorrect': false,
          },
          {
            'text': 'Kotlin has better native UI components',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of the Android Manifest file?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'It describes essential information about the app to the Android build tools, Android OS, and Google Play',
            'isCorrect': true,
          },
          {
            'text': 'It only stores app UI layouts',
            'isCorrect': false,
          },
          {
            'text': 'It is used exclusively for database schema definitions',
            'isCorrect': false,
          },
          {
            'text': 'It contains only the app\'s source code',
            'isCorrect': false,
          },
          {
            'text': 'It is used only for app styling',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the function of the Activity lifecycle method onPause()?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'It executes when the system is about to put the activity in the background or when the activity is partially obscured',
            'isCorrect': true,
          },
          {
            'text': 'It only executes when an app is uninstalled',
            'isCorrect': false,
          },
          {
            'text': 'It handles click events within the activity',
            'isCorrect': false,
          },
          {
            'text': 'It initializes the activity\'s UI components',
            'isCorrect': false,
          },
          {
            'text': 'It is triggered when the device screen orientation changes',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is Room in Android development?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'An abstraction layer over SQLite that provides compile-time verification of SQL queries and reduces boilerplate code',
            'isCorrect': true,
          },
          {
            'text': 'A layout type for creating spaces in UI design',
            'isCorrect': false,
          },
          {
            'text': 'A tool for designing responsive UIs',
            'isCorrect': false,
          },
          {
            'text': 'A real-time database for Android',
            'isCorrect': false,
          },
          {
            'text': 'A dependency injection framework',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of ViewModel in Android architecture components?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To store and manage UI-related data in a lifecycle-conscious way, surviving configuration changes like screen rotations',
            'isCorrect': true,
          },
          {
            'text': 'To directly modify the UI elements',
            'isCorrect': false,
          },
          {
            'text': 'To handle network requests only',
            'isCorrect': false,
          },
          {
            'text': 'To create custom UI views',
            'isCorrect': false,
          },
          {
            'text': 'To access device hardware like camera and sensors',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the default database in Android?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'SQLite',
            'isCorrect': true,
          },
          {
            'text': 'MySQL',
            'isCorrect': false,
          },
          {
            'text': 'MongoDB',
            'isCorrect': false,
          },
          {
            'text': 'Firebase Realtime Database',
            'isCorrect': false,
          },
          {
            'text': 'Oracle',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Kotlin Coroutines in Android development?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'To simplify asynchronous programming by providing a way to write sequential code that executes asynchronously',
            'isCorrect': true,
          },
          {
            'text': 'To manage UI layouts only',
            'isCorrect': false,
          },
          {
            'text': 'To replace XML layouts with Kotlin code',
            'isCorrect': false,
          },
          {
            'text': 'To create animations exclusively',
            'isCorrect': false,
          },
          {
            'text': 'To generate API clients automatically',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Intents in Android?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To perform communication between components like activities, services, and broadcast receivers',
            'isCorrect': true,
          },
          {
            'text': 'To only define UI layouts',
            'isCorrect': false,
          },
          {
            'text': 'To create animations between screens',
            'isCorrect': false,
          },
          {
            'text': 'To optimize app performance',
            'isCorrect': false,
          },
          {
            'text': 'To store user preferences permanently',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the difference between a Fragment and an Activity in Android?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'A Fragment is a portion of the user interface within an Activity and is dependent on an Activity, while an Activity represents a single screen with a user interface',
            'isCorrect': true,
          },
          {
            'text': 'Fragments can exist independently of Activities',
            'isCorrect': false,
          },
          {
            'text': 'Activities are always contained within Fragments',
            'isCorrect': false,
          },
          {
            'text': 'Fragments are deprecated in modern Android development',
            'isCorrect': false,
          },
          {
            'text': 'There is no difference between them',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'How can you implement data persistence in Android?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'Using SharedPreferences, Room database, files, or remote storage depending on the data type and requirements',
            'isCorrect': true,
          },
          {
            'text': 'Only by using external cloud services',
            'isCorrect': false,
          },
          {
            'text': 'Android apps cannot store data persistently',
            'isCorrect': false,
          },
          {
            'text': 'Only by using RAM memory',
            'isCorrect': false,
          },
          {
            'text': 'By storing data in the app\'s manifest file',
            'isCorrect': false,
          },
        ],
      },
    ];
  }
  List<Map<String, dynamic>> _getIOSSwiftQuestions() {
    return [
      {
        'question':
        'What is the primary advantage of using Swift over Objective-C for iOS development?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'Modern syntax, type safety, better performance, and reduced code length with features like optionals and generics',
            'isCorrect': true,
          },
          {
            'text': 'Swift apps have exclusive access to the newest iOS APIs',
            'isCorrect': false,
          },
          {
            'text': 'Swift automatically handles memory management without ARC',
            'isCorrect': false,
          },
          {
            'text': 'Swift requires less RAM than Objective-C',
            'isCorrect': false,
          },
          {
            'text': 'Swift apps can run on Android devices',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of an Info.plist file in iOS development?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To store configuration information for the app, including required capabilities, supported interface orientations, and permissions',
            'isCorrect': true,
          },
          {
            'text': 'To store only the app\'s UI layouts',
            'isCorrect': false,
          },
          {
            'text': 'To contain only source code',
            'isCorrect': false,
          },
          {
            'text': 'To define database schemas',
            'isCorrect': false,
          },
          {
            'text': 'To store user preferences only',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the function of the viewDidLoad() method in UIViewController?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'It is called after the view controller has loaded its view hierarchy into memory, where you typically perform additional setup',
            'isCorrect': true,
          },
          {
            'text': 'It is called only when the app is launched',
            'isCorrect': false,
          },
          {
            'text': 'It handles user interaction events only',
            'isCorrect': false,
          },
          {
            'text': 'It is called when the view is about to be removed',
            'isCorrect': false,
          },
          {
            'text': 'It is triggered when the device orientation changes',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is Core Data in iOS development?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'A framework for managing object graphs and object lifecycle, providing data persistence and handling tasks like undo/redo',
            'isCorrect': true,
          },
          {
            'text': 'A layout system for creating UI components',
            'isCorrect': false,
          },
          {
            'text': 'A tool exclusively for networking operations',
            'isCorrect': false,
          },
          {
            'text': 'An animation library',
            'isCorrect': false,
          },
          {
            'text': 'A real-time database for iOS',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of the MVVM architecture pattern in iOS development?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To separate the UI (View) from business logic (ViewModel) and data (Model), enhancing testability and maintainability',
            'isCorrect': true,
          },
          {
            'text': 'To directly access hardware features like camera and GPS',
            'isCorrect': false,
          },
          {
            'text': 'To handle network requests only',
            'isCorrect': false,
          },
          {
            'text': 'To create reusable UI components',
            'isCorrect': false,
          },
          {
            'text': 'To optimize app performance automatically',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the default persistence mechanism provided by iOS?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'UserDefaults (formerly NSUserDefaults)',
            'isCorrect': true,
          },
          {
            'text': 'MySQL',
            'isCorrect': false,
          },
          {
            'text': 'MongoDB',
            'isCorrect': false,
          },
          {
            'text': 'Firebase Database',
            'isCorrect': false,
          },
          {
            'text': 'SQLite',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Swift\'s Combine framework?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'To provide a declarative Swift API for processing values over time, like network responses, user interface events, or other asynchronous data',
            'isCorrect': true,
          },
          {
            'text': 'To manage UI layouts only',
            'isCorrect': false,
          },
          {
            'text': 'To replace UIKit completely',
            'isCorrect': false,
          },
          {
            'text': 'To create animations exclusively',
            'isCorrect': false,
          },
          {
            'text': 'To generate API clients automatically',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the purpose of Storyboards in iOS development?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To visually design and connect multiple view controllers, establishing the flow of the interface and relationships between screens',
            'isCorrect': true,
          },
          {
            'text': 'To only write Swift code',
            'isCorrect': false,
          },
          {
            'text': 'To create animations between screens',
            'isCorrect': false,
          },
          {
            'text': 'To optimize app performance',
            'isCorrect': false,
          },
          {
            'text': 'To store user preferences permanently',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is the difference between weak and unowned references in Swift?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'Both avoid strong reference cycles, but weak references are optional and become nil when the referenced object is deallocated, while unowned references are non-optional and assume the referenced object remains in memory',
            'isCorrect': true,
          },
          {
            'text': 'weak references improve performance while unowned references save memory',
            'isCorrect': false,
          },
          {
            'text': 'weak is used for UI elements while unowned is for data models',
            'isCorrect': false,
          },
          {
            'text': 'unowned references are deprecated in modern Swift',
            'isCorrect': false,
          },
          {
            'text': 'There is no difference between them',
            'isCorrect': false,
          },
        ],
      },
      {
        'question':
        'What is SwiftUI and how does it relate to UIKit?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'SwiftUI is a modern declarative framework for building user interfaces across all Apple platforms, while UIKit is the older imperative UI framework. They can work together in the same app',
            'isCorrect': true,
          },
          {
            'text': 'SwiftUI completely replaces UIKit and cannot be used with it',
            'isCorrect': false,
          },
          {
            'text': 'SwiftUI is only for watchOS while UIKit is for iOS',
            'isCorrect': false,
          },
          {
            'text': 'UIKit is built on top of SwiftUI',
            'isCorrect': false,
          },
          {
            'text': 'SwiftUI is only for animations while UIKit handles all other UI components',
            'isCorrect': false,
          },
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _getMachineLearningAIQuestions() {
    return [
      {
        'question': 'What is the difference between supervised and unsupervised learning?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'Supervised learning uses labeled data while unsupervised learning works with unlabeled data',
            'isCorrect': true,
          },
          {
            'text': 'Supervised learning requires more computing power than unsupervised learning',
            'isCorrect': false,
          },

          {
            'text': 'Unsupervised learning always performs better than supervised learning',
            'isCorrect': false,
          },
          {
            'text': 'Supervised learning works without human intervention',
            'isCorrect': false,
          },
          {
            'text': 'Supervised learning is only used for image recognition tasks',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is gradient descent in machine learning?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'An optimization algorithm that minimizes a loss function by iteratively moving towards the steepest descent',
            'isCorrect': true,
          },
          {
            'text': 'A technique for generating random data samples',
            'isCorrect': false,
          },
          {
            'text': 'A method for reducing the dimensionality of data',
            'isCorrect': false,
          },
          {
            'text': 'A type of neural network architecture',
            'isCorrect': false,
          },
          {
            'text': 'A data preprocessing technique',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is overfitting in machine learning?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'When a model learns the training data too well, including noise and outliers, performing poorly on new data',
            'isCorrect': true,
          },
          {
            'text': 'When a model is too complex for the available hardware',
            'isCorrect': false,
          },
          {
            'text': 'When a model trains for too many hours',
            'isCorrect': false,
          },
          {
            'text': 'When training data contains too many features',
            'isCorrect': false,
          },
          {
            'text': 'When a model requires too much memory',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is a Convolutional Neural Network (CNN) typically used for?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'Image processing and computer vision tasks',
            'isCorrect': true,
          },
          {
            'text': 'Natural language processing only',
            'isCorrect': false,
          },
          {
            'text': 'Time series forecasting only',
            'isCorrect': false,
          },
          {
            'text': 'Reinforcement learning environments',
            'isCorrect': false,
          },
          {
            'text': 'Database optimization',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is transfer learning in the context of deep learning?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'Using knowledge from one trained model to improve learning in a different but related task',
            'isCorrect': true,
          },
          {
            'text': 'Moving AI models between different computing platforms',
            'isCorrect': false,
          },
          {
            'text': 'Transferring data between training and testing sets',
            'isCorrect': false,
          },
          {
            'text': 'Converting a model from one framework to another',
            'isCorrect': false,
          },
          {
            'text': 'The process of uploading models to cloud services',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the purpose of activation functions in neural networks?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To introduce non-linearity, allowing networks to learn complex patterns',
            'isCorrect': true,
          },
          {
            'text': 'To speed up the training process only',
            'isCorrect': false,
          },
          {
            'text': 'To reduce memory usage during training',
            'isCorrect': false,
          },
          {
            'text': 'To connect different neural networks together',
            'isCorrect': false,
          },
          {
            'text': 'To convert input data into binary format',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the difference between a generative and discriminative model?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'Generative models learn the data distribution while discriminative models learn the boundary between classes',
            'isCorrect': true,
          },
          {
            'text': 'Generative models are always supervised while discriminative models are always unsupervised',
            'isCorrect': false,
          },
          {
            'text': 'Generative models use reinforcement learning while discriminative models use deep learning',
            'isCorrect': false,
          },
          {
            'text': 'Generative models are used only for image generation tasks',
            'isCorrect': false,
          },
          {
            'text': 'Discriminative models always outperform generative models',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the goal of dimensionality reduction in machine learning?',
        'difficulty': 'medium',
        'answers': [
          {
            'text': 'To reduce the number of input features while retaining important information, improving efficiency and preventing overfitting',
            'isCorrect': true,
          },
          {
            'text': 'To increase the complexity of the model to capture more patterns',
            'isCorrect': false,
          },
          {
            'text': 'To expand the dataset with synthetic examples',
            'isCorrect': false,
          },
          {
            'text': 'To convert categorical variables into numerical ones',
            'isCorrect': false,
          },
          {
            'text': 'To increase training speed by using smaller batch sizes',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is the "vanishing gradient problem" in deep learning?',
        'difficulty': 'hard',
        'answers': [
          {
            'text': 'When gradients become extremely small in early layers of deep networks, making training ineffective',
            'isCorrect': true,
          },
          {
            'text': 'When a neural network uses too much memory during training',
            'isCorrect': false,
          },
          {
            'text': 'When the learning rate is set too high causing unstable training',
            'isCorrect': false,
          },
          {
            'text': 'When input data is not properly normalized',
            'isCorrect': false,
          },
          {
            'text': 'When the model has too few parameters to learn effectively',
            'isCorrect': false,
          },
        ],
      },
      {
        'question': 'What is reinforcement learning?',
        'difficulty': 'easy',
        'answers': [
          {
            'text': 'A learning paradigm where an agent learns to make decisions by taking actions in an environment to maximize rewards',
            'isCorrect': true,
          },
          {
            'text': 'Learning that requires human reinforcement at each step',
            'isCorrect': false,
          },
          {
            'text': 'A technique that combines multiple models to improve accuracy',
            'isCorrect': false,
          },
          {
            'text': 'A method that only works with images and video data',
            'isCorrect': false,
          },
          {
            'text': 'A way to automatically label unlabeled datasets',
            'isCorrect': false,
          },
        ],
      },
    ];
  }

}
