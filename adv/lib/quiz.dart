import 'package:adv/data/questions.dart';
import 'package:adv/questions_screen.dart';
import 'package:adv/results_screen.dart';
import 'package:adv/start_screen.dart';
import 'package:adv/time_widget.dart';
import 'package:flutter/material.dart';

/// The main Quiz widget that is taken in by the main method, manages the state and navigation of the quiz app.
class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  /// Stores the user's selected answeres
  List<String> _selectedAnswers = [];

  /// Controls which screen is currently active ('start-screen', 'questions-screen', 'results-screen').
  var _activeScreen = 'start-screen';

  /// Stores the total duration of the quiz
  Duration _quizDuration = const Duration(); // Store the duration of the quiz

  /// Callback function to switch from the start screen to the questions screen.
  void _switchScreen() {
    setState(() {
      _activeScreen = 'questions-screen';
    });
  }

  void _chooseAnswer(String answer) {
    _selectedAnswers.add(answer);

    if (_selectedAnswers.length == questions.length) {
      setState(() {
        _activeScreen = 'results-screen';
      });
    }
  }

  /// Restarts the quiz by resetting selected answers, quiz duration, and navigating back to the questions screen.
  void restartQuiz() {
    setState(() {
      _selectedAnswers = [];
      _quizDuration =
          const Duration(); // Reset the duration when restarting the quiz
      _activeScreen = 'questions-screen';
    });
  }

  /// handles time ticks from TiterWidget.
  /// Updates quizDuration with the current dratuon recived from timerWidget.
  void _handleTimerTick(Duration duration) {
    _quizDuration = duration; // Update the quiz duration on each tick
  }

  @override
  Widget build(BuildContext context) {
    // By default, display the Start screen.
    Widget screenWidget = StartScreen(_switchScreen);

    // If the active screen is the Questions screen, display QuestionsScreen and TimerWidget.
    if (_activeScreen == 'questions-screen') {
      screenWidget = Stack(
        children: [
          QuestionsScreen(
            onSelectAnswer: _chooseAnswer,
          ),
          TimerWidget(
            onTimerTick: _handleTimerTick, // Pass the callback to TimerWidget
          ),
        ],
      );
    }

    // If the active screen is the Results screen, display ResultsScreen with the quiz summary.
    if (_activeScreen == 'results-screen') {
      final numTotalQuestions = questions.length;
      final numCorrectQuestions = _selectedAnswers
          .where((answer) =>
              questions[_selectedAnswers.indexOf(answer)].answers[0] == answer)
          .length;

      // Create the ResultsScreen with the necessary data.
      screenWidget = ResultsScreen(
        chosenAnswers: _selectedAnswers,
        onRestart: restartQuiz,
        quizDuration: _quizDuration, // Pass the duration to ResultsScreen
        numCorrect: numCorrectQuestions, // Pass the correct answers count
        numTotal: numTotalQuestions, // Pass the total questions count
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 13, 151),
                Color.fromARGB(255, 107, 15, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
