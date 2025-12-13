import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = "http://localhost:8000/api";
  final String token;

  CategoryService(this.token);

  // GET categories
  Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse("$baseUrl/categories"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'] ?? [];
    } else {
      throw Exception("Failed to load categories");
    }
  }

  // CREATE category
  Future<bool> createCategory(String name) async {
    final response = await http.post(
      Uri.parse("$baseUrl/categories"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"name": name}),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }

  // UPDATE category
  Future<bool> updateCategory(int id, String name) async {
    final response = await http.put(
      Uri.parse("$baseUrl/categories/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"name": name}),
    );

    return response.statusCode == 200;
  }

  // DELETE category
  Future<bool> deleteCategory(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/categories/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
