import 'dart:convert';
import 'package:http/http.dart' as http;

class SupplierService {
  final String token;

  // Android Emulator
  final String baseUrl = "http://10.0.2.2:8000/api";

  SupplierService(this.token);

  Map<String, String> get _headers => {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

  Future<List<dynamic>> getSuppliers() async {
    final res = await http.get(
      Uri.parse("$baseUrl/suppliers"),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['data'];
    }

    throw Exception("Gagal mengambil data supplier");
  }

  Future<bool> createSupplier(
    String name,
    String contact,
    String address,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/suppliers"),
      headers: _headers,
      body: jsonEncode({
        "name": name,
        "contact": contact,
        "address": address,
      }),
    );

    return res.statusCode == 201;
  }

  Future<bool> updateSupplier(
    int id,
    String name,
    String contact,
    String address,
  ) async {
    final res = await http.put(
      Uri.parse("$baseUrl/suppliers/$id"),
      headers: _headers,
      body: jsonEncode({
        "name": name,
        "contact": contact,
        "address": address,
      }),
    );

    return res.statusCode == 200;
  }

  Future<bool> deleteSupplier(int id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/suppliers/$id"),
      headers: _headers,
    );

    return res.statusCode == 200;
  }
}
