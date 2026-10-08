import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/ods_badge.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        title: const Text(
          'Impact Car',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
              if (AppTheme.textScaleFactorNotifier.value >= 0) { // Keep AppTheme imported
                // Toggle theme
              }
              if (AppTheme.themeModeNotifier.value == ThemeMode.dark) {
                AppTheme.themeModeNotifier.value = ThemeMode.light;
              } else {
                AppTheme.themeModeNotifier.value = ThemeMode.dark;
              }
            },
          ),
          IconButton(
            tooltip: 'Área do Chapeador',
            icon: const Icon(Icons.engineering_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/chapeador_hub');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // Hero Section
              Card(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.directions_car_filled_rounded,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Funilaria & Pintura — Orçamento Rápido',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Precisa de um orçamento rápido sem sair de casa? Envie de 3 a 5 fotos do dano e receba a avaliação do especialista diretamente.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          Chip(
                            avatar: const Icon(Icons.flash_on, size: 16),
                            label: const Text('Sem Fila'),
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          ),
                          Chip(
                            avatar: const Icon(Icons.lock_open, size: 16),
                            label: const Text('Sem Cadastro'),
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          ),
                          Chip(
                            avatar: const Icon(Icons.photo_camera, size: 16),
                            label: const Text('Envio de Fotos'),
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Call to action button (Client)
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: theme.colorScheme.primary,
                ),
                icon: const Icon(Icons.add_a_photo_rounded, size: 22),
                label: const Text(
                  'Solicitar Orçamento sem Cadastro',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/novo_orcamento');
                },
              ),
              const SizedBox(height: 16),
              // Chapeador Access Button (No login for now)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.engineering_outlined),
                label: const Text(
                  'Acesso do Chapeador (Painel / Oficina)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/chapeador_hub');
                },
              ),
              const SizedBox(height: 36),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Compromisso com o Desenvolvimento Sustentável',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Column(
                children: [
                  OdsBadge(
                    title: 'ODS 8 - Trabalho Decente',
                    description: 'Elimina interrupções no expediente do autônomo',
                    icon: Icons.work_outline,
                    color: Color(0xFFA21942),
                  ),
                  SizedBox(height: 10),
                  OdsBadge(
                    title: 'ODS 13 - Ação Climática',
                    description: 'Evita emissão de CO2 em deslocamentos',
                    icon: Icons.eco_outlined,
                    color: Color(0xFF3F7E44),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
