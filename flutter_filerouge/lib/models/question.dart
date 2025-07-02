class Question {
  final String id;
  final String questionText;
  final String? correctAnswer; // Peut être null pour les tests
  final int orderInQuiz;

  Question({
    required this.id,
    required this.questionText,
    this.correctAnswer,
    required this.orderInQuiz,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      questionText: json['questionText'] ?? '',
      correctAnswer: json['correctAnswer'], // Peut être null
      orderInQuiz: json['orderInQuiz'] ?? 0,
    );
  }
}
