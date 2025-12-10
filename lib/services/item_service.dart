import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemService {
  final String baseUrl = "http://localhost:8000/api";
  final String token; // token login

  ItemService(this.token);

  // GET items
  Future<List<dynamic>> getItems() async {
    final response = await http.get(
      Uri.parse("$baseUrl/items"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']; // karena backend pakai paginate
    } else {
      throw Exception("Failed to load items");
    }
  }

  // GET item detail
  Future<Map<String, dynamic>> getItemDetail(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/items/$id"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    return jsonDecode(response.body);
  }

  // UPDATE item
  Future<bool> updateItem(int id, Map body) async {
    final response = await http.put(
      Uri.parse("$baseUrl/items/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  Future<List<dynamic>> getDropdown(String type) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$type"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    final body = jsonDecode(response.body);

    // API kamu pasti formatnya { "data": [...] }
    return body['data'] ?? [];
  }

  Future<bool> deleteItem(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/items/$id"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
