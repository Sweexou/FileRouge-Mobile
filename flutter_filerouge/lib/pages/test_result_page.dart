import 'package:flutter/material.dart';
import '../models/evaluation_result.dart';

class TestResultPage extends StatelessWidget {
  final EvaluationResult evaluationResult;
  final String exerciseTitle;

  const TestResultPage({
    Key? key,
    required this.evaluationResult,
    required this.exerciseTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final score = evaluationResult.score;
    final totalQuestions = evaluationResult.totalQuestions;
    final percentage = evaluationResult.percentage.round();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Test Results',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            
            // Score section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFF7FDFB8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF7FDFB8),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 60,
                    color: Color(0xFF7FDFB8),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Test Completed!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Affichage du score comme fraction
                  Text(
                    '$score/$totalQuestions',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7FDFB8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Affichage du pourcentage en plus petit
                  Text(
                    '($percentage%)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Performance message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getPerformanceMessage(percentage),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Back button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7FDFB8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPerformanceMessage(int percentage) {
    if (percentage >= 90) {
      return 'Excellent! You have mastered this topic.';
    } else if (percentage >= 70) {
      return 'Good job! You have a solid understanding.';
    } else if (percentage >= 50) {
      return 'Not bad! Keep practicing to improve.';
    } else {
      return 'Keep studying! Practice makes perfect.';
    }
  }
}
