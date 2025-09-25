import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import '../models/barbeiro.dart';
import '../services/data_service.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_text_field.dart';

class BarbeiroFormScreen extends StatefulWidget {
  final Barbeiro? barbeiro;

  const BarbeiroFormScreen({super.key, this.barbeiro});

  @override
  State<BarbeiroFormScreen> createState() => _BarbeiroFormScreenState();
}

class _BarbeiroFormScreenState extends State<BarbeiroFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _especialidadeController = TextEditingController();
  
  String _genero = 'Masculino';
  DateTime _dataNascimento = DateTime.now().subtract(const Duration(days: 365 * 30));
  DateTime _dataAdmissao = DateTime.now();
  String _horarioInicio = '08:00';
  String _horarioFim = '18:00';
  List<String> _diasTrabalho = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta'];

  final List<String> _diasSemana = [
    'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.barbeiro != null) {
      _loadBarbeiroData();
    }
  }

  void _loadBarbeiroData() {
    final barbeiro = widget.barbeiro!;
    _cpfController.text = barbeiro.cpf;
    _nomeController.text = barbeiro.nome;
    _emailController.text = barbeiro.email;
    _telefoneController.text = barbeiro.telefone;
    _especialidadeController.text = barbeiro.especialidade;
    _genero = barbeiro.genero;
    _dataNascimento = barbeiro.dataNascimento;
    _dataAdmissao = barbeiro.dataAdmissao;
    _horarioInicio = barbeiro.horarioInicio;
    _horarioFim = barbeiro.horarioFim;
    _diasTrabalho = List.from(barbeiro.diasTrabalho);
  }

  String _formatCPF(String value) {
    String numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    
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

  Future<void> _selectDate(DateTime initialDate, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  Future<void> _selectTime(String initialTime, Function(String) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(initialTime.split(':')[0]),
        minute: int.parse(initialTime.split(':')[1]),
      ),
    );
    if (picked != null) {
      final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      onTimeSelected(timeString);
    }
  }

  void _toggleDiaTrabalho(String dia) {
    setState(() {
      if (_diasTrabalho.contains(dia)) {
        _diasTrabalho.remove(dia);
      } else {
        _diasTrabalho.add(dia);
      }
    });
  }

  void _saveBarbeiro() {
    if (!_formKey.currentState!.validate()) return;
    if (_diasTrabalho.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos um dia de trabalho'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final barbeiro = Barbeiro(
      cpf: _cpfController.text.trim(),
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
      genero: _genero,
      dataNascimento: _dataNascimento,
      especialidade: _especialidadeController.text.trim(),
      dataAdmissao: _dataAdmissao,
      diasTrabalho: _diasTrabalho,
      horarioInicio: _horarioInicio,
      horarioFim: _horarioFim,
      avaliacao: widget.barbeiro?.avaliacao ?? 0.0,
      totalAtendimentos: widget.barbeiro?.totalAtendimentos ?? 0,
    );

    if (widget.barbeiro != null) {
      DataService.atualizarBarbeiro(barbeiro);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barbeiro atualizado com sucesso!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } else {
      DataService.adicionarBarbeiro(barbeiro);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barbeiro cadastrado com sucesso!'),
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
        title: Text(widget.barbeiro != null ? 'Editar Barbeiro' : 'Novo Barbeiro'),
        backgroundColor: AppTheme.secondaryColor,
        actions: [
          TextButton(
            onPressed: _saveBarbeiro,
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
              
              CustomTextField(
                controller: _especialidadeController,
                label: 'Especialidade',
                hint: 'Ex: Corte Masculino, Barba, etc.',
                prefixIcon: Icons.content_cut,
                validator: ValidationBuilder()
                    .required('Especialidade é obrigatória')
                    .build(),
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
              
              // Data de Nascimento
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
                    onTap: () => _selectDate(_dataNascimento, (date) {
                      setState(() {
                        _dataNascimento = date;
                      });
                    }),
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
              
              // Data de Admissão
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data de Admissão',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(_dataAdmissao, (date) {
                      setState(() {
                        _dataAdmissao = date;
                      });
                    }),
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
                            '${_dataAdmissao.day.toString().padLeft(2, '0')}/${_dataAdmissao.month.toString().padLeft(2, '0')}/${_dataAdmissao.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Horários de Trabalho
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Horário Início',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectTime(_horarioInicio, (time) {
                            setState(() {
                              _horarioInicio = time;
                            });
                          }),
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
                                const Icon(Icons.access_time, color: AppTheme.textSecondary),
                                const SizedBox(width: 12),
                                Text(
                                  _horarioInicio,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Horário Fim',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectTime(_horarioFim, (time) {
                            setState(() {
                              _horarioFim = time;
                            });
                          }),
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
                                const Icon(Icons.access_time, color: AppTheme.textSecondary),
                                const SizedBox(width: 12),
                                Text(
                                  _horarioFim,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Dias de Trabalho
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dias de Trabalho',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _diasSemana.map((dia) {
                      final isSelected = _diasTrabalho.contains(dia);
                      return FilterChip(
                        label: Text(dia),
                        selected: isSelected,
                        onSelected: (selected) => _toggleDiaTrabalho(dia),
                        selectedColor: AppTheme.secondaryColor.withOpacity(0.2),
                        checkmarkColor: AppTheme.secondaryColor,
                      );
                    }).toList(),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _saveBarbeiro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  widget.barbeiro != null ? 'ATUALIZAR BARBEIRO' : 'CADASTRAR BARBEIRO',
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
    _especialidadeController.dispose();
    super.dispose();
  }
}
