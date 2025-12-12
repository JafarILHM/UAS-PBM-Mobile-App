import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://localhost:8000/api";

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assuming the token is in data['token']
        return data['token'];
      } else {
        // Handle different error status codes if needed
        print("Login failed: ${response.statusCode}");
        print("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  Future<String?> register(String name, String email, String password, String passwordConfirmation, String role) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {
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
        return null; // Success
      } else {
        final errors = jsonDecode(response.body)['errors'];
        String errorMessage = 'Registrasi Gagal. ';
        errors.forEach((key, value) {
          errorMessage += '${value.join(', ')} ';
        });
        return errorMessage;
      }
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }
}
