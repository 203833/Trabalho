import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/cliente.dart';
import '../utils/app_theme.dart';
import 'cliente_form_screen.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  void _loadClientes() {
    setState(() {
      _clientes = DataService.clientes;
    });
  }

  void _deleteCliente(Cliente cliente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o cliente ${cliente.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              DataService.removerCliente(cliente.cpf);
              _loadClientes();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cliente ${cliente.nome} excluído com sucesso!'),
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
        title: const Text('Clientes'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: _clientes.isEmpty
          ? const Center(
              child: Text('Nenhum cliente cadastrado'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _clientes.length,
              itemBuilder: (context, index) {
                final cliente = _clientes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: Text(
                        cliente.nome[0].toUpperCase(),
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      cliente.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CPF: ${cliente.cpf}'),
                        Text('Email: ${cliente.email}'),
                        Text('Telefone: ${cliente.telefone}'),
                        Text('Gênero: ${cliente.genero}'),
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
                                builder: (context) => ClienteFormScreen(cliente: cliente),
                              ),
                            );
                            if (result == true) {
                              _loadClientes();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: AppTheme.errorColor),
                          onPressed: () => _deleteCliente(cliente),
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
              builder: (context) => const ClienteFormScreen(),
            ),
          );
          if (result == true) {
            _loadClientes();
          }
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
