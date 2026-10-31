import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/agendamentos_controller.dart';
import '../../models/agendamento_model.dart';
import '../widgets/fullscreen_photo_viewer.dart';

class AgendamentosPage extends StatefulWidget {
  const AgendamentosPage({super.key});

  @override
  State<AgendamentosPage> createState() => _AgendamentosPageState();
}

class _AgendamentosPageState extends State<AgendamentosPage> {
  final _controller = AgendamentosController();

  @override
  void initState() {
    super.initState();
    _controller.carregarAgendamentos();
  }

  Uint8List? _decodeBase64Image(String str) {
    if (str.isEmpty || str.startsWith('http')) return null;
    if (str.startsWith('/data/') || str.startsWith('/storage/') || str.contains(':\\')) {
      return null;
    }
    try {
      String clean = str.trim();
      if (clean.contains(',')) {
        clean = clean.split(',').last;
      }
      return base64Decode(clean);
    } catch (e) {
      print('❌ [AGENDAMENTOS] Erro ao decodificar Base64 da foto (tamanho: ${str.length}): $e');
      return null;
    }
  }

  void _mostrarDetalhesProposta(BuildContext context, AgendamentoModel agendamento) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final detalhes = await _controller.buscarDetalhesProposta(agendamento.propostaId);

    if (context.mounted) {
      Navigator.pop(context); // fecha loading
    }

    if (detalhes == null || !context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível carregar os detalhes da proposta.')),
      );
      return;
    }

    final proposta = detalhes['proposta'] as Map<String, dynamic>?;
    final orcamento = detalhes['orcamento'] as Map<String, dynamic>?;

    final valor = proposta?['valorEstimado'] ?? proposta?['valor_estimado'] ?? 0.0;
    final prazo = proposta?['prazoEntrega'] ?? proposta?['prazo_entrega'] ?? '-';
    final obs = proposta?['observacoes'] ?? 'Nenhuma observação.';
    
    final clienteNome = orcamento?['clienteNome'] ?? orcamento?['cliente_nome'] ?? '-';
    final clienteTel = orcamento?['clienteTelefone'] ?? orcamento?['cliente_telefone'] ?? '-';
    final veiculo = orcamento?['veiculoModelo'] ?? orcamento?['veiculo_modelo'] ?? '-';
    final placa = orcamento?['veiculoPlaca'] ?? orcamento?['veiculo_placa'] ?? '-';
    final relato = orcamento?['descricaoDano'] ?? orcamento?['descricao_dano'] ?? '-';
    final fotos = (orcamento?['fotos'] as List<dynamic>?) ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalhes: $veiculo ($placa)'),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('👤 Dados do Cliente', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Nome: $clienteNome'),
                Text('Telefone/WhatsApp: $clienteTel'),
                const Divider(height: 24),
                const Text('💰 Proposta Comercial', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Valor Estimado: R\$ ${(valor is num ? valor.toDouble() : double.tryParse(valor.toString()) ?? 0.0).toStringAsFixed(2)}'),
                Text('Prazo de Entrega: $prazo'),
                Text('Observações: $obs'),
                const Divider(height: 24),
                const Text('📝 Relato do Dano', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(relato),
                const Divider(height: 24),
                const Text('📸 Fotos do Veículo (Toque para ampliar)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (fotos.isEmpty)
                  const Text('Nenhuma foto anexada.', style: TextStyle(color: Colors.grey))
                else
                  SizedBox(
                    height: 90,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: fotos.length,
                      itemBuilder: (context, fIdx) {
                        final foto = fotos[fIdx] as Map<String, dynamic>;
                        final rawData = (foto['urlAcesso'] as String? ?? foto['url_access'] as String? ?? '').isNotEmpty
                            ? (foto['urlAcesso'] as String? ?? foto['url_access'] as String? ?? '')
                            : (foto['caminhoArquivo'] as String? ?? foto['caminho_arquivo'] as String? ?? '');
                        final categoria = foto['ordemCategoria'] as String? ?? foto['ordem_categoria'] as String? ?? 'Foto';

                        Widget imageChild;
                        final decodedBytes = _decodeBase64Image(rawData);
                        if (decodedBytes != null) {
                          imageChild = Image.memory(decodedBytes, fit: BoxFit.cover);
                        } else if (rawData.startsWith('http')) {
                          imageChild = Image.network(rawData, fit: BoxFit.cover);
                        } else if (File(rawData).existsSync()) {
                          imageChild = Image.file(File(rawData), fit: BoxFit.cover);
                        } else {
                          imageChild = const Center(child: Icon(Icons.image_not_supported, color: Colors.grey));
                        }

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullscreenPhotoViewer(
                                  photoData: rawData,
                                  category: '$categoria (${fIdx + 1}/${fotos.length})',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: imageChild,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda de Serviços'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _controller.carregarAgendamentos,
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
                      onPressed: _controller.carregarAgendamentos,
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              );
            }

            if (_controller.agendamentos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    const Text(
                      'Nenhum agendamento gravado no banco de dados.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: _controller.agendamentos.length,
              itemBuilder: (context, index) {
                final item = _controller.agendamentos[index];
                final dataFmt = DateFormat('dd/MM/yyyy - HH:mm').format(item.dataHorarioMarcados);

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
                            Text(
                              'Data/Hora: $dataFmt',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Chip(
                              label: Text(
                                item.status.toUpperCase(),
                                style: const TextStyle(fontSize: 11, color: Colors.white),
                              ),
                              backgroundColor: Colors.green.shade700,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('ID Proposta: ${item.propostaId}'),
                        Text('ID Google Calendar: ${item.idEventoExterno}'),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
                                  Icon(Icons.calendar_month, size: 16, color: Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Gerenciamento de Agenda (Chapeador)',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                  ),
                                  icon: const Icon(Icons.event),
                                  label: const Text('Adicionar ao Google Calendar'),
                                  onPressed: () {
                                    _controller.adicionarAoGoogleCalendar(item);
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.info_outline),
                                  label: const Text('Ver Detalhes da Proposta & Fotos'),
                                  onPressed: () => _mostrarDetalhesProposta(context, item),
                                ),
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
