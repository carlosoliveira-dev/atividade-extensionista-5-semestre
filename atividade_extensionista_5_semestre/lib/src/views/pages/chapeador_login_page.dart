import 'package:flutter/material.dart';
import '../../controllers/chapeador_auth_controller.dart';

class ChapeadorLoginPage extends StatefulWidget {
  const ChapeadorLoginPage({super.key});

  @override
  State<ChapeadorLoginPage> createState() => _ChapeadorLoginPageState();
}

class _ChapeadorLoginPageState extends State<ChapeadorLoginPage> {
  final _emailController = TextEditingController(text: 'chapeador@impactcar.com');
  final _senhaController = TextEditingController(text: '123456');
  final _authController = ChapeadorAuthController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login do Chapeador'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.admin_panel_settings_rounded,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Painel Administrativo',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Entre com seu e-mail e senha para gerenciar os orçamentos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'chapeador@impactcar.com',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: '******',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListenableBuilder(
                    listenable: _authController,
                    builder: (context, _) {
                      if (_authController.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_authController.errorMessage != null) ...[
                            Text(
                              _authController.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                          ],
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            icon: const Icon(Icons.login),
                            label: const Text(
                              'Entrar',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              final success = await _authController.login(
                                _emailController.text,
                                _senhaController.text,
                              );
                              if (success && context.mounted) {
                                Navigator.pushReplacementNamed(context, '/admin');
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
