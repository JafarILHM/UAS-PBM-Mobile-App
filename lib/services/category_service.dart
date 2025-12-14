import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
import '../models/category_model.dart';

class CategoryService {
  // Helper untuk mengambil token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // GET: Ambil Semua Kategori
  Future<List<Category>> getCategories() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/categories');
    final headers = await _getHeaders();
    
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true) {
        final List data = json['data'];
        return data.map((e) => Category.fromJson(e)).toList();
      }
    }
    throw Exception('Gagal mengambil data kategori');
  }

  // POST: Tambah Kategori
  Future<bool> createCategory(String name) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/categories');
    final headers = await _getHeaders();
    
    final response = await http.post(
      url, 
      headers: headers,
      body: jsonEncode({'name': name}),
    );

    return response.statusCode == 200;
  }

  // PUT: Update Kategori
  Future<bool> updateCategory(int id, String name) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/categories/$id');
    final headers = await _getHeaders();
    
    final response = await http.put(
      url, 
      headers: headers,
      body: jsonEncode({'name': name}),
    );

    return response.statusCode == 200;
  }

  // DELETE: Hapus Kategori
  Future<bool> deleteCategory(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/categories/$id');
    final headers = await _getHeaders();
    
    final response = await http.delete(url, headers: headers);

    return response.statusCode == 200;
  }
}