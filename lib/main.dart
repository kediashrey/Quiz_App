import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(QuizApp());
}

// Global quiz storage
class QuizStorage {
  static List<Quiz> _quizzes = [];
  static int _nextId = 1;

  static List<Quiz> get quizzes => _quizzes;

  static void addQuiz(Quiz quiz) {
    quiz.id = _nextId++;
    _quizzes.add(quiz);
  }

  static Quiz? getQuizById(int id) {
    try {
      return _quizzes.firstWhere((quiz) => quiz.id == id);
    } catch (e) {
      return null;
    }
  }

  static void clearQuizzes() {
    _quizzes.clear();
    _nextId = 1;
  }
}

// Data Models
class Quiz {
  int id;
  String title;
  String description;
  int duration; // in minutes
  List<QuizQuestion> questions;
  DateTime createdAt;

  Quiz({
    this.id = 0,
    required this.title,
    required this.description,
    required this.duration,
    required this.questions,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class QuizQuestion {
  String question;
  List<String> options;
  List<int> correctAnswers; // indices of correct options
  int points;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswers,
    this.points = 1,
  });
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'SF Pro Display',
      ),
      home: SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB8E6B8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.quiz,
                size: 60,
                color: Color(0xFFB8E6B8),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Quiz App',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Home Screen with Bottom Navigation
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      DashboardTab(),
      ProfileTab(),
      QuizListTab(),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quizzes'),
        ],
      ),
    );
  }
}

