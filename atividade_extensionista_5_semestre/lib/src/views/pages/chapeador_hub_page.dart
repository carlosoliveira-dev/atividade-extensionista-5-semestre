import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ChapeadorHubPage extends StatelessWidget {
  const ChapeadorHubPage({super.key});

  void _mostrarDialogoAcessibilidade(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.accessibility_new_outlined),
            SizedBox(width: 8),
            Text('Acessibilidade - Fonte'),
          ],
        ),
        content: ValueListenableBuilder<double>(
          valueListenable: AppTheme.textScaleFactorNotifier,
          builder: (context, scale, _) {
            final percent = (scale * 100).round();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tamanho atual: $percent%',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      tooltip: 'Diminuir Fonte',
                      icon: const Icon(Icons.remove),
                      onPressed: scale > 0.8
                          ? () => AppTheme.textScaleFactorNotifier.value = (scale - 0.15).clamp(0.8, 1.6)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () => AppTheme.textScaleFactorNotifier.value = 1.0,
                      child: const Text('Padrão'),
                    ),
                    const SizedBox(width: 16),
                    IconButton.filledTonal(
                      tooltip: 'Aumentar Fonte',
                      icon: const Icon(Icons.add),
                      onPressed: scale < 1.6
                          ? () => AppTheme.textScaleFactorNotifier.value = (scale + 0.15).clamp(0.8, 1.6)
                          : null,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Chapeador'),
        actions: [
          IconButton(
            tooltip: 'Acessibilidade (Tamanho da Fonte)',
            icon: const Icon(Icons.text_fields_rounded),
            onPressed: () => _mostrarDialogoAcessibilidade(context),
          ),
          IconButton(
            tooltip: 'Alternar Tema (Claro/Escuro)',
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              if (AppTheme.themeModeNotifier.value == ThemeMode.dark) {
                AppTheme.themeModeNotifier.value = ThemeMode.light;
              } else {
                AppTheme.themeModeNotifier.value = ThemeMode.dark;
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.engineering_rounded,
                        size: 56,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Painel do Profissional (Acesso Direterto)',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Gerencie os orçamentos enviados pelos clientes e consulte a sua agenda de serviços integrada.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.dashboard_outlined),
                label: const Text(
                  'Fila de Orçamentos Pendentes',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/admin');
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue.shade700,
                ),
                icon: const Icon(Icons.calendar_month_outlined),
                label: const Text(
                  'Agenda de Serviços (Google Calendar)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/agendamentos');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
