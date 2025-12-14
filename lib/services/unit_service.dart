import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
import '../models/unit_model.dart';

class UnitService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // GET
  Future<List<Unit>> getUnits() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/units');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true) {
        return (json['data'] as List).map((e) => Unit.fromJson(e)).toList();
      }
    }
    throw Exception('Gagal memuat data satuan');
  }

  // POST
  Future<bool> createUnit(Unit unit) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/units');
    final headers = await _getHeaders();
    final response = await http.post(
      url, 
      headers: headers,
      body: jsonEncode(unit.toJson()),
    );
    return response.statusCode == 200;
  }

  // PUT
  Future<bool> updateUnit(Unit unit) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/units/${unit.id}');
    final headers = await _getHeaders();
    final response = await http.put(
      url, 
      headers: headers,
      body: jsonEncode(unit.toJson()),
    );
    return response.statusCode == 200;
  }

  // DELETE
  Future<bool> deleteUnit(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/units/$id');
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);
    return response.statusCode == 200;
  }
}