// Dashboard Tab
class DashboardTab extends StatefulWidget {
  @override
  _DashboardTabState createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello Student!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text('Ready for a quiz?', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: Icon(Icons.person, color: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Daily Quiz Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.yellow[300]!, Colors.yellow[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text(
                        'Daily Quiz',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Join a quiz',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JoinQuizScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Play', style: TextStyle(color: Colors.yellow[600])),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Create Quiz',
                    Icons.add_circle,
                    Colors.green,
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateQuizScreen()),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: _buildActionCard(
                    'Join Quiz',
                    Icons.group,
                    Colors.blue,
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JoinQuizScreen()),
                    ),
                  ),
                ),
              ],
            ),

            // Recent Quizzes Section
            if (QuizStorage.quizzes.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                'My Recent Quizzes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: QuizStorage.quizzes.take(3).length,
                  itemBuilder: (context, index) {
                    final quiz = QuizStorage.quizzes.reversed.toList()[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${quiz.questions.length} Questions • ${quiz.duration} minutes',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Quiz ID: ${quiz.id}',
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TakeQuizScreen(quiz: quiz),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  minimumSize: Size(80, 30),
                                ),
                                child: Text(
                                  'Start',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// Profile Tab
class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green[100],
              child: Icon(Icons.person, size: 50, color: Colors.green),
            ),
            SizedBox(height: 20),
            Text(
              'Student Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'student@example.com',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 30),
            _buildProfileOption('My Quizzes (${QuizStorage.quizzes.length})', Icons.quiz),
            _buildProfileOption('Achievements', Icons.star),
            _buildProfileOption('Settings', Icons.settings),
            _buildProfileOption('Help', Icons.help),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          SizedBox(width: 15),
          Text(title, style: TextStyle(fontSize: 16)),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}

// Quiz List Tab
class QuizListTab extends StatefulWidget {
  @override
  _QuizListTabState createState() => _QuizListTabState();
}

class _QuizListTabState extends State<QuizListTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Quizzes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (QuizStorage.quizzes.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.quiz, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'No quizzes created yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateQuizScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: Text(
                          'Create Your First Quiz',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: QuizStorage.quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = QuizStorage.quizzes.reversed.toList()[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  quiz.title,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'ID: ${quiz.id}',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (quiz.description.isNotEmpty) ...[
                            SizedBox(height: 5),
                            Text(
                              quiz.description,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                          SizedBox(height: 5),
                          Text(
                            '${quiz.questions.length} Questions • ${quiz.duration} minutes',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TakeQuizScreen(quiz: quiz),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: Text('Start Quiz', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Join Quiz Screen
class JoinQuizScreen extends StatefulWidget {
  @override
  _JoinQuizScreenState createState() => _JoinQuizScreenState();
}

class _JoinQuizScreenState extends State<JoinQuizScreen> {
  final TextEditingController _quizIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE1BEE7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Enter Your Quiz ID', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.quiz, size: 100, color: Colors.purple),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _quizIdController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Quiz ID',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info, color: Colors.white, size: 16),
                SizedBox(width: 5),
                Text('Enter the Quiz ID to join', style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  if (_quizIdController.text.isNotEmpty) {
                    try {
                      int quizId = int.parse(_quizIdController.text);
                      Quiz? quiz = QuizStorage.getQuizById(quizId);
                      if (quiz != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TakeQuizScreen(quiz: quiz),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Quiz with ID $quizId not found!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a valid quiz ID!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            if (QuizStorage.quizzes.isNotEmpty) ...[
              SizedBox(height: 30),
              Text(
                'Available Quiz IDs:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                constraints: BoxConstraints(maxHeight: 150),
                child: SingleChildScrollView(
                  child: Column(
                    children: QuizStorage.quizzes.map((quiz) =>
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ID: ${quiz.id}',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  quiz.title,
                                  style: TextStyle(color: Colors.white70),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                    ).toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Create Quiz Screen
class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _numberOfQuestions = 5;
  int _duration = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB8E6B8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.quiz, color: Colors.green, size: 30),
                      SizedBox(width: 10),
                      Text(
                        'Quiz Title',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter quiz title...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter quiz description...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No of Questions: $_numberOfQuestions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _numberOfQuestions.toDouble(),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _numberOfQuestions = value.round();
                      });
                    },
                  ),
                  Text(
                    'Quiz Duration: $_duration minutes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _duration.toDouble(),
                    min: 1,
                    max: 60,
                    divisions: 59,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _duration = value.round();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a quiz title!')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionCreatorScreen(
                      quizTitle: _titleController.text.trim(),
                      quizDescription: _descriptionController.text.trim(),
                      totalQuestions: _numberOfQuestions,
                      duration: _duration,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Add Questions', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// Question Creator Screen
class QuestionCreatorScreen extends StatefulWidget {
  final String quizTitle;
  final String quizDescription;
  final int totalQuestions;
  final int duration;

  QuestionCreatorScreen({
    required this.quizTitle,
    required this.quizDescription,
    required this.totalQuestions,
    required this.duration,
  });

  @override
  _QuestionCreatorScreenState createState() => _QuestionCreatorScreenState();
}

class _QuestionCreatorScreenState extends State<QuestionCreatorScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<bool> selectedOptions = [false, false, false, false];
  int maxPoints = 2;
  int currentQuestion = 1;
  List<QuizQuestion> questions = [];

  @override
  void initState() {
    super.initState();
    // Initialize option controllers with placeholder text
    for (int i = 0; i < 4; i++) {
      _optionControllers[i].text = 'Option ${String.fromCharCode(65 + i)}';
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveQuestion() {
    if (_questionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a question!')),
      );
      return;
    }

    if (_optionControllers.any((controller) => controller.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all options!')),
      );
      return;
    }

    if (!selectedOptions.any((selected) => selected)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one correct answer!')),
      );
      return;
    }

    // Create question
    List<int> correctAnswers = [];
    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i]) {
        correctAnswers.add(i);
      }
    }

    QuizQuestion question = QuizQuestion(
      question: _questionController.text.trim(),
      options: _optionControllers.map((controller) => controller.text.trim()).toList(),
      correctAnswers: correctAnswers,
      points: maxPoints,
    );

    // Save question to list
    if (questions.length >= currentQuestion - 1) {
      if (questions.length == currentQuestion - 1) {
        questions.add(question);
      } else {
        questions[currentQuestion - 1] = question;
      }
    } else {
      questions.add(question);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Question ${currentQuestion} saved!')),
    );

    // Move to next question if available
    if (currentQuestion < widget.totalQuestions) {
      setState(() {
        currentQuestion++;
        _questionController.clear();
        for (int i = 0; i < 4; i++) {
          _optionControllers[i].text = 'Option ${String.fromCharCode(65 + i)}';
        }
        selectedOptions = [false, false, false, false];
        maxPoints = 2;
      });
    }
  }

  void _publishQuiz() {
    if (questions.length < widget.totalQuestions) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all ${widget.totalQuestions} questions before publishing!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Quiz newQuiz = Quiz(
      title: widget.quizTitle,
      description: widget.quizDescription,
      duration: widget.duration,
      questions: List.from(questions),
    );

    QuizStorage.addQuiz(newQuiz);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Published!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quiz "${widget.quizTitle}" has been published successfully!'),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.green[700]),
                    SizedBox(width: 8),
                    Text(
                      'Quiz ID: ${newQuiz.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Share this ID with others to let them take your quiz!',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to create quiz
                Navigator.of(context).pop(); // Go back to home
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.grey[600]),
          onPressed: () {},
        ),
        title: Text('Question ${currentQuestion} of ${widget.totalQuestions}'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Back', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.help_outline, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _questionController,
                      decoration: InputDecoration(
                        hintText: 'Enter your question here...',
                        hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Options Section
            Text(
              'Options (Select correct answers):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            SizedBox(height: 12),

            ...List.generate(4, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    // Correct answer selector
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOptions[index] = !selectedOptions[index];
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedOptions[index] ? Colors.green[400] : Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedOptions[index] ? Colors.green[600]! : Colors.green[300]!,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: selectedOptions[index]
                              ? Icon(Icons.check, color: Colors.white, size: 20)
                              : Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: TextStyle(
                              color: Colors.green[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Option text field
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedOptions[index] ? Colors.green[50] : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedOptions[index] ? Colors.green[300]! : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _optionControllers[index],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter option ${String.fromCharCode(65 + index)}...',
                          ),
                          style: TextStyle(
                            color: selectedOptions[index] ? Colors.green[700] : Colors.black,
                            fontWeight: selectedOptions[index] ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: 24),

            // Points Slider Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Points for this question: $maxPoints',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.green[400],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            '$maxPoints',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: maxPoints.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          activeColor: Colors.green[400],
                          inactiveColor: Colors.green[200],
                          onChanged: (value) {
                            setState(() {
                              maxPoints = value.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      currentQuestion < widget.totalQuestions ? 'Save & Next Question' : 'Save Question',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _publishQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[500],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Publish Quiz (${questions.length}/${widget.totalQuestions} questions)',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Take Quiz Screen
class TakeQuizScreen extends StatefulWidget {
  final Quiz quiz;

  TakeQuizScreen({required this.quiz});

  @override
  _TakeQuizScreenState createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  int currentQuestion = 0;
  List<int> selectedAnswers = [];
  int score = 0;
  int timeLeft = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timeLeft = widget.quiz.duration * 60; // Convert minutes to seconds
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        _finishQuiz();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _toggleAnswer(int optionIndex) {
    setState(() {
      if (selectedAnswers.contains(optionIndex)) {
        selectedAnswers.remove(optionIndex);
      } else {
        selectedAnswers.add(optionIndex);
      }
    });
  }

  void _nextQuestion() {
    if (selectedAnswers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one answer!')),
      );
      return;
    }

    // Calculate score for current question
    QuizQuestion question = widget.quiz.questions[currentQuestion];
    bool isCorrect = _checkAnswer(selectedAnswers, question.correctAnswers);

    if (isCorrect) {
      score += question.points;
    }

    if (currentQuestion < widget.quiz.questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswers.clear();
      });
    } else {
      _finishQuiz();
    }
  }

  bool _checkAnswer(List<int> selected, List<int> correct) {
    if (selected.length != correct.length) return false;
    for (int answer in selected) {
      if (!correct.contains(answer)) return false;
    }
    return true;
  }

  void _finishQuiz() {
    timer.cancel();
    int totalPts = widget.quiz.questions.fold(0, (sum, q) => sum + q.points);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          score: score,
          totalQuestions: widget.quiz.questions.length,
          totalPoints: totalPts,
          quizTitle: widget.quiz.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[currentQuestion];

    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Exit Quiz?'),
                content: Text('Are you sure you want to exit? Your progress will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Exit', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
        title: Text('${widget.quiz.title}', style: TextStyle(color: Colors.black)),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: timeLeft < 60 ? Colors.red : Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              formatTime(timeLeft),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (currentQuestion + 1) / widget.quiz.questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 10),
            Text(
              'Question ${currentQuestion + 1} of ${widget.quiz.questions.length}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 30),

            // Question Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.help_outline, size: 40, color: Colors.blue),
                  SizedBox(height: 15),
                  Text(
                    question.question,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Answer Options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedAnswers.contains(index);
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: () => _toggleAnswer(index),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[100] : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey[300]!,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Colors.blue : Colors.grey[300],
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isSelected ? Colors.blue[700] : Colors.black,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  currentQuestion < widget.quiz.questions.length - 1 ? 'NEXT' : 'FINISH',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Quiz Result Screen
class QuizResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int totalPoints;
  final String quizTitle;

  QuizResultScreen({
    required this.score,
    required this.totalQuestions,
    required this.totalPoints,
    required this.quizTitle,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (score / totalPoints) * 100;
    String grade = _getGrade(percentage);
    Color gradeColor = _getGradeColor(percentage);

    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Quiz Results', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Result Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Trophy Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: gradeColor.withOpacity(0.2),
                    ),
                    child: Icon(
                      percentage >= 80 ? Icons.emoji_events :
                      percentage >= 60 ? Icons.star : Icons.thumb_up,
                      size: 50,
                      color: gradeColor,
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Quiz Completed!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    quizTitle,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),

                  Text(
                    'Your Score',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 5),

                  Text(
                    '$score / $totalPoints',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: gradeColor,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: gradeColor,
                    ),
                  ),
                  SizedBox(height: 15),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: gradeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Grade: $grade',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: gradeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Statistics
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Questions', totalQuestions.toString(), Icons.quiz),
                  _buildStatItem('Correct', _getCorrectAnswers().toString(), Icons.check),
                  _buildStatItem('Wrong', _getWrongAnswers().toString(), Icons.close),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Back to Home',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                            (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Take Another Quiz',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600], size: 30),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  String _getGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  Color _getGradeColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  int _getCorrectAnswers() {
    // Estimate based on score percentage
    return ((score / totalPoints) * totalQuestions).round();
  }

  int _getWrongAnswers() {
    return totalQuestions - _getCorrectAnswers();
  }
}