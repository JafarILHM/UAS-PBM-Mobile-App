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

    if (response.statusCode != 200) {
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Failed to load transactions');
      } catch (e) {
        throw Exception(
            'Failed to load transactions (status code: ${response.statusCode})');
      }
    }

    try {
      // First, try to decode the response as-is.
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final List<dynamic> transactionData = data['data'];
        return transactionData
            .map((tx) => Transaction.fromMap(tx, tx['type']))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to load transactions');
      }
    } on FormatException {
      // If parsing fails, the JSON might be malformed (e.g., concatenated objects).
      // This is a workaround for a potential backend issue.
      String responseBody = response.body;

      // Check for and remove potential PHP warnings/errors before the JSON starts.
      final jsonStartIndex = responseBody.indexOf('{"');
      if (jsonStartIndex > 0) {
        responseBody = responseBody.substring(jsonStartIndex);
      }

      // The backend might be returning a stream of json objects concatenated.
      if (responseBody.contains('}{')) {
        responseBody = responseBody.replaceAll('}{', '},{');
      }

      // Now wrap it in an array to create a valid JSON array string.
      final fixedJson = '[$responseBody]';

      try {
        // Attempt to decode the fixed JSON.
        final List<dynamic> transactionData = jsonDecode(fixedJson);
        // This path assumes the response was a list of transaction objects.
        return transactionData
            .map((tx) => Transaction.fromMap(tx, tx['type']))
            .toList();
      } catch (e) {
        // If fixing and re-parsing fails, throw a specific error.
        throw Exception(
            'Failed to parse transactions: Malformed JSON data received from server.');
      }
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
