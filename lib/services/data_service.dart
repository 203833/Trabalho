import '../models/cliente.dart';
import '../models/barbeiro.dart';
import '../models/agendamento.dart';

class DataService {
  static final List<Cliente> _clientes = [
    Cliente(
      cpf: '123.456.789-00',
      nome: 'João Silva',
      email: 'joao@email.com',
      telefone: '(11) 99999-9999',
      genero: 'Masculino',
      dataNascimento: DateTime(1990, 5, 15),
      dataCadastro: DateTime.now().subtract(const Duration(days: 30)),
      observacoes: 'Cliente preferencial',
    ),
    Cliente(
      cpf: '987.654.321-00',
      nome: 'Maria Santos',
      email: 'maria@email.com',
      telefone: '(11) 88888-8888',
      genero: 'Feminino',
      dataNascimento: DateTime(1985, 8, 22),
      dataCadastro: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Cliente(
      cpf: '111.222.333-44',
      nome: 'Pedro Oliveira',
      email: 'pedro@email.com',
      telefone: '(11) 77777-7777',
      genero: 'Masculino',
      dataNascimento: DateTime(1992, 3, 10),
      dataCadastro: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Cliente(
      cpf: '555.666.777-88',
      nome: 'Ana Costa',
      email: 'ana@email.com',
      telefone: '(11) 66666-6666',
      genero: 'Feminino',
      dataNascimento: DateTime(1988, 12, 5),
      dataCadastro: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static final List<Barbeiro> _barbeiros = [
    Barbeiro(
      cpf: '000.111.222-33',
      nome: 'Carlos Barbeiro',
      email: 'carlos@barbearia.com',
      telefone: '(11) 55555-5555',
      genero: 'Masculino',
      dataNascimento: DateTime(1980, 6, 20),
      especialidade: 'Corte Masculino',
      dataAdmissao: DateTime.now().subtract(const Duration(days: 365)),
      diasTrabalho: ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta'],
      horarioInicio: '08:00',
      horarioFim: '18:00',
      avaliacao: 4.8,
      totalAtendimentos: 150,
    ),
    Barbeiro(
      cpf: '444.555.666-77',
      nome: 'Roberto Estilista',
      email: 'roberto@barbearia.com',
      telefone: '(11) 44444-4444',
      genero: 'Masculino',
      dataNascimento: DateTime(1985, 9, 15),
      especialidade: 'Barba e Bigode',
      dataAdmissao: DateTime.now().subtract(const Duration(days: 200)),
      diasTrabalho: ['Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'],
      horarioInicio: '09:00',
      horarioFim: '19:00',
      avaliacao: 4.9,
      totalAtendimentos: 120,
    ),
  ];

  static final List<Agendamento> _agendamentos = [
    Agendamento(
      id: '1',
      clienteCpf: '123.456.789-00',
      barbeiroCpf: '000.111.222-33',
      dataHora: DateTime.now().add(const Duration(hours: 2)),
      servico: 'Corte + Barba',
      valor: 45.0,
      status: 'agendado',
      dataCriacao: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Agendamento(
      id: '2',
      clienteCpf: '987.654.321-00',
      barbeiroCpf: '444.555.666-77',
      dataHora: DateTime.now().add(const Duration(days: 1)),
      servico: 'Corte Feminino',
      valor: 35.0,
      status: 'confirmado',
      dataCriacao: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Agendamento(
      id: '3',
      clienteCpf: '111.222.333-44',
      barbeiroCpf: '000.111.222-33',
      dataHora: DateTime.now().subtract(const Duration(hours: 3)),
      servico: 'Corte',
      valor: 25.0,
      status: 'realizado',
      dataCriacao: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Getters
  static List<Cliente> get clientes => _clientes;
  static List<Barbeiro> get barbeiros => _barbeiros;
  static List<Agendamento> get agendamentos => _agendamentos;

  // Estatísticas para dashboard
  static Map<String, int> get estatisticasGenero {
    final masculino = _clientes.where((c) => c.genero == 'Masculino').length;
    final feminino = _clientes.where((c) => c.genero == 'Feminino').length;
    return {
      'Masculino': masculino,
      'Feminino': feminino,
    };
  }

  static Map<String, int> get estatisticasStatus {
    final agendado = _agendamentos.where((a) => a.status == 'agendado').length;
    final confirmado = _agendamentos.where((a) => a.status == 'confirmado').length;
    final realizado = _agendamentos.where((a) => a.status == 'realizado').length;
    final cancelado = _agendamentos.where((a) => a.status == 'cancelado').length;
    
    return {
      'Agendado': agendado,
      'Confirmado': confirmado,
      'Realizado': realizado,
      'Cancelado': cancelado,
    };
  }

  static double get receitaTotal {
    return _agendamentos
        .where((a) => a.status == 'realizado')
        .fold(0.0, (sum, a) => sum + a.valor);
  }

  static int get totalClientes => _clientes.length;
  static int get totalBarbeiros => _barbeiros.length;
  static int get totalAgendamentos => _agendamentos.length;

  // Métodos CRUD
  static void adicionarCliente(Cliente cliente) {
    _clientes.add(cliente);
  }

  static void atualizarCliente(Cliente cliente) {
    final index = _clientes.indexWhere((c) => c.cpf == cliente.cpf);
    if (index != -1) {
      _clientes[index] = cliente;
    }
  }

  static void removerCliente(String cpf) {
    _clientes.removeWhere((c) => c.cpf == cpf);
  }

  static void adicionarBarbeiro(Barbeiro barbeiro) {
    _barbeiros.add(barbeiro);
  }

  static void atualizarBarbeiro(Barbeiro barbeiro) {
    final index = _barbeiros.indexWhere((b) => b.cpf == barbeiro.cpf);
    if (index != -1) {
      _barbeiros[index] = barbeiro;
    }
  }

  static void removerBarbeiro(String cpf) {
    _barbeiros.removeWhere((b) => b.cpf == cpf);
  }
}
