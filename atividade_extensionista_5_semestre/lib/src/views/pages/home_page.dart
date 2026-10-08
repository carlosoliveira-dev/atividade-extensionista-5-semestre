import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/ods_badge.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isFabVisible) {
          setState(() => _isFabVisible = false);
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_isFabVisible) {
          setState(() => _isFabVisible = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            tooltip: 'Área do Chapeador',
            icon: const Icon(Icons.engineering_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/chapeador_hub');
            },
          ),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isFabVisible ? 1.0 : 0.0,
          child: FloatingActionButton.extended(
            onPressed: _isFabVisible ? () => AppTheme.abrirMenuAcessibilidade(context) : null,
            icon: const Icon(Icons.accessibility_new_rounded),
            label: const Text('Acessibilidade'),
            tooltip: 'Abrir painel de acessibilidade e temas',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // Hero Section with centered workshop name
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
                      // Workshop Name Centered
                      Text(
                        'IMPACT CAR',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 6),
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
              // Centered Call to action button (Client)
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                      icon: const Icon(Icons.add_a_photo_rounded, size: 22),
                      label: const Text(
                        'Solicitar Orçamento sem Cadastro',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/novo_orcamento');
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Centered Chapeador Access Button
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      ),
                      icon: const Icon(Icons.engineering_outlined),
                      label: const Text(
                        'Acesso do Chapeador (Painel / Oficina)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/chapeador_hub');
                      },
                    ),
                  ),
                ),
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
