import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _service = CategoryService();

  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  // Load Data
  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _service.getCategories();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add Data
  Future<bool> addCategory(String name) async {
    try {
      await _service.createCategory(name);
      await fetchCategories(); // Refresh data
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update Data
  Future<bool> updateCategory(int id, String name) async {
    try {
      await _service.updateCategory(id, name);
      await fetchCategories();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete Data
  Future<bool> deleteCategory(int id) async {
    try {
      await _service.deleteCategory(id);
      await fetchCategories();
      return true;
    } catch (e) {
      return false;
    }
  }
}
