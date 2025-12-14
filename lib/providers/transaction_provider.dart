import 'package:flutter/material.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _service = TransactionService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Submit Barang Masuk
  Future<bool> addIncoming(int itemId, int supplierId, int qty, String date) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = {
        'item_id': itemId,
        'supplier_id': supplierId,
        'qty': qty,
        'date_in': date,
      };
      
      await _service.createIncoming(data);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error Incoming: $e");
      rethrow; // Lempar error agar bisa ditangkap UI
    }
  }

  // Submit Barang Keluar
  Future<bool> addOutgoing(int itemId, int qty, String date, String purpose) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = {
        'item_id': itemId,
        'qty': qty,
        'date_out': date,
        'purpose': purpose,
      };

      await _service.createOutgoing(data);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      // Error seperti "Stok tidak cukup" akan dilempar di sini
      rethrow; 
    }
  }
}