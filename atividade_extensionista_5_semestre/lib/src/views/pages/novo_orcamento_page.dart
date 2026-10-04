import 'package:flutter/material.dart';
import '../../controllers/novo_orcamento_controller.dart';
import '../widgets/foto_picker_grid.dart';

class NovoOrcamentoPage extends StatefulWidget {
  const NovoOrcamentoPage({super.key});

  @override
  State<NovoOrcamentoPage> createState() => _NovoOrcamentoPageState();
}

class _NovoOrcamentoPageState extends State<NovoOrcamentoPage> {
  final _controller = NovoOrcamentoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Orçamento'),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Comprimindo fotos e enviando solicitação...'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_controller.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade400),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _controller.errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                const Text(
                  '1. Dados do Cliente',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller.nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Seu Nome Completo *',
                    hintText: 'Ex: João Silva',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller.telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'WhatsApp / Telefone para Contato *',
                    hintText: 'Ex: (11) 98765-4321',
                    prefixIcon: Icon(Icons.phone_android_outlined),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  '2. Identificação do Veículo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller.veiculoModeloController,
                  decoration: const InputDecoration(
                    labelText: 'Modelo do Veículo',
                    hintText: 'Ex: Honda Civic 2020',
                    prefixIcon: Icon(Icons.directions_car_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller.veiculoPlacaController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Placa do Veículo *',
                    hintText: 'Ex: ABC-1234 / BRA2E19',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  '3. Relato do Dano',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller.descricaoDanoController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descreva brevemente o que aconteceu',
                    hintText: 'Ex: Batida leve no parachoque traseiro com pequeno arranhão.',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),

                FotoPickerGrid(controller: _controller),
                const SizedBox(height: 32),

                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.send_rounded),
                  label: const Text(
                    'Enviar Solicitação para Avaliação',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    final ok = await _controller.enviarSolicitacao();
                    if (ok && context.mounted) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/sucesso',
                        arguments: _controller.orcamentoCriado,
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
