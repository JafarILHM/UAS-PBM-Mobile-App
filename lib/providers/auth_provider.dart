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
      
      // Simpan Token ke HP (agar nanti tidak perlu login ulang)
      final prefs = await SharedPreferences.getInstance();
      if (_token != null) {
        await prefs.setString('token', _token!);
      }

      _isLoading = false;
      notifyListeners(); 
      return true;
      
    } catch (e) {
      _isLoading = false;
      notifyListeners(); 
      rethrow; 
    }
  }
}