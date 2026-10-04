enum StatusAgendamento {
  confirmado,
  realizado,
  cancelado,
}

class Agendamento {
  final String id;
  final String propostaId;
  final String idEventoExterno;
  final DateTime dataHorarioMarcados;
  final StatusAgendamento status;

  Agendamento({
    required this.id,
    required this.propostaId,
    required this.idEventoExterno,
    required this.dataHorarioMarcados,
    required this.status,
  });
}
