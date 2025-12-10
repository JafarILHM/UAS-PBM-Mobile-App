import 'dart:convert';
import 'package:http/http.dart' as http;

class UnitService {
  final String baseUrl = "http://localhost:8000/api";
  final String token;

  UnitService(this.token);

  Future<List> getUnits() async {
    final res = await http.get(
      Uri.parse("$baseUrl/units"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    final body = jsonDecode(res.body);
    return body['data'] ?? [];
  }

  Future<bool> createUnit(String name, String symbol, bool isBase) async {
    final res = await http.post(
      Uri.parse("$baseUrl/units"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      body: {
        "name": name,
        "symbol": symbol,
        "is_base_unit": isBase ? "1" : "0",
      },
    );

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    return res.statusCode == 201;
  }

  Future<bool> updateUnit(
    int id,
    String name,
    String symbol,
    bool isBase,
  ) async {
    final res = await http.put(
      Uri.parse("$baseUrl/units/$id"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      body: {
        "name": name,
        "symbol": symbol,
        "is_base_unit": isBase ? "1" : "0",
      },
    );

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    return res.statusCode == 200;
  }

  Future<bool> deleteUnit(int id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/units/$id"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
