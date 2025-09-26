import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Importez le package
import 'package:shared_preferences/shared_preferences.dart';
import 'package:all_pnud/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isLoggedIn = false;
  Map<String, dynamic>? _decodedToken; // Stockez le token décodé
  final AuthService _authService = AuthService();

  String? get token => _token;
  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get decodedToken => _decodedToken;

  /// 🔹 Getters pour les rôles
  bool get isAgentRoutiere {
    final roles = _decodedToken?['roles'] as List<dynamic>? ?? [];
    return roles.any((role) => role['role_id'] == 88);
  }

  bool get isAgentParking {
    final roles = _decodedToken?['roles'] as List<dynamic>? ?? [];
    return roles.any((role) => role['role_id'] == 87);
  }

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token != null && !JwtDecoder.isExpired(_token!)) {
      _isLoggedIn = true;
      _decodedToken = JwtDecoder.decode(_token!); // Décodez le token
    } else {
      _isLoggedIn = false;
      _token = null;
      _decodedToken = null;
    }
    notifyListeners();
  }

  // 🔹 Méthode de connexion avec AuthService
  Future<bool> login(String email, String password) async {
    try {
      final token = await _authService.login(email, password);
      if (token != null) {
        _token = token;
        _isLoggedIn = true;
        _decodedToken = JwtDecoder.decode(_token!); // Décodez le token après la connexion

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Erreur login: $e");
      return false;
    }
  }

  // 🔹 Déconnexion
  Future<void> logout() async {
    _token = null;
    _isLoggedIn = false;
    _decodedToken = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
    notifyListeners();
  }
}
