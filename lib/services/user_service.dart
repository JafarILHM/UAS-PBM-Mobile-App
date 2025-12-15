import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
import '../models/user_model.dart';

class UserService {
  // Helper untuk mengambil token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // 1. Ambil Semua User
  Future<List<User>> getUsers() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      if (json['success'] == true) {
        final List data = json['data'];
        return data.map((e) => User.fromJson(e)).toList();
      }
    }
    throw Exception('Gagal mengambil data user: ${response.body}');
  }

  // 2. Tambah User Baru
  Future<bool> addUser(String name, String email, String password, String role) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users');
    final headers = await _getHeaders();
    
    final body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final json = jsonDecode(response.body);
      throw Exception(json['message'] ?? 'Gagal menambah user');
    }
  }

  // 3. Update User
  Future<bool> updateUser(int id, String name, String email, String? password, String role) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users/$id');
    final headers = await _getHeaders();

    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'role': role,
    };

    if (password != null && password.isNotEmpty) {
      data['password'] = password;
    }

    final response = await http.put(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      return true;
    } else {
      final json = jsonDecode(response.body);
      throw Exception(json['message'] ?? 'Gagal update user');
    }
  }

  // 4. Hapus User
  Future<bool> deleteUser(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users/$id');
    final headers = await _getHeaders();

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      final json = jsonDecode(response.body);
      throw Exception(json['message'] ?? 'Gagal menghapus user');
    }
  }
}