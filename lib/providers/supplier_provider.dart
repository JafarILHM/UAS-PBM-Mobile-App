import 'package:flutter/material.dart';
import '../models/supplier_model.dart';
import '../services/supplier_service.dart';

class SupplierProvider with ChangeNotifier {
  final SupplierService _service = SupplierService();

  List<Supplier> _suppliers = [];
  bool _isLoading = false;

  List<Supplier> get suppliers => _suppliers;
  bool get isLoading => _isLoading;

  // Load Data
  Future<void> fetchSuppliers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _suppliers = await _service.getSuppliers();
    } catch (e) {
      debugPrint("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Tambah
  Future<bool> addSupplier(Supplier supplier) async {
    try {
      await _service.createSupplier(supplier);
      await fetchSuppliers();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Edit
  Future<bool> updateSupplier(Supplier supplier) async {
    try {
      await _service.updateSupplier(supplier);
      await fetchSuppliers();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Hapus
  Future<bool> deleteSupplier(int id) async {
    try {
      await _service.deleteSupplier(id);
      await fetchSuppliers();
      return true;
    } catch (e) {
      return false;
    }
  }
}
