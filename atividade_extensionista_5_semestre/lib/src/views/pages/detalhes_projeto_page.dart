import 'package:flutter/material.dart';

class DetalhesProjetoPage extends StatelessWidget {
  const DetalhesProjetoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes & Arquitetura'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.architecture, color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Arquitetura Full-Stack em Dart',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'O projeto foi desenvolvido inteiramente utilizando a linguagem Dart, garantindo coesão e compartilhamento de padrões entre o Front-end e o Back-end.',
                        style: TextStyle(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone_android, color: theme.colorScheme.secondary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Front-end (Flutter & MVVM)',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• Fricção Zero para o cliente (sem login ou cadastro).\n'
                        '• Compressão local de imagens antes do envio HTTP.\n'
                        '• Material Design 3 (M3) com suporte nativo a Dark Mode.\n'
                        '• Recursos de acessibilidade para redimensionamento de fonte.',
                        style: TextStyle(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.dns, color: theme.colorScheme.tertiary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Back-end (Dart Puro & Clean Architecture)',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• Separação estrita entre Domínio, Casos de Uso e Dados.\n'
                        '• Banco de dados PostgreSQL com fallback para memória em testes.\n'
                        '• Compilação para binário executável nativo no servidor Linux/Ubuntu.\n'
                        '• Autenticação administrativa por e-mail e senha com controle de sessões.\n'
                        '• Integração com Google Calendar para agendamento automático.',
                        style: TextStyle(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
