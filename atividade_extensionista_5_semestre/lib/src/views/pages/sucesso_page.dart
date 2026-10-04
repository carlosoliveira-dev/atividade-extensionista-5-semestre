import 'package:flutter/material.dart';
import '../../models/orcamento_model.dart';

class SucessoPage extends StatelessWidget {
  const SucessoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orcamento = ModalRoute.of(context)?.settings.arguments as OrcamentoModel?;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 80,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Solicitação Recebida com Sucesso!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (orcamento != null) ...[
                        Text(
                          'Código de Acompanhamento: #${orcamento.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                      ],
                      const Text(
                        'O chapeador analisará as imagens e a descrição no final do expediente e enviará a proposta com o valor e prazo diretamente no seu WhatsApp.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                icon: const Icon(Icons.home_outlined),
                label: const Text('Voltar ao Início'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
