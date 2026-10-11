import 'package:flutter/material.dart';
import '../widgets/ods_badge.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Impact Car'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 56,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Atividade Extensionista - 5º Semestre',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Gran Faculdade — Engenharia de Software / Ciência da Computação',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'O Impact Car é uma aplicação desenvolvida para otimizar o fluxo de triagem e orçamento assíncrono para profissionais autônomos (chapeadores e oficinas de pequeno porte).',
                        textAlign: TextAlign.center,
                        style: TextStyle(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Nossos Objetivos de Desenvolvimento Sustentável (ODS)',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const OdsBadge(
                title: 'ODS 8 - Trabalho Decente e Crescimento Econômico',
                description: 'Elimina interrupções presenciais desnecessárias no expediente do autônomo, permitindo o processamento em lote dos orçamentos no final do dia.',
                icon: Icons.work_outline,
                color: Color(0xFFA21942),
              ),
              const SizedBox(height: 12),
              const OdsBadge(
                title: 'ODS 13 - Ação Contra a Mudança Global do Clima',
                description: 'Reduz significativamente a emissão de CO2 ao evitar deslocamentos desnecessários para orçamentos presenciais.',
                icon: Icons.eco_outlined,
                color: Color(0xFF3F7E44),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
