import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _token;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get token => _token;

  final AuthService _authService = AuthService();

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _authService.login(email, password);
      _user = user;
      _token = user.token;
      final prefs = await SharedPreferences.getInstance();
      if (_token != null) await prefs.setString('token', _token!);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> updateProfile(
    String name,
    String email,
    String? password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Panggil service
      final updatedUser = await _authService.updateProfile(
        name,
        email,
        password,
      );

      // Update data user di memori aplikasi
      _user = updatedUser;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    _user = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }
}
