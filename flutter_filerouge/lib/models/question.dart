class Question {
  final String id;
  final String questionText;
  final String correctAnswer;
  final int orderInQuiz;

  Question({
    required this.id,
    required this.questionText,
    required this.correctAnswer,
    required this.orderInQuiz,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      questionText: json['questionText'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      orderInQuiz: json['orderInQuiz'] ?? 0,
    );
  }
}
