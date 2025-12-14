import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';

class TransactionService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // POST: Barang Masuk
  Future<bool> createIncoming(Map<String, dynamic> data) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/incoming');
    final headers = await _getHeaders();
    
    final response = await http.post(
      url, 
      headers: headers,
      body: jsonEncode(data),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // POST: Barang Keluar
  Future<bool> createOutgoing(Map<String, dynamic> data) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/outgoing');
    final headers = await _getHeaders();
    
    final response = await http.post(
      url, 
      headers: headers,
      body: jsonEncode(data),
    );

    // Jika stok tidak cukup
    if (response.statusCode == 400) {
      final json = jsonDecode(response.body);
      throw Exception(json['message'] ?? "Stok tidak cukup");
    }

    return response.statusCode == 200 || response.statusCode == 201;
  }
}