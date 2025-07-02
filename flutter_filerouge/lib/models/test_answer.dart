class TestAnswer {
  final String questionId;
  final String answer;

  TestAnswer({
    required this.questionId,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'QuestionId': questionId,
      'Answer': answer,
    };
  }
}
