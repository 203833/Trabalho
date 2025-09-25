import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/data_service.dart';
import '../utils/app_theme.dart';
import '../widgets/stats_card.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/bar_chart_widget.dart';
import 'clientes_screen.dart';
import 'barbeiros_screen.dart';
import 'agendamentos_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'logout') {
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 8),
                        Text(authProvider.user?.nome ?? 'Usuário'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Sair'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cards de estatísticas
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Total Clientes',
                    value: DataService.totalClientes.toString(),
                    icon: Icons.people,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: 'Barbeiros',
                    value: DataService.totalBarbeiros.toString(),
                    icon: Icons.content_cut,
                    color: AppTheme.secondaryColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Agendamentos',
                    value: DataService.totalAgendamentos.toString(),
                    icon: Icons.calendar_today,
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: 'Receita Total',
                    value: 'R\$ ${DataService.receitaTotal.toStringAsFixed(2)}',
                    icon: Icons.attach_money,
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Gráfico de Pizza - Gênero dos Clientes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distribuição por Gênero',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: PieChartWidget(
                        data: DataService.estatisticasGenero,
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Gráfico de Barras - Status dos Agendamentos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status dos Agendamentos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: BarChartWidget(
                        data: DataService.estatisticasStatus,
                        colors: [
                          AppTheme.warningColor,
                          AppTheme.accentColor,
                          AppTheme.successColor,
                          AppTheme.errorColor,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botões de navegação
            Text(
              'Gerenciamento',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildNavigationCard(
                    context,
                    title: 'Clientes',
                    icon: Icons.people,
                    color: AppTheme.primaryColor,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ClientesScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildNavigationCard(
                    context,
                    title: 'Barbeiros',
                    icon: Icons.content_cut,
                    color: AppTheme.secondaryColor,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const BarbeirosScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildNavigationCard(
              context,
              title: 'Agendamentos',
              icon: Icons.calendar_today,
              color: AppTheme.accentColor,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AgendamentosScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
