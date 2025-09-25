class Agendamento {
  final String id;
  final String clienteCpf;
  final String barbeiroCpf;
  final DateTime dataHora;
  final String servico;
  final double valor;
  final String status; // 'agendado', 'confirmado', 'realizado', 'cancelado'
  final String? observacoes;
  final DateTime dataCriacao;

  Agendamento({
    required this.id,
    required this.clienteCpf,
    required this.barbeiroCpf,
    required this.dataHora,
    required this.servico,
    required this.valor,
    required this.status,
    this.observacoes,
    required this.dataCriacao,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'],
      clienteCpf: json['clienteCpf'],
      barbeiroCpf: json['barbeiroCpf'],
      dataHora: DateTime.parse(json['dataHora']),
      servico: json['servico'],
      valor: (json['valor'] ?? 0.0).toDouble(),
      status: json['status'],
      observacoes: json['observacoes'],
      dataCriacao: DateTime.parse(json['dataCriacao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteCpf': clienteCpf,
      'barbeiroCpf': barbeiroCpf,
      'dataHora': dataHora.toIso8601String(),
      'servico': servico,
      'valor': valor,
      'status': status,
      'observacoes': observacoes,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }

  Agendamento copyWith({
    String? id,
    String? clienteCpf,
    String? barbeiroCpf,
    DateTime? dataHora,
    String? servico,
    double? valor,
    String? status,
    String? observacoes,
    DateTime? dataCriacao,
  }) {
    return Agendamento(
      id: id ?? this.id,
      clienteCpf: clienteCpf ?? this.clienteCpf,
      barbeiroCpf: barbeiroCpf ?? this.barbeiroCpf,
      dataHora: dataHora ?? this.dataHora,
      servico: servico ?? this.servico,
      valor: valor ?? this.valor,
      status: status ?? this.status,
      observacoes: observacoes ?? this.observacoes,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }
}
