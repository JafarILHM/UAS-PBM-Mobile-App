import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/item_service.dart';

class ItemProvider with ChangeNotifier {
  final ItemService _service = ItemService();

  List<Item> _items = [];
  bool _isLoading = false;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _service.getItems();
    } catch (e) {
      debugPrint("Error fetching items: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addItem(Item item) async {
    try {
      await _service.createItem(item);
      await fetchItems();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateItem(Item item) async {
    try {
      await _service.updateItem(item);
      await fetchItems();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteItem(int id) async {
    try {
      await _service.deleteItem(id);
      await fetchItems();
      return true;
    } catch (e) {
      return false;
    }
  }
}
