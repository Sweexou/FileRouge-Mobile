import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';
import 'token_manager.dart';

class QuizService {
  static const String baseUrl = 'https://10.0.2.2:7063';

  static Future<List<Question>> generateQuestions({
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
        
        return questionsData
            .map((questionJson) => Question.fromJson(questionJson))
            .toList();
      } else {
        throw Exception('Failed to generate questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating questions: $e');
      throw Exception('Network error: $e');
    }
  }
}
