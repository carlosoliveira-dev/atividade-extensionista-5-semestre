class AgendamentoModel {
  final String id;
  final String propostaId;
  final String idEventoExterno;
  final DateTime dataHorarioMarcados;
  final String status;

  AgendamentoModel({
    required this.id,
    required this.propostaId,
    required this.idEventoExterno,
    required this.dataHorarioMarcados,
    required this.status,
  });

  factory AgendamentoModel.fromJson(Map<String, dynamic> json) {
    return AgendamentoModel(
      id: json['id'] as String? ?? '',
      propostaId: json['propostaId'] as String? ?? '',
      idEventoExterno: json['idEventoExterno'] as String? ?? '',
      dataHorarioMarcados: DateTime.parse(
        json['dataHorarioMarcados'] as String? ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] as String? ?? 'confirmado',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propostaId': propostaId,
      'idEventoExterno': idEventoExterno,
      'dataHorarioMarcados': dataHorarioMarcados.toIso8601String(),
      'status': status,
    };
  }
}
