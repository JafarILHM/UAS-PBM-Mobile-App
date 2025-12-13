import 'dart:convert';
import 'package:http/http.dart' as http;

class UnitService {
  final String token;

  // Android Emulator
  final String baseUrl = "http://10.0.2.2:8000/api";

  UnitService(this.token);

  Map<String, String> get _headers => {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

  // GET units
  Future<List<dynamic>> getUnits() async {
    final res = await http.get(
      Uri.parse("$baseUrl/units"),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return body['data'] ?? [];
    }

    throw Exception("Gagal mengambil data satuan");
  }

  // CREATE unit
  Future<bool> createUnit(String name, String symbol, bool isBase) async {
    final res = await http.post(
      Uri.parse("$baseUrl/units"),
      headers: _headers,
      body: jsonEncode({
        "name": name,
        "symbol": symbol,
        "is_base_unit": isBase ? 1 : 0,
      }),
    );

    return res.statusCode == 201 || res.statusCode == 200;
  }

  // UPDATE unit
  Future<bool> updateUnit(
    int id,
    String name,
    String symbol,
    bool isBase,
  ) async {
    final res = await http.put(
      Uri.parse("$baseUrl/units/$id"),
      headers: _headers,
      body: jsonEncode({
        "name": name,
        "symbol": symbol,
        "is_base_unit": isBase ? 1 : 0,
      }),
    );

    return res.statusCode == 200;
  }

  // DELETE unit
  Future<bool> deleteUnit(int id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/units/$id"),
      headers: _headers,
    );

    return res.statusCode == 200 || res.statusCode == 204;
  }
}
