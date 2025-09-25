import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import '../models/cliente.dart';
import '../services/data_service.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_text_field.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormScreen({super.key, this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _observacoesController = TextEditingController();
  
  String _genero = 'Masculino';
  DateTime _dataNascimento = DateTime.now().subtract(const Duration(days: 365 * 25));

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _loadClienteData();
    }
  }

  void _loadClienteData() {
    final cliente = widget.cliente!;
    _cpfController.text = cliente.cpf;
    _nomeController.text = cliente.nome;
    _emailController.text = cliente.email;
    _telefoneController.text = cliente.telefone;
    _observacoesController.text = cliente.observacoes ?? '';
    _genero = cliente.genero;
    _dataNascimento = cliente.dataNascimento;
  }

  String _formatCPF(String value) {
    // Remove todos os caracteres não numéricos
    String numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Aplica a máscara do CPF
    if (numbers.length <= 11) {
      if (numbers.length <= 3) {
        return numbers;
      } else if (numbers.length <= 6) {
        return '${numbers.substring(0, 3)}.${numbers.substring(3)}';
      } else if (numbers.length <= 9) {
        return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6)}';
      } else {
        return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9)}';
      }
    }
    return value;
  }

  String _formatTelefone(String value) {
    String numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbers.length <= 11) {
      if (numbers.length <= 2) {
        return numbers;
      } else if (numbers.length <= 6) {
        return '(${numbers.substring(0, 2)}) ${numbers.substring(2)}';
      } else if (numbers.length <= 10) {
        return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6)}';
      } else {
        return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7)}';
      }
    }
    return value;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dataNascimento) {
      setState(() {
        _dataNascimento = picked;
      });
    }
  }

  void _saveCliente() {
    if (!_formKey.currentState!.validate()) return;

    final cliente = Cliente(
      cpf: _cpfController.text.trim(),
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
      genero: _genero,
      dataNascimento: _dataNascimento,
      observacoes: _observacoesController.text.trim().isEmpty 
          ? null 
          : _observacoesController.text.trim(),
      dataCadastro: widget.cliente?.dataCadastro ?? DateTime.now(),
    );

    if (widget.cliente != null) {
      DataService.atualizarCliente(cliente);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente atualizado com sucesso!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } else {
      DataService.adicionarCliente(cliente);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente cadastrado com sucesso!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.cliente != null ? 'Editar Cliente' : 'Novo Cliente'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          TextButton(
            onPressed: _saveCliente,
            child: const Text(
              'SALVAR',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _cpfController,
                label: 'CPF',
                hint: '000.000.000-00',
                prefixIcon: Icons.person,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: ValidationBuilder()
                    .required('CPF é obrigatório')
                    .minLength(11, 'CPF deve ter 11 dígitos')
                    .build(),
                onChanged: (value) {
                  final formatted = _formatCPF(value);
                  if (formatted != value) {
                    _cpfController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _nomeController,
                label: 'Nome Completo',
                hint: 'Digite o nome completo',
                prefixIcon: Icons.person_outline,
                validator: ValidationBuilder()
                    .required('Nome é obrigatório')
                    .minLength(2, 'Nome deve ter pelo menos 2 caracteres')
                    .build(),
              ),
              
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'exemplo@email.com',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: ValidationBuilder()
                    .email('Email inválido')
                    .required('Email é obrigatório')
                    .build(),
              ),
              
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _telefoneController,
                label: 'Telefone',
                hint: '(00) 00000-0000',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: ValidationBuilder()
                    .required('Telefone é obrigatório')
                    .minLength(10, 'Telefone deve ter pelo menos 10 dígitos')
                    .build(),
                onChanged: (value) {
                  final formatted = _formatTelefone(value);
                  if (formatted != value) {
                    _telefoneController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              // Campo de Gênero
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gênero',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Masculino'),
                          value: 'Masculino',
                          groupValue: _genero,
                          onChanged: (value) {
                            setState(() {
                              _genero = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Feminino'),
                          value: 'Feminino',
                          groupValue: _genero,
                          onChanged: (value) {
                            setState(() {
                              _genero = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Campo de Data de Nascimento
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data de Nascimento',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.textSecondary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: AppTheme.textSecondary),
                          const SizedBox(width: 12),
                          Text(
                            '${_dataNascimento.day.toString().padLeft(2, '0')}/${_dataNascimento.month.toString().padLeft(2, '0')}/${_dataNascimento.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _observacoesController,
                label: 'Observações',
                hint: 'Observações adicionais (opcional)',
                prefixIcon: Icons.note,
                maxLines: 3,
              ),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _saveCliente,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  widget.cliente != null ? 'ATUALIZAR CLIENTE' : 'CADASTRAR CLIENTE',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }
}
