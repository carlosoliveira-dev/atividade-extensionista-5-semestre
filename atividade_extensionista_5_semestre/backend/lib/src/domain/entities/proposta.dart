import 'agendamento.dart';

class Proposta {
  final String id;
  final String orcamentoId;
  final double valorEstimado;
  final String prazoEntrega;
  final String? observacoes;
  final DateTime dataEnvio;
  final Agendamento? agendamento;

  Proposta({
    required this.id,
    required this.orcamentoId,
    required this.valorEstimado,
    required this.prazoEntrega,
    this.observacoes,
    required this.dataEnvio,
    this.agendamento,
  });
}
