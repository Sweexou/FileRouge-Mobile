import 'question.dart';


class QuizResult {
  final Question question;
  final String userAnswer;
  final bool isCorrect;

  QuizResult({
    required this.question,
    required this.userAnswer,
    required this.isCorrect,
  });
}
