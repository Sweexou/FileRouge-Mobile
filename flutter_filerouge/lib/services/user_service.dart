import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'token_manager.dart';

class UserService {
  static const String baseUrl = 'https://10.0.2.2:7063';

  static Future<User?> getCurrentUser() async {
    try {
      final token = await TokenManager.getToken();
      
      if (token == null) {
        print('No token found');
        return null;
      }

      print('Fetching user data from: $baseUrl/api/user/me');
      print('Using token: ${token.substring(0, 20)}...'); // Log partiel du token
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return User.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        print('Token expired or invalid, removing token');
        await TokenManager.removeToken();
        return null;
      } else {
        print('Failed to load user data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
