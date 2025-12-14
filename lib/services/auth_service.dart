import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  // Fungsi Login
  Future<User> login(String email, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/login');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
    
      final userData = data['data']['user'];
      final token = data['data']['token'];
      
      // Kembalikan objek User
      return User.fromJson(userData, token: token);
    } else {
      throw Exception(data['message'] ?? 'Gagal Login');
    }
  }
}