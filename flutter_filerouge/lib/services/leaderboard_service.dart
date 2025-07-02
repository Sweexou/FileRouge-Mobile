import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/leaderboard_user.dart';
import 'token_manager.dart';

class LeaderboardService {
  static const String baseUrl = 'https://10.0.2.2:7063';

  static Future<List<LeaderboardUser>> getLeaderboard() async {
    try {
      final token = await TokenManager.getToken();
      
      if (token == null) {
        throw Exception('No token found');
      }

      print('Fetching leaderboard from: $baseUrl/api/leaderboard');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/leaderboard'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        
        return jsonData
            .map((userJson) => LeaderboardUser.fromJson(userJson))
            .toList();
      } else {
        throw Exception('Failed to load leaderboard: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
      throw Exception('Network error: $e');
    }
  }
}
