import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  Future<User> login(String email, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return User.fromJson(data['data']['user'], token: data['data']['token']);
    } else {
      throw Exception(data['message'] ?? 'Gagal Login');
    }
  }

  Future<User> updateProfile(
    String name,
    String email,
    String? password,
  ) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/profile/update');

    // Ambil token dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final body = {'name': name, 'email': email};

    // Password hanya dikirim jika diisi
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      // API mengembalikan data user terbaru
      // Kita perlu menyisipkan token lama karena API update profile tidak return token baru
      return User.fromJson(data['data'], token: token);
    } else {
      throw Exception(data['message'] ?? 'Gagal update profil');
    }
  }
}
