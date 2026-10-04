import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../../models/orcamento_model.dart';

class EmitirPropostaDialog extends StatefulWidget {
  final OrcamentoModel orcamento;
  final AdminDashboardController controller;

  const EmitirPropostaDialog({
    super.key,
    required this.orcamento,
    required this.controller,
  });

  @override
  State<EmitirPropostaDialog> createState() => _EmitirPropostaDialogState();
}

class _EmitirPropostaDialogState extends State<EmitirPropostaDialog> {
  final _valorController = TextEditingController();
  final _prazoController = TextEditingController(text: '2 dias úteis');
  final _obsController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now().add(const Duration(days: 1));
  DateTime? _horarioSelecionado;

  @override
  void initState() {
    super.initState();
    widget.controller.carregarHorariosLivres(_dataSelecionada);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Emitir Orçamento: ${widget.orcamento.veiculoModelo}'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: ListenableBuilder(
            listenable: widget.controller,
            builder: (context, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cliente: ${widget.orcamento.clienteNome} (${widget.orcamento.veiculoPlaca})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _valorController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Valor Estimado (R\$)',
                      hintText: 'Ex: 450.00',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _prazoController,
                    decoration: const InputDecoration(
                      labelText: 'Prazo de Entrega',
                      hintText: 'Ex: 2 dias úteis',
                      prefixIcon: Icon(Icons.timer_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _obsController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Observações Técnicas (Opcional)',
                      hintText: 'Ex: Inclui polimento e alinhamento',
                      prefixIcon: Icon(Icons.notes),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text(
                    'Sincronização com Google Calendar',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Data: ${DateFormat('dd/MM/yyyy').format(_dataSelecionada)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: const Text('Alterar Date'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _dataSelecionada,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 60)),
                          );
                          if (picked != null) {
                            setState(() {
                              _dataSelecionada = picked;
                              _horarioSelecionado = null;
                            });
                            widget.controller.carregarHorariosLivres(picked);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Slots Livres na Agenda:', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 6),
                  if (widget.controller.horariosLivres.isEmpty)
                    const Text('Nenhum horário livre encontrado.', style: TextStyle(fontSize: 11, color: Colors.grey))
                  else
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.controller.horariosLivres.map((h) {
                        final isSelected = _horarioSelecionado == h;
                        final horaFmt = DateFormat('HH:mm').format(h);
                        return ChoiceChip(
                          label: Text(horaFmt, style: const TextStyle(fontSize: 11)),
                          selected: isSelected,
                          onSelected: (val) {
                            setState(() {
                              _horarioSelecionado = val ? h : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.send),
          label: const Text('Disparar Orçamento'),
          onPressed: () async {
            final valStr = _valorController.text.replaceAll(',', '.').trim();
            final valor = double.tryParse(valStr);
            if (valor == null || valor <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Informe um valor numérico válido.')),
              );
              return;
            }

            final result = await widget.controller.emitirPropostaEAgendar(
              orcamentoId: widget.orcamento.id,
              valorEstimado: valor,
              prazoEntrega: _prazoController.text.trim(),
              observacoes: _obsController.text.trim(),
              dataHorarioAgendado: _horarioSelecionado,
            );

            if (result != null && context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proposta enviada e agendada no Google Calendar com sucesso!')),
              );
            }
          },
        ),
      ],
    );
  }
}
