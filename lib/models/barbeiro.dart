import 'user.dart';

class Barbeiro extends User {
  final String especialidade;
  final double avaliacao;
  final int totalAtendimentos;
  final DateTime dataAdmissao;
  final bool ativo;
  final List<String> diasTrabalho;
  final String horarioInicio;
  final String horarioFim;

  Barbeiro({
    required super.cpf,
    required super.nome,
    required super.email,
    required super.telefone,
    required super.genero,
    required super.dataNascimento,
    super.foto,
    required this.especialidade,
    this.avaliacao = 0.0,
    this.totalAtendimentos = 0,
    required this.dataAdmissao,
    this.ativo = true,
    required this.diasTrabalho,
    required this.horarioInicio,
    required this.horarioFim,
  });

  factory Barbeiro.fromJson(Map<String, dynamic> json) {
    return Barbeiro(
      cpf: json['cpf'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      genero: json['genero'],
      dataNascimento: DateTime.parse(json['dataNascimento']),
      foto: json['foto'],
      especialidade: json['especialidade'],
      avaliacao: (json['avaliacao'] ?? 0.0).toDouble(),
      totalAtendimentos: json['totalAtendimentos'] ?? 0,
      dataAdmissao: DateTime.parse(json['dataAdmissao']),
      ativo: json['ativo'] ?? true,
      diasTrabalho: List<String>.from(json['diasTrabalho'] ?? []),
      horarioInicio: json['horarioInicio'],
      horarioFim: json['horarioFim'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'especialidade': especialidade,
      'avaliacao': avaliacao,
      'totalAtendimentos': totalAtendimentos,
      'dataAdmissao': dataAdmissao.toIso8601String(),
      'ativo': ativo,
      'diasTrabalho': diasTrabalho,
      'horarioInicio': horarioInicio,
      'horarioFim': horarioFim,
    };
  }

  @override
  Barbeiro copyWith({
    String? cpf,
    String? nome,
    String? email,
    String? telefone,
    String? genero,
    DateTime? dataNascimento,
    String? foto,
    String? especialidade,
    double? avaliacao,
    int? totalAtendimentos,
    DateTime? dataAdmissao,
    bool? ativo,
    List<String>? diasTrabalho,
    String? horarioInicio,
    String? horarioFim,
  }) {
    return Barbeiro(
      cpf: cpf ?? this.cpf,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      genero: genero ?? this.genero,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      foto: foto ?? this.foto,
      especialidade: especialidade ?? this.especialidade,
      avaliacao: avaliacao ?? this.avaliacao,
      totalAtendimentos: totalAtendimentos ?? this.totalAtendimentos,
      dataAdmissao: dataAdmissao ?? this.dataAdmissao,
      ativo: ativo ?? this.ativo,
      diasTrabalho: diasTrabalho ?? this.diasTrabalho,
      horarioInicio: horarioInicio ?? this.horarioInicio,
      horarioFim: horarioFim ?? this.horarioFim,
    );
  }
}

