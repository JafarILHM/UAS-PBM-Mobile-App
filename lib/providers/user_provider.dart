import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _service = UserService();
  
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  // Fetch Data
  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await _service.getUsers();
    } catch (e) {
      debugPrint("Error fetching users: $e");
      // Bisa tambahkan error handling lain
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add Data
  Future<bool> addUser(String name, String email, String password, String role) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.addUser(name, email, password, role);
      await fetchUsers(); // Refresh list
      return true;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Data
  Future<bool> updateUser(int id, String name, String email, String? password, String role) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.updateUser(id, name, email, password, role);
      await fetchUsers();
      return true;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete Data
  Future<bool> deleteUser(int id) async {
    try {
      await _service.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    }
  }
}