import 'dart:convert';
import 'package:http/http.dart' as http;

class StockReservationService {
  final String token;
  final String baseUrl = "http://10.0.2.2:8000/api";

  StockReservationService(this.token);

  Map<String, String> get _headers => {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

  // ================= LIST =================
  Future<List<dynamic>> fetchReservations() async {
    final res = await http.get(
      Uri.parse("$baseUrl/stock-reservations"),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['data'];
    }
    throw Exception("Gagal ambil data");
  }

  // ================= CREATE =================
  Future<bool> createReservation({
    required int itemId,
    required int qty,
    String? purpose,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/stock-reservations"),
      headers: _headers,
      body: jsonEncode({
        "item_id": itemId,
        "quantity": qty,
        "purpose": purpose,
      }),
    );

    return res.statusCode == 201;
  }

  // ================= FULFILL =================
  Future<bool> fulfillReservation(int id) async {
    final res = await http.post(
      Uri.parse("$baseUrl/stock-reservations/$id/fulfill"),
      headers: _headers,
    );

    return res.statusCode == 200;
  }

  // ================= DELETE =================
  Future<bool> deleteReservation(int id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/stock-reservations/$id"),
      headers: _headers,
    );

    return res.statusCode == 204;
  }
}
