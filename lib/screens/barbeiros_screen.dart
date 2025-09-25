import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/barbeiro.dart';
import '../utils/app_theme.dart';
import 'barbeiro_form_screen.dart';

class BarbeirosScreen extends StatefulWidget {
  const BarbeirosScreen({super.key});

  @override
  State<BarbeirosScreen> createState() => _BarbeirosScreenState();
}

class _BarbeirosScreenState extends State<BarbeirosScreen> {
  List<Barbeiro> _barbeiros = [];

  @override
  void initState() {
    super.initState();
    _loadBarbeiros();
  }

  void _loadBarbeiros() {
    setState(() {
      _barbeiros = DataService.barbeiros;
    });
  }

  void _deleteBarbeiro(Barbeiro barbeiro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o barbeiro ${barbeiro.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              DataService.removerBarbeiro(barbeiro.cpf);
              _loadBarbeiros();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Barbeiro ${barbeiro.nome} excluído com sucesso!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Barbeiros'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: _barbeiros.isEmpty
          ? const Center(
              child: Text('Nenhum barbeiro cadastrado'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _barbeiros.length,
              itemBuilder: (context, index) {
                final barbeiro = _barbeiros[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.content_cut,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    title: Text(
                      barbeiro.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CPF: ${barbeiro.cpf}'),
                        Text('Especialidade: ${barbeiro.especialidade}'),
                        Text('Avaliação: ${barbeiro.avaliacao.toStringAsFixed(1)} ⭐'),
                        Text('Atendimentos: ${barbeiro.totalAtendimentos}'),
                        Text('Horário: ${barbeiro.horarioInicio} - ${barbeiro.horarioFim}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BarbeiroFormScreen(barbeiro: barbeiro),
                              ),
                            );
                            if (result == true) {
                              _loadBarbeiros();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: AppTheme.errorColor),
                          onPressed: () => _deleteBarbeiro(barbeiro),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const BarbeiroFormScreen(),
            ),
          );
          if (result == true) {
            _loadBarbeiros();
          }
        },
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
