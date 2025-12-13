import 'dart:convert';
import 'package:http/http.dart' as http;

class StockService {
  final String token;
  final String baseUrl = "http://10.0.2.2:8000/api";

  StockService(this.token);

  Map<String, String> get _headers => {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

  // =========================
  // LIST ITEM (DROPDOWN)
  // =========================
  Future<List<dynamic>> fetchItems() async {
    final res = await http.get(
      Uri.parse("$baseUrl/items"),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['data'];
    }
    throw Exception("Gagal ambil item");
  }

  // =========================
  // REALTIME STOCK
  // =========================
  Future<int> fetchStock(int itemId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/items/$itemId"),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['stock'];
    }
    throw Exception("Gagal ambil stok");
  }

  // =========================
  // BARANG MASUK
  // =========================
  Future<bool> barangMasuk({
    required String itemIdentifier, // SKU / BARCODE
    required String batchNumber,
    required int qty,
    String? productionDate,
    String? expiryDate,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/items/incoming"),
      headers: _headers,
      body: jsonEncode({
        "item_identifier": itemIdentifier,
        "batch_number": batchNumber,
        "qty": qty,
        "production_date": productionDate,
        "expiry_date": expiryDate,
      }),
    );

    return res.statusCode == 200;
  }

  // =========================
  // BARANG KELUAR (RESERVASI)
  // =========================
  Future<bool> barangKeluar({
    required String itemIdentifier,
    required int itemBatchId,
    required int qty,
    String? purpose,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/items/outgoing"),
      headers: _headers,
      body: jsonEncode({
        "item_identifier": itemIdentifier,
        "item_batch_id": itemBatchId,
        "qty": qty,
        "purpose": purpose,
      }),
    );

    return res.statusCode == 200;
  }

  // =========================
  // LIST TRANSAKSI GUDANG
  // =========================
  Future<List<dynamic>> fetchTransaksiGudang() async {
    final res = await http.get(
      Uri.parse("$baseUrl/stock-reservations"),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['data'];
    }
    throw Exception("Gagal ambil transaksi");
  }

  // =========================
  // FULFILL BARANG KELUAR
  // =========================
  Future<bool> fulfillBarangKeluar(int id) async {
    final res = await http.post(
      Uri.parse("$baseUrl/stock-reservations/$id/fulfill"),
      headers: _headers,
    );

    return res.statusCode == 200;
  }

  // =========================
  // DELETE TRANSAKSI
  // =========================
  Future<bool> deleteTransaksi(int id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/stock-reservations/$id"),
      headers: _headers,
    );

    return res.statusCode == 204;
  }

  // =========================
  // CREATE ITEM
  // =========================
  Future<bool> createItem({
    required String sku,
    required String name,
    int? stockMinimum,
    int? supplierId,
    int? categoryId,
    int? unitId,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/items"),
      headers: _headers,
      body: jsonEncode({
        "sku": sku,
        "name": name,
        "stock_minimum": stockMinimum,
        "supplier_id": supplierId,
        "category_id": categoryId,
        "unit_id": unitId,
      }),
    );

    return res.statusCode == 201;
  }

  // =========================
  // SCAN BARCODE / QR
  // =========================
  Future<Map<String, dynamic>> scanItem(String code) async {
    final res = await http.get(
      Uri.parse("$baseUrl/items/scan/$code"),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Item tidak ditemukan");
  }
}
