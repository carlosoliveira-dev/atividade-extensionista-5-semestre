import 'package:flutter/material.dart';
import '../widgets/ods_badge.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            tooltip: 'Painel do Profissional (Chapeador)',
            icon: const Icon(Icons.admin_panel_settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/admin');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
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
                      'Funilaria & Pintura Assíncrona',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Precisa de um orçamento rápido sem sair de casa? Envie de 3 a 5 fotos do dano e receba a avaliação do especialista diretamente no seu WhatsApp.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Call to action button
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
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.dashboard_outlined),
              label: const Text('Acessar Fila do Chapeador'),
              onPressed: () {
                Navigator.pushNamed(context, '/admin');
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
            const Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                OdsBadge(
                  title: 'ODS 8 - Trabalho Decente',
                  description: 'Elimina interrupções no expediente do autônomo',
                  icon: Icons.work_outline,
                  color: Color(0xFFA21942),
                ),
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
    );
  }
}
