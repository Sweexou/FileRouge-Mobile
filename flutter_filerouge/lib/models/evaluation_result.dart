class EvaluationResult {
  final int score; // Score obtenu (ex: 8)
  final int totalQuestions; // Total des questions (ex: 10)

  EvaluationResult({
    required this.score,
    required this.totalQuestions,
  });

  factory EvaluationResult.fromJson(Map<String, dynamic> json) {
    return EvaluationResult(
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
    );
  }

  // Calculer le pourcentage si nécessaire
  double get percentage => totalQuestions > 0 ? (score / totalQuestions * 100) : 0.0;
}
