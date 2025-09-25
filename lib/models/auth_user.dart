class AuthUser {
  final String token;
  final String refreshToken;
  final DateTime expiresAt;
  final String email;
  final String nome;
  final String tipo; // 'admin', 'barbeiro'

  AuthUser({
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
    required this.email,
    required this.nome,
    required this.tipo,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      token: json['token'],
      refreshToken: json['refreshToken'],
      expiresAt: DateTime.parse(json['expiresAt']),
      email: json['email'],
      nome: json['nome'],
      tipo: json['tipo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'email': email,
      'nome': nome,
      'tipo': tipo,
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
