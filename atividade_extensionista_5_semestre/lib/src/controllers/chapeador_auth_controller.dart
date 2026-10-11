import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class _MockUser {
  final String? displayName;
  final String? email;
  const _MockUser(this.displayName, this.email);
}

class ChapeadorAuthController extends ChangeNotifier {
  static final ChapeadorAuthController instance = ChapeadorAuthController._internal();
  factory ChapeadorAuthController() => instance;
  ChapeadorAuthController._internal();

  bool isLoggedIn = false;
  bool isLoading = false;
  String? errorMessage;
  String? chapeadorNome;
  String? chapeadorEmail;

  _MockUser? get currentUser => isLoggedIn ? _MockUser(chapeadorNome, chapeadorEmail ?? 'chapeador@impactcar.com') : null;

  Future<bool> login(String email, String senha) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'senha': senha.trim(),
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        isLoggedIn = true;
        final userData = data['data'] as Map<String, dynamic>?;
        chapeadorNome = userData?['nome'] as String? ?? 'Chapeador';
        chapeadorEmail = userData?['email'] as String? ?? email;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        errorMessage = data['message'] as String? ?? 'E-mail ou senha inválidos.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Erro de conexão com o servidor: $e';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    isLoggedIn = false;
    chapeadorNome = null;
    chapeadorEmail = null;
    notifyListeners();
  }

  Future<void> signOut() async {
    logout();
  }
}
