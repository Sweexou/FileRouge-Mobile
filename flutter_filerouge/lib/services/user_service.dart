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
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return User.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        await TokenManager.removeToken();
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateEmail(String newEmail) async {
    try {
      final token = await TokenManager.getToken();
      
      if (token == null) {
        throw Exception('No token found');
      }
      
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Vérifiez le format
        },
        body: jsonEncode({
          'email': newEmail,
        }),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateUsername(String newUsername) async {
    try {
      final token = await TokenManager.getToken();
      
      if (token == null) {
        throw Exception('No token found');
      }
      
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'username': newUsername,
        }),
      ).timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updatePassword(String currentPassword, String newPassword) async {
    try {
      final token = await TokenManager.getToken();
      
      if (token == null) {
        throw Exception('No token found');
      }

      print('Updating password');
      
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
