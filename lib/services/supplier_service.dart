import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
import '../models/supplier_model.dart';

class SupplierService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // GET
  Future<List<Supplier>> getSuppliers() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/suppliers');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true) {
        return (json['data'] as List).map((e) => Supplier.fromJson(e)).toList();
      }
    }
    throw Exception('Gagal memuat data supplier');
  }

  // POST (Create)
  Future<bool> createSupplier(Supplier supplier) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/suppliers');
    final headers = await _getHeaders();
    final response = await http.post(
      url, 
      headers: headers,
      body: jsonEncode(supplier.toJson()),
    );
    return response.statusCode == 200; 
  }

  // PUT (Update)
  Future<bool> updateSupplier(Supplier supplier) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/suppliers/${supplier.id}');
    final headers = await _getHeaders();
    final response = await http.put(
      url, 
      headers: headers,
      body: jsonEncode(supplier.toJson()),
    );
    return response.statusCode == 200;
  }

  // DELETE
  Future<bool> deleteSupplier(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/suppliers/$id');
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);
    return response.statusCode == 200;
  }
}