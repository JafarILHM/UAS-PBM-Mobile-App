import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Android Emulator → 10.0.2.2
  // HP fisik → ganti ke IP laptop (contoh: 192.168.1.10)
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: const {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      }

      if (response.statusCode == 401) {
        return "Email atau password salah";
      }

      return "Login gagal (${response.statusCode})";
    } catch (e) {
      return "Tidak dapat terhubung ke server";
    }
  }

  Future<String?> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
    String role,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: const {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'role': role.toLowerCase(),
        }),
      );

      if (response.statusCode == 201) {
        return null; // sukses
      }

      final body = jsonDecode(response.body);
      if (body['errors'] != null) {
        return body['errors']
            .values
            .expand((e) => e)
            .join('\n');
      }

      return "Registrasi gagal";
    } catch (e) {
      return "Tidak dapat terhubung ke server";
    }
  }
}
