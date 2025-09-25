import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/agendamento.dart';
import '../utils/app_theme.dart';

class AgendamentosScreen extends StatefulWidget {
  const AgendamentosScreen({super.key});

  @override
  State<AgendamentosScreen> createState() => _AgendamentosScreenState();
}

class _AgendamentosScreenState extends State<AgendamentosScreen> {
  List<Agendamento> _agendamentos = [];

  @override
  void initState() {
    super.initState();
    _loadAgendamentos();
  }

  void _loadAgendamentos() {
    setState(() {
      _agendamentos = DataService.agendamentos;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'agendado':
        return AppTheme.warningColor;
      case 'confirmado':
        return AppTheme.accentColor;
      case 'realizado':
        return AppTheme.successColor;
      case 'cancelado':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'agendado':
        return Icons.schedule;
      case 'confirmado':
        return Icons.check_circle_outline;
      case 'realizado':
        return Icons.check_circle;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Agendamentos'),
        backgroundColor: AppTheme.accentColor,
      ),
      body: _agendamentos.isEmpty
          ? const Center(
              child: Text('Nenhum agendamento encontrado'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _agendamentos.length,
              itemBuilder: (context, index) {
                final agendamento = _agendamentos[index];
                final cliente = DataService.clientes.firstWhere(
                  (c) => c.cpf == agendamento.clienteCpf,
                  orElse: () => DataService.clientes.first,
                );
                final barbeiro = DataService.barbeiros.firstWhere(
                  (b) => b.cpf == agendamento.barbeiroCpf,
                  orElse: () => DataService.barbeiros.first,
                );
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getStatusIcon(agendamento.status),
                              color: _getStatusColor(agendamento.status),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              agendamento.status.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(agendamento.status),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'R\$ ${agendamento.valor.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Cliente: ${cliente.nome}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text('Barbeiro: ${barbeiro.nome}'),
                        Text('Serviço: ${agendamento.servico}'),
                        Text(
                          'Data: ${agendamento.dataHora.day}/${agendamento.dataHora.month}/${agendamento.dataHora.year}',
                        ),
                        Text(
                          'Horário: ${agendamento.dataHora.hour.toString().padLeft(2, '0')}:${agendamento.dataHora.minute.toString().padLeft(2, '0')}',
                        ),
                        if (agendamento.observacoes != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Observações: ${agendamento.observacoes}',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
