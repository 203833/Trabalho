class User {
  final String cpf;
  final String nome;
  final String email;
  final String telefone;
  final String genero;
  final DateTime dataNascimento;
  final String? foto;

  User({
    required this.cpf,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.genero,
    required this.dataNascimento,
    this.foto,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      cpf: json['cpf'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      genero: json['genero'],
      dataNascimento: DateTime.parse(json['dataNascimento']),
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'genero': genero,
      'dataNascimento': dataNascimento.toIso8601String(),
      'foto': foto,
    };
  }

  User copyWith({
    String? cpf,
    String? nome,
    String? email,
    String? telefone,
    String? genero,
    DateTime? dataNascimento,
    String? foto,
  }) {
    return User(
      cpf: cpf ?? this.cpf,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      genero: genero ?? this.genero,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      foto: foto ?? this.foto,
    );
  }
}

