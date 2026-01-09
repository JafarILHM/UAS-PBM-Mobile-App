import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _service = TransactionService();

  List<Transaction> _transactions = [];
  bool _isLoading = false;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> fetchAllTransactions() async {
    _isLoading = true;
    notifyListeners();
    try {
      _transactions = await _service.getAllTransactions();
    } catch (e) {
      debugPrint("Error fetching transactions: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addIncoming(
    int itemId,
    int supplierId,
    int qty,
    String dateIn,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.addIncoming(itemId, supplierId, qty, dateIn);
      // Optionally refresh transactions
      await fetchAllTransactions();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOutgoing(
    int itemId,
    int qty,
    String dateOut,
    String? purpose,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.addOutgoing(itemId, qty, dateOut, purpose);
      await fetchAllTransactions();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
