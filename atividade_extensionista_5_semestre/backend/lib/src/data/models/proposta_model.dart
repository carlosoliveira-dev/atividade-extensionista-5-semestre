import '../../domain/entities/proposta.dart';
import 'agendamento_model.dart';

class PropostaModel extends Proposta {
  PropostaModel({
    required super.id,
    required super.orcamentoId,
    required super.valorEstimado,
    required super.prazoEntrega,
    super.observacoes,
    required super.dataEnvio,
    super.agendamento,
  });

  factory PropostaModel.fromJson(Map<String, dynamic> json) {
    return PropostaModel(
      id: json['id'] as String,
      orcamentoId: json['orcamento_id'] as String? ?? json['orcamentoId'] as String,
      valorEstimado: (json['valor_estimado'] ?? json['valorEstimado'] as num).toDouble(),
      prazoEntrega: json['prazo_entrega'] as String? ?? json['prazoEntrega'] as String,
      observacoes: json['observacoes'] as String?,
      dataEnvio: DateTime.parse(json['data_envio'] as String? ?? json['dataEnvio'] as String),
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
      'agendamento': agendamento != null ? AgendamentoModel.fromEntity(agendamento!).toJson() : null,
    };
  }

  factory PropostaModel.fromEntity(Proposta entity) {
    return PropostaModel(
      id: entity.id,
      orcamentoId: entity.orcamentoId,
      valorEstimado: entity.valorEstimado,
      prazoEntrega: entity.prazoEntrega,
      observacoes: entity.observacoes,
      dataEnvio: entity.dataEnvio,
      agendamento: entity.agendamento,
    );
  }
}
