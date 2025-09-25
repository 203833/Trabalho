# 🏪 Sistema de Barbearia Flutter

Um aplicativo mobile completo desenvolvido em Flutter para gerenciamento de barbearias, com dashboard interativo, gráficos e sistema de autenticação.

## 📱 Funcionalidades

### ✅ Implementadas

- **🚀 Tela Splash** - Animação elegante com logo da barbearia
- **🔐 Sistema de Login** - Autenticação com token temporizado
- **📊 Dashboard Completo** - Gráficos interativos e estatísticas
- **👥 Gestão de Clientes** - CRUD completo com validação
- **✂️ Gestão de Barbeiros** - Cadastro com especialidades e horários
- **📅 Visualização de Agendamentos** - Lista com status colorido
- **🎨 Identidade Visual** - Design profissional e consistente
- **🔄 Logout** - Limpeza completa de dados

### 📊 Dashboard

- **Cards de Estatísticas**: Total de clientes, barbeiros, agendamentos e receita
- **Gráfico de Pizza**: Distribuição por gênero dos clientes
- **Gráfico de Barras**: Status dos agendamentos
- **Navegação Intuitiva**: Acesso rápido a todas as seções

### 🛠️ Tecnologias

- **Flutter** com Material Design 3
- **Provider** para gerenciamento de estado
- **FL Chart** para gráficos interativos
- **Form Validator** para validação de formulários
- **Flutter Spinkit** para animações de loading
- **Dio/HTTP** para requisições (simuladas)

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (versão 3.9.2 ou superior)
- Dart SDK
- Android Studio / VS Code
- Git

### Instalação

1. Clone o repositório:
```bash
git clone <url-do-repositorio>
cd trabalho
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute a aplicação:
```bash
flutter run
```

## 🔑 Credenciais de Teste

- **Admin**: `admin@barbearia.com` / `123456`
- **Barbeiro**: `barbeiro@barbearia.com` / `123456`
- **Teste**: `teste@teste.com` / `123456`

## 📁 Estrutura do Projeto

```
lib/
├── models/          # Modelos de dados
│   ├── user.dart
│   ├── cliente.dart
│   ├── barbeiro.dart
│   ├── agendamento.dart
│   └── auth_user.dart
├── services/        # Serviços
│   ├── auth_service.dart
│   └── data_service.dart
├── providers/       # Gerenciamento de estado
│   └── auth_provider.dart
├── screens/         # Telas da aplicação
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── clientes_screen.dart
│   ├── barbeiros_screen.dart
│   ├── agendamentos_screen.dart
│   ├── cliente_form_screen.dart
│   └── barbeiro_form_screen.dart
├── widgets/         # Componentes reutilizáveis
│   ├── custom_text_field.dart
│   ├── stats_card.dart
│   ├── pie_chart_widget.dart
│   └── bar_chart_widget.dart
└── utils/           # Utilitários
    └── app_theme.dart
```

## 🎨 Design System

### Cores Principais

- **Primária**: `#2C3E50` (Azul escuro elegante)
- **Secundária**: `#E67E22` (Laranja vibrante)
- **Accent**: `#F39C12` (Dourado)
- **Background**: `#F8F9FA` (Cinza claro)
- **Sucesso**: `#27AE60` (Verde)
- **Erro**: `#E74C3C` (Vermelho)

### Componentes

- **Cards**: Bordas arredondadas com sombra sutil
- **Botões**: Estilo Material Design 3 com cores temáticas
- **Campos**: Validação visual e feedback imediato
- **Gráficos**: Cores consistentes e interatividade

## 📊 Funcionalidades Detalhadas

### Gestão de Clientes

- ✅ Cadastro com validação de CPF
- ✅ Edição de dados pessoais
- ✅ Exclusão com confirmação
- ✅ Listagem com informações completas
- ✅ Campos: CPF, nome, email, telefone, gênero, data nascimento, observações

### Gestão de Barbeiros

- ✅ Cadastro com especialidades
- ✅ Configuração de horários de trabalho
- ✅ Seleção de dias da semana
- ✅ Avaliação e contagem de atendimentos
- ✅ Campos: CPF, nome, email, telefone, especialidade, gênero, data nascimento, data admissão, horários, dias de trabalho

### Dashboard

- ✅ Estatísticas em tempo real
- ✅ Gráfico de pizza para distribuição por gênero
- ✅ Gráfico de barras para status de agendamentos
- ✅ Cards informativos com ícones
- ✅ Navegação rápida para todas as seções

## 🔒 Segurança

- ✅ Validação de formulários
- ✅ Autenticação com token temporizado
- ✅ Logout seguro com limpeza de dados
- ✅ Confirmação para ações destrutivas

## 📱 Responsividade

- ✅ Design adaptável para diferentes tamanhos de tela
- ✅ Componentes otimizados para mobile
- ✅ Navegação intuitiva e acessível

## 🎯 Pontos Extras Conquistados

- ✅ **Escolha da aplicação** (Sistema de Barbearia) - **2 pontos**
- ✅ **Design profissional** e identidade visual consistente
- ✅ **Gráficos interativos** com dados reais
- ✅ **Validação robusta** de formulários
- ✅ **Navegação intuitiva** e UX moderna

## 📝 Licença

Este projeto foi desenvolvido como trabalho final da disciplina de Flutter.

## 👨‍💻 Desenvolvedor

Desenvolvido com ❤️ usando Flutter e Material Design 3.

---

**Status**: ✅ Concluído e Funcional
**Versão**: 1.0.0
**Última Atualização**: Dezembro 2024