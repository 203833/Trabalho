import 'dart:convert';
import '../models/auth_user.dart';

class AuthService {
  // Simular login com dados mockados
  static Future<AuthUser?> login(String email, String password) async {
    try {
      // Simular delay da API
      await Future.delayed(const Duration(seconds: 1));
      
      // Validar credenciais básicas
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email e senha são obrigatórios');
      }
      
      if (password.length < 6) {
        throw Exception('Senha deve ter pelo menos 6 caracteres');
      }
      
      // Simular usuários válidos
      final validUsers = [
        {'email': 'admin@barbearia.com', 'password': '123456', 'name': 'Administrador', 'tipo': 'admin'},
        {'email': 'barbeiro@barbearia.com', 'password': '123456', 'name': 'João Barbeiro', 'tipo': 'barbeiro'},
        {'email': 'teste@teste.com', 'password': '123456', 'name': 'Usuário Teste', 'tipo': 'barbeiro'},
      ];
      
      final user = validUsers.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => throw Exception('Credenciais inválidas'),
      );
      
      // Gerar token simulado
      final token = _generateToken();
      final expiresAt = DateTime.now().add(const Duration(hours: 8));
      
      return AuthUser(
        token: token,
        refreshToken: _generateToken(),
        expiresAt: expiresAt,
        email: user['email']!,
        nome: user['name']!,
        tipo: user['tipo']!,
      );
      
    } catch (e) {
      throw Exception('Erro ao fazer login: ${e.toString()}');
    }
  }
  
  static String _generateToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000).toString();
    return base64Encode(utf8.encode(random));
  }
  
  static Future<bool> refreshToken(String refreshToken) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      // Simular refresh do token
      return true;
    } catch (e) {
      return false;
    }
  }
  
  static Future<void> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // Simular logout
    } catch (e) {
      // Ignorar erros no logout
    }
  }
}
