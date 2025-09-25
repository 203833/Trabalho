import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthUser? _user;
  bool _isLoading = false;
  String? _error;

  AuthUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && !_user!.isExpired;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await AuthService.login(email, password);
      if (user != null) {
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.logout();
      _user = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> refreshToken() async {
    if (_user == null) return false;
    
    try {
      final success = await AuthService.refreshToken(_user!.refreshToken);
      if (success) {
        // Atualizar token - criar novo AuthUser
        _user = AuthUser(
          token: _generateNewToken(),
          refreshToken: _user!.refreshToken,
          expiresAt: DateTime.now().add(const Duration(hours: 8)),
          email: _user!.email,
          nome: _user!.nome,
          tipo: _user!.tipo,
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  String _generateNewToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000).toString();
    return base64Encode(utf8.encode(random));
  }
}
