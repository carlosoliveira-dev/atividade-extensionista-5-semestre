import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../widgets/emitir_proposta_dialog.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _controller = AdminDashboardController();

  @override
  void initState() {
    super.initState();
    _controller.carregarPendentes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Chapeador'),
        actions: [
          IconButton(
            tooltip: 'Agenda de Serviços',
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/agendamentos');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _controller.carregarPendentes,
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_controller.errorMessage!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _controller.carregarPendentes,
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              );
            }

            if (_controller.orcamentosPendentes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    const Text(
                      'Nenhum orçamento pendente na fila.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: _controller.orcamentosPendentes.length,
              itemBuilder: (context, index) {
                final item = _controller.orcamentosPendentes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.clienteNome,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Chip(
                              label: Text(
                                DateFormat('HH:mm - dd/MM').format(item.dataCriacao),
                                style: const TextStyle(fontSize: 11),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        Text('Veículo: ${item.veiculoModelo} (${item.veiculoPlaca})'),
                        Text('Contato: ${item.clienteTelefone}'),
                        const SizedBox(height: 8),
                        Text(
                          'Relato: ${item.descricaoDano.isEmpty ? 'Sem relato escrito.' : item.descricaoDano}',
                          style: TextStyle(color: Colors.grey.shade800, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Fotos Enviadas:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: item.fotos.length,
                            itemBuilder: (context, fIndex) {
                              final foto = item.fotos[fIndex];
                              final isLocalFile = File(foto.caminhoArquivo).existsSync();

                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: isLocalFile
                                      ? Image.file(
                                          File(foto.caminhoArquivo),
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.image_not_supported),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.admin_panel_settings, size: 16, color: Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Área de Ações do Chapeador',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  icon: const Icon(Icons.rate_review_outlined),
                                  label: const Text('Avaliar e Enviar Orçamento'),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => EmitirPropostaDialog(
                                        orcamento: item,
                                        controller: _controller,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.phone_outlined, size: 16),
                                      label: const Text('Contato'),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Contato do cliente: ${item.clienteTelefone}')),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.info_outline, size: 16),
                                      label: const Text('Detalhes'),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text('Detalhes: ${item.veiculoModelo}'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Cliente: ${item.clienteNome}'),
                                                Text('Telefone: ${item.clienteTelefone}'),
                                                Text('Placa: ${item.veiculoPlaca}'),
                                                Text('Data: ${DateFormat('dd/MM/yyyy HH:mm').format(item.dataCriacao)}'),
                                                const SizedBox(height: 8),
                                                const Text('Relato:', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Text(item.descricaoDano.isEmpty ? 'Nenhum' : item.descricaoDano),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Fechar'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
