import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';
import 'token_manager.dart';

class QuizService {
  static const String baseUrl = 'https://10.0.2.2:7063';

  static Future<Map<String, dynamic>> generateQuestions({
    required int level,
    int? type,
    bool isTest = false,
  }) async {
    try {
      final token = await TokenManager.getToken();
      
      if (token == null) {
        throw Exception('No token found');
      }

      String url = '$baseUrl/api/questionnaire/generate?level=$level';
      
      if (type != null) {
        url += '&type=$type';
      }
      
      url += '&test=$isTest';

      print('Fetching questions from: $url');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final questionsData = jsonData['questions'] as List;
        
        final questions = questionsData
            .map((questionJson) => Question.fromJson(questionJson))
            .toList();

        return {
          'questions': questions,
          'questionnaireId': jsonData['id'], // ID du questionnaire pour l'évaluation
        };
      } else {
        throw Exception('Failed to generate questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating questions: $e');
      throw Exception('Network error: $e');
    }
  }
}
