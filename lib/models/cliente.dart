import 'user.dart';

class Cliente extends User {
  final String? observacoes;
  final DateTime dataCadastro;
  final bool ativo;

  Cliente({
    required super.cpf,
    required super.nome,
    required super.email,
    required super.telefone,
    required super.genero,
    required super.dataNascimento,
    super.foto,
    this.observacoes,
    required this.dataCadastro,
    this.ativo = true,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      cpf: json['cpf'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      genero: json['genero'],
      dataNascimento: DateTime.parse(json['dataNascimento']),
      foto: json['foto'],
      observacoes: json['observacoes'],
      dataCadastro: DateTime.parse(json['dataCadastro']),
      ativo: json['ativo'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'genero': genero,
      'dataNascimento': dataNascimento.toIso8601String(),
      'foto': foto,
      'observacoes': observacoes,
      'dataCadastro': dataCadastro.toIso8601String(),
      'ativo': ativo,
    };
  }

  @override
  Cliente copyWith({
    String? cpf,
    String? nome,
    String? email,
    String? telefone,
    String? genero,
    DateTime? dataNascimento,
    String? foto,
    String? observacoes,
    DateTime? dataCadastro,
    bool? ativo,
  }) {
    return Cliente(
      cpf: cpf ?? this.cpf,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      genero: genero ?? this.genero,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      foto: foto ?? this.foto,
      observacoes: observacoes ?? this.observacoes,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      ativo: ativo ?? this.ativo,
    );
  }
}