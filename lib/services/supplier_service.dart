import 'package:http/http.dart' as http;
import 'dart:convert';

class SupplierService {
  final String token;
  final String baseUrl = "http://localhost:8000/api";

  SupplierService(this.token);

  Future<List> getSuppliers() async {
    final res = await http.get(
      Uri.parse("$baseUrl/suppliers"),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(res.body)['data'];
  }

  Future<bool> createSupplier(
    String name,
    String contact,
    String address,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/suppliers"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"name": name, "contact": contact, "address": address}),
    );

    print("CREATE STATUS: ${res.statusCode}");
    print("CREATE BODY: ${res.body}");

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
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"name": name, "contact": contact, "address": address}),
    );

    print("UPDATE STATUS: ${res.statusCode}");
    print("UPDATE BODY: ${res.body}");

    return res.statusCode == 200;
  }

  Future<bool> deleteSupplier(int id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/suppliers/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    return res.statusCode == 200;
  }
}
