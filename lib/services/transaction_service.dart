import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
import '../models/transaction_model.dart';

class TransactionService {
  Future<List<Transaction>> getAllTransactions() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/transactions');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final List<dynamic> transactionData = data['data'];
      return transactionData
          .map((tx) => Transaction.fromMap(tx, tx['type']))
          .toList();
    } else {
      throw Exception(data['message'] ?? 'Gagal memuat data transaksi');
    }
  }

  Future<void> addIncoming(
    int itemId,
    int supplierId,
    int qty,
    String dateIn,
  ) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/incoming');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'item_id': itemId,
        'supplier_id': supplierId,
        'qty': qty,
        'date_in': dateIn,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return;
    } else {
      throw Exception(data['message'] ?? 'Gagal menyimpan barang masuk');
    }
  }

  Future<void> addOutgoing(
    int itemId,
    int qty,
    String dateOut,
    String? purpose,
  ) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/outgoing');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'item_id': itemId,
        'qty': qty,
        'date_out': dateOut,
        'purpose': purpose ?? '',
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return;
    } else {
      throw Exception(data['message'] ?? 'Gagal menyimpan barang keluar');
    }
  }
}
