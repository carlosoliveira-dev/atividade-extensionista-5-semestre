import 'agendamento_model.dart';

class PropostaModel {
  final String id;
  final String orcamentoId;
  final double valorEstimado;
  final String prazoEntrega;
  final String? observacoes;
  final DateTime dataEnvio;
  final AgendamentoModel? agendamento;

  PropostaModel({
    required this.id,
    required this.orcamentoId,
    required this.valorEstimado,
    required this.prazoEntrega,
    this.observacoes,
    required this.dataEnvio,
    this.agendamento,
  });

  factory PropostaModel.fromJson(Map<String, dynamic> json) {
    return PropostaModel(
      id: json['id'] as String? ?? '',
      orcamentoId: json['orcamentoId'] as String? ?? '',
      valorEstimado: (json['valorEstimado'] as num? ?? 0.0).toDouble(),
      prazoEntrega: json['prazoEntrega'] as String? ?? '',
      observacoes: json['observacoes'] as String?,
      dataEnvio: DateTime.parse(
        json['dataEnvio'] as String? ?? DateTime.now().toIso8601String(),
      ),
      agendamento: json['agendamento'] != null
          ? AgendamentoModel.fromJson(json['agendamento'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orcamentoId': orcamentoId,
      'valorEstimado': valorEstimado,
      'prazoEntrega': prazoEntrega,
      'observacoes': observacoes,
      'dataEnvio': dataEnvio.toIso8601String(),
      'agendamento': agendamento?.toJson(),
    };
  }
}
