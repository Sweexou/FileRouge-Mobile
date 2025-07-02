import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String baseUrl = 'https://10.0.2.2:7063';
  
  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      print('Attempting register to: $baseUrl/api/Auth/register');
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/Auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Registration failed: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Register error: $e');
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
}
