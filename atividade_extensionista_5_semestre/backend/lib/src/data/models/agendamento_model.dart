import '../../domain/entities/agendamento.dart';

class AgendamentoModel extends Agendamento {
  AgendamentoModel({
    required super.id,
    required super.propostaId,
    required super.idEventoExterno,
    required super.dataHorarioMarcados,
    required super.status,
  });

  factory AgendamentoModel.fromJson(Map<String, dynamic> json) {
    return AgendamentoModel(
      id: json['id'] as String,
      propostaId: json['proposta_id'] as String? ?? json['propostaId'] as String,
      idEventoExterno: json['id_evento_externo'] as String? ?? json['idEventoExterno'] as String,
      dataHorarioMarcados: DateTime.parse(json['data_horario_marcados'] as String? ?? json['dataHorarioMarcados'] as String),
      status: StatusAgendamento.values.firstWhere(
        (e) => e.name == (json['status'] as String),
        orElse: () => StatusAgendamento.confirmado,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propostaId': propostaId,
      'idEventoExterno': idEventoExterno,
      'dataHorarioMarcados': dataHorarioMarcados.toIso8601String(),
      'status': status.name,
    };
  }

  factory AgendamentoModel.fromEntity(Agendamento entity) {
    return AgendamentoModel(
      id: entity.id,
      propostaId: entity.propostaId,
      idEventoExterno: entity.idEventoExterno,
      dataHorarioMarcados: entity.dataHorarioMarcados,
      status: entity.status,
    );
  }
}
