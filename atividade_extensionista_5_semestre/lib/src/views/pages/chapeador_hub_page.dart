import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../controllers/chapeador_auth_controller.dart';
import '../../core/theme/app_theme.dart';

class ChapeadorHubPage extends StatefulWidget {
  const ChapeadorHubPage({super.key});

  @override
  State<ChapeadorHubPage> createState() => _ChapeadorHubPageState();
}

class _ChapeadorHubPageState extends State<ChapeadorHubPage> {
  final ScrollController _scrollController = ScrollController();
  final _authController = ChapeadorAuthController();
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
        title: const Text('Área do Chapeador'),
        actions: [
          ListenableBuilder(
            listenable: _authController,
            builder: (context, _) {
              if (_authController.isLoggedIn) {
                return IconButton(
                  tooltip: 'Sair da Conta',
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await _authController.signOut();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sessão encerrada com sucesso.')),
                      );
                    }
                  },
                );
              }
              return IconButton(
                tooltip: 'Fazer Login',
                icon: const Icon(Icons.login),
                onPressed: () {
                  Navigator.pushNamed(context, '/chapeador_login');
                },
              );
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
                        'Painel do Profissional',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ListenableBuilder(
                        listenable: _authController,
                        builder: (context, _) {
                          if (_authController.isLoggedIn) {
                            return Text(
                              'Logado como: ${_authController.currentUser?.displayName ?? _authController.currentUser?.email}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                            );
                          }
                          return const Text(
                            'Status: Não autenticado. Faça login com o Google para gerenciar orçamentos e sincronizar a agenda.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.black87),
                          );
                        },
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
                  if (_authController.isLoggedIn) {
                    Navigator.pushNamed(context, '/admin');
                  } else {
                    Navigator.pushNamed(context, '/chapeador_login');
                  }
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
                  if (_authController.isLoggedIn) {
                    Navigator.pushNamed(context, '/agendamentos');
                  } else {
                    Navigator.pushNamed(context, '/chapeador_login');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
