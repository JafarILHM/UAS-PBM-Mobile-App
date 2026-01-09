import 'package:flutter/material.dart';
import '../models/unit_model.dart';
import '../services/unit_service.dart';

class UnitProvider with ChangeNotifier {
  final UnitService _service = UnitService();

  List<Unit> _units = [];
  bool _isLoading = false;

  List<Unit> get units => _units;
  bool get isLoading => _isLoading;

  Future<void> fetchUnits() async {
    _isLoading = true;
    notifyListeners();
    try {
      _units = await _service.getUnits();
    } catch (e) {
      debugPrint("Error: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addUnit(Unit unit) async {
    try {
      await _service.createUnit(unit);
      await fetchUnits();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUnit(Unit unit) async {
    try {
      await _service.updateUnit(unit);
      await fetchUnits();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUnit(int id) async {
    try {
      await _service.deleteUnit(id);
      await fetchUnits();
      return true;
    } catch (e) {
      return false;
    }
  }
}
