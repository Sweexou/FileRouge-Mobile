import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/test_answer.dart';
import '../models/evaluation_result.dart';
import 'token_manager.dart';

class EvaluationService {
  static const String baseUrl = 'https://10.0.2.2:7063';

  static Future<EvaluationResult> evaluateTest({
    required String questionnaireId,
    required List<TestAnswer> answers,
  }) async {
    try {
      final token = await TokenManager.getToken();
      
      if (token == null) {
        throw Exception('No token found');
      }

      print('Evaluating test: $baseUrl/api/questionnaire/evaluate');
      
      final requestBody = {
        'QuestionnaireId': questionnaireId,
        'Answers': answers.map((answer) => answer.toJson()).toList(),
      };

      print('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/api/questionnaire/evaluate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 15));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        
        // Adapter selon la structure de réponse de votre API
        return EvaluationResult(
          score: jsonData['score'] ?? 0,
          totalQuestions: answers.length, // Utiliser le nombre de questions envoyées
        );
      } else {
        throw Exception('Failed to evaluate test: ${response.statusCode}');
      }
    } catch (e) {
      print('Error evaluating test: $e');
      throw Exception('Network error: $e');
    }
  }
}
