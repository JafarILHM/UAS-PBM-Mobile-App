import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
import '../models/item_model.dart';

class ItemService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Item>> getItems() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/items');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true) {
        return (json['data'] as List).map((e) => Item.fromJson(e)).toList();
      }
    }
    throw Exception('Gagal memuat data barang');
  }

  Future<bool> createItem(Item item) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/items');
    final headers = await _getHeaders();
    final response = await http.post(
      url, 
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateItem(Item item) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/items/${item.id}');
    final headers = await _getHeaders();
    final response = await http.put(
      url, 
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteItem(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/items/$id');
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);
    return response.statusCode == 200;
  }
}