import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemService {
  final String token;

  // Android Emulator
  final String baseUrl = "http://10.0.2.2:8000/api";

  ItemService(this.token);

  Map<String, String> get _headers => {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

  // GET items
  Future<List<dynamic>> getItems() async {
    final response = await http.get(
      Uri.parse("$baseUrl/items"),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'] ?? [];
    }

    throw Exception("Gagal mengambil data item");
  }

  // GET item detail
  Future<Map<String, dynamic>> getItemDetail(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/items/$id"),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }

    throw Exception("Gagal mengambil detail item");
  }

  // UPDATE item
  Future<bool> updateItem(int id, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl/items/$id"),
      headers: _headers,
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  // Dropdown helper (categories, units, suppliers)
  Future<List<dynamic>> getDropdown(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$endpoint"),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'] ?? [];
    }

    return [];
  }

  // DELETE item
  Future<bool> deleteItem(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/items/$id"),
      headers: _headers,
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
