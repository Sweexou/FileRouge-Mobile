import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';
import 'token_manager.dart';

class AuthService {
  static const String baseUrl = 'https://10.0.2.2:7063';
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Attempting login to: $baseUrl/api/Auth/login');
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/Auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Identifier': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
        
        // Sauvegarder le token automatiquement
        await TokenManager.saveToken(loginResponse.token);
        
        return {
          'success': true,
          'data': loginResponse,
          'token': loginResponse.token,
        };
      } else {
        return {
          'success': false,
          'error': 'Login failed: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  static Future<void> logout() async {
    await TokenManager.removeToken();
  }
}
