import 'package:adv/data/questions.dart';
import 'package:adv/questions_summary/questions_summary.dart';
import 'package:flutter/material.dart'; // to count the time
import 'package:google_fonts/google_fonts.dart';

/// A screen that displays the results of the quiz, including the score and time taken.
class ResultsScreen extends StatelessWidget {
  /// Creates a ResultsScreen.
  const ResultsScreen({
    super.key,
    required this.chosenAnswers,
    required this.onRestart,
    required this.quizDuration, // Parameter for quiz duration
    required this.numCorrect,
    required this.numTotal,
  });

  /// Callback function to restart the quiz.
  final void Function() onRestart;
  final List<String> chosenAnswers;

  /// The total duration of the quiz.
  final Duration quizDuration;
  final int numCorrect; // Correct answers count
  final int numTotal; // Total questions count

  /// Generates a summary of the questions, correct answers, and user answers.
  List<Map<String, Object>> get summaryData {
    final List<Map<String, Object>> summary = [];
    for (var i = 0; i < chosenAnswers.length; i++) {
      summary.add(
        {
          'question_index': i,
          'question': questions[i].text,
          'correct_answer': questions[i].answers[0],
          'user_answer': chosenAnswers[i]
        },
      );
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the user's score.
            Text(
              'You answered $numCorrect out of $numTotal questions correctly!',
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Display the total time spent on the quiz.
            Text(
              'Time spent: ${quizDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(quizDuration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 42, 161, 235),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            QuestionsSummary(summaryData),
            const SizedBox(height: 30),

            // Button to restart the quiz.
            TextButton.icon(
              onPressed: onRestart,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Quiz!'),
            ),
          ],
        ),
      ),
    );
  }
}